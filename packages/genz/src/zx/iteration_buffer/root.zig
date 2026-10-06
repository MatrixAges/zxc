const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Capacity = @import("capacity.zig");
const Self = @This();
const Field = struct { path: []const usize, element: ir.TypeId, storage: Capacity };

lowering: *Lower,
overrides: std.ArrayList(ir.ExprId) = .empty,
fields: std.ArrayList(Field) = .empty,
mutable_state: bool,
pub fn init(lowering: *Lower, iteration: ir.Iteration, body: *std.ArrayList(node.Statement), enabled: bool, mutable_state: bool) Lower.Error!Self {
    var self = Self{ .lowering = lowering, .mutable_state = mutable_state };

    errdefer self.restore();

    if (!enabled) return self;

    var path: std.ArrayList(usize) = .empty;

    try self.collect(iteration, body, lowering.program.expression(iteration.initial).type_id, &path);

    return self;
}

fn collect(self: *Self, iteration: ir.Iteration, body: *std.ArrayList(node.Statement), id: ir.TypeId, path: *std.ArrayList(usize)) Lower.Error!void {
    const lowering = self.lowering;
    const target = lowering.program.typeOf(id);

    switch (target) {
        .object => |fields| for (fields, 0..) |field, index| {
            try path.append(lowering.allocator, index);
            try self.collect(iteration, body, field.type_id, path);

            _ = path.pop();
        },
        .tuple => |items| for (items, 0..) |item, index| {
            try path.append(lowering.allocator, index);
            try self.collect(iteration, body, item, path);

            _ = path.pop();
        },
        .list => |child| {
            if (element(lowering.program, child)) try self.install(iteration, body, child, path.items);
        },
        else => {},
    }
}

fn install(self: *Self, iteration: ir.Iteration, body: *std.ArrayList(node.Statement), child: ir.TypeId, path: []const usize) Lower.Error!void {
    const lowering = self.lowering;
    const updates = try @import("analysis.zig").analyze(lowering.allocator, lowering.program, iteration, path) orelse return;

    const overlap = for (updates) |update| {
        if (lowering.list_update_buffers.contains(update) or lowering.collection_buffers.contains(update)) break true;
    } else false;

    if (overlap) return;

    var dynamic = false;
    var writes = false;

    for (updates) |update| switch (lowering.program.expression(update).value) {
        .list_operation => |operation| {
            dynamic = true;
            writes = writes or operation.kind != .pop;
        },
        .list_update => writes = true,
        else => unreachable,
    };

    if (dynamic) {
        if (self.mutable_state and writes) try self.installCapacity(body, child, path, updates);

        return;
    }

    const buffer_name = try lowering.fresh("state_items");
    const started_name = try lowering.fresh("state_items_started");

    const storage = @import("../list_update.zig").Storage{
        .buffer = try lowering.builder.identifier(buffer_name),
        .started = try lowering.builder.identifier(started_name),
    };

    try body.append(lowering.allocator, .{ .variable = .{
        .name = buffer_name,
        .type_expr = try lowering.builder.expression(.{ .mutable_slice = lowering.types[@backingInt(child)] }),
        .value = try lowering.builder.expression(.undefined_value),
    } });

    try body.append(lowering.allocator, .{ .variable = .{ .name = started_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });

    for (updates) |update| {
        try self.overrides.append(lowering.allocator, update);
        try lowering.list_update_buffers.put(lowering.allocator, update, storage);
    }
}

fn installCapacity(self: *Self, body: *std.ArrayList(node.Statement), child: ir.TypeId, path: []const usize, updates: []const ir.ExprId) Lower.Error!void {
    const lowering = self.lowering;
    const capacity = try Capacity.create(lowering, body, lowering.types[@backingInt(child)]);

    try self.fields.append(lowering.allocator, .{ .path = try lowering.allocator.dupe(usize, path), .element = child, .storage = capacity });

    for (updates) |update| {
        try self.overrides.append(lowering.allocator, update);

        if (lowering.program.expression(update).value == .list_update) {
            try lowering.list_update_buffers.put(lowering.allocator, update, .{ .buffer = try capacity.items(lowering), .started = capacity.started, .capacity = capacity });
        } else try lowering.collection_buffers.put(lowering.allocator, update, capacity);
    }
}

pub fn finish(self: Self, body: *std.ArrayList(node.Statement), state: *const node.Expression, type_id: ir.TypeId) Lower.Error!void {
    const lowering = self.lowering;

    for (self.fields.items) |field| {
        var target = state;
        var current = type_id;
        var invalidation: std.ArrayList(node.Statement) = .empty;

        for (field.path) |index| {
            try @import("../state_value/origin.zig").clear(lowering, &invalidation, current, target);

            switch (lowering.program.typeOf(current)) {
                .object => |fields| {
                    target = try lowering.field(target, fields[index].name);
                    current = fields[index].type_id;
                },
                .tuple => |items| {
                    target = try lowering.field(target, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
                    current = items[index];
                },
                else => unreachable,
            }
        }

        try field.storage.finish(lowering, body, target, lowering.types[@backingInt(field.element)]);

        if (invalidation.items.len != 0) try body.append(lowering.allocator, .{ .branch = .{
            .condition = field.storage.started,
            .yes = try invalidation.toOwnedSlice(lowering.allocator),
            .no = &.{},
        } });
    }
}

pub fn restore(self: *Self) void {
    for (self.overrides.items) |id| {
        _ = self.lowering.list_update_buffers.remove(id);
        _ = self.lowering.collection_buffers.remove(id);
    }

    self.overrides.clearRetainingCapacity();
}

fn element(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| element(program, child),
        else => false,
    };
}
