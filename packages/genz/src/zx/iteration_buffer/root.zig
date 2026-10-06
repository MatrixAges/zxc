const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Self = @This();

lowering: *Lower,
overrides: std.ArrayList(ir.ExprId) = .empty,
pub fn init(lowering: *Lower, iteration: ir.Iteration, body: *std.ArrayList(node.Statement), enabled: bool) Lower.Error!Self {
    var self = Self{ .lowering = lowering };

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
        if (lowering.list_update_buffers.contains(update)) break true;
    } else false;

    if (overlap) return;

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

pub fn restore(self: *Self) void {
    for (self.overrides.items) |id| _ = self.lowering.list_update_buffers.remove(id);

    self.overrides.clearRetainingCapacity();
}

fn element(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| element(program, child),
        else => false,
    };
}
