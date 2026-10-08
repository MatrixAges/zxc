const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Capacity = @import("capacity.zig");
const Self = @This();
const Builder = @import("../object_reduce/append/builder.zig");
const SavedUpdate = struct { id: ir.ExprId, storage: @import("../list_update.zig").Storage };
const SavedCall = struct { id: ir.ExprId, previous: ?[]const ?Builder };
const Field = struct { path: []const usize, element: ir.TypeId, storage: Capacity };

lowering: *Lower,
overrides: std.ArrayList(ir.ExprId) = .empty,
fields: std.ArrayList(Field) = .empty,
calls: std.ArrayList(SavedCall) = .empty,
saved_updates: std.ArrayList(SavedUpdate) = .empty,
readers: []const bool = &.{},
mutable_state: bool,
pub fn init(lowering: *Lower, iteration: ir.Iteration, body: *std.ArrayList(node.Statement), enabled: bool, mutable_state: bool) Lower.Error!Self {
    var self = Self{ .lowering = lowering, .mutable_state = mutable_state };

    errdefer self.restore();

    if (!enabled) return self;

    const readers = try lowering.allocator.alloc(bool, lowering.program.functions.count());

    for (0..lowering.program.functions.count()) |index| {
        const function = lowering.program.functions.at(index);
        readers[index] = index < lowering.pure_functions.len and lowering.pure_functions[index] and @import("../buffer_call/analysis/flow.zig").detached(lowering.program, function.output_type);
    }

    self.readers = readers;

    var path: std.ArrayList(usize) = .empty;

    try self.collect(iteration, body, lowering.program.expression(iteration.initial).type_id, &path);

    return self;
}

fn collect(self: *Self, iteration: ir.Iteration, body: *std.ArrayList(node.Statement), id: ir.TypeId, path: *std.ArrayList(usize)) Lower.Error!void {
    const lowering = self.lowering;
    const target = lowering.program.typeOf(id);

    switch (target) {
        .object => |fields| for (0..fields.len, 0..) |view_index, index| {
            const field = fields.at(view_index);

            try path.append(lowering.allocator, index);
            try self.collect(iteration, body, field.type_id, path);

            _ = path.pop();
        },
        .tuple => |items| for (0..items.len, 0..) |item_index, index| {
            const item = items.at(item_index);

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
    const result = try @import("analysis.zig").analyzeWithCalls(lowering.allocator, lowering.program, iteration, path, .{ .selected = &.{}, .summaries = lowering.buffer_functions, .readers = self.readers, .discover = true }) orelse return;
    const updates = result.updates;

    for (result.calls) |call| if (lowering.buffer_calls.get(call.expression)) |slots| if (slots[call.lane] != null) return;

    var fallback = false;

    for (updates) |update| {
        if (lowering.collection_buffers.contains(update)) return;

        if (lowering.list_update_buffers.get(update)) |shared| {
            if (shared.enabled == null or shared.fallback_capacity != null) return;

            fallback = true;
        }
    }

    if (lowering.iteration_value) |context| if (context.inline_lists and @import("../iteration_layout.zig").represented(lowering.program, child)) {
        try self.installCapacity(body, child, path, updates, result.calls);

        return;
    };

    var dynamic = result.calls.len != 0 or fallback;
    var writes = result.calls.len != 0;

    for (updates) |update| switch (lowering.program.expression(update).value) {
        .list_operation => |operation| {
            dynamic = true;
            writes = writes or (operation.kind != .pop and operation.kind != .splice);
        },
        .list_update => writes = true,
        else => unreachable,
    };

    if (dynamic) {
        if (self.mutable_state and writes) try self.installCapacity(body, child, path, updates, result.calls);

        return;
    }

    const buffer_name = try lowering.fresh("state_items");
    const started_name = try lowering.fresh("state_items_started");

    const storage = @import("../list_update.zig").Storage{
        .buffer = try lowering.builder.identifier(buffer_name),
        .started = try lowering.builder.identifier(started_name),
        .transfer = try @import("ownership/root.zig").check(lowering.allocator, lowering.program, iteration.initial, path, lowering.allocated_functions),
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

fn installCapacity(self: *Self, body: *std.ArrayList(node.Statement), child: ir.TypeId, path: []const usize, updates: []const ir.ExprId, calls: []const @import("../buffer_call/analysis/flow.zig").Call) Lower.Error!void {
    const lowering = self.lowering;
    const capacity = try Capacity.create(lowering, body, try @import("../iteration_value/types.zig").element(lowering, child));

    try self.fields.append(lowering.allocator, .{ .path = try lowering.allocator.dupe(usize, path), .element = child, .storage = capacity });

    for (calls) |call| {
        const saved = for (self.calls.items) |previous| {
            if (previous.id == call.expression) break true;
        } else false;

        if (!saved) try self.calls.append(lowering.allocator, .{ .id = call.expression, .previous = lowering.buffer_calls.get(call.expression) });
        try @import("../buffer_call/root.zig").bind(lowering, call.expression, call.lane, .{ .buffer = capacity.buffer, .started = capacity.started });
    }

    for (updates) |update| {
        try self.overrides.append(lowering.allocator, update);

        if (lowering.program.expression(update).value == .list_update) {
            if (lowering.list_update_buffers.get(update)) |previous| {
                try self.saved_updates.append(lowering.allocator, .{ .id = update, .storage = previous });

                var shared = previous;
                shared.fallback_capacity = capacity;

                try lowering.list_update_buffers.put(lowering.allocator, update, shared);
            } else try lowering.list_update_buffers.put(lowering.allocator, update, .{ .buffer = try capacity.items(lowering), .started = capacity.started, .capacity = capacity });
        } else try lowering.collection_buffers.put(lowering.allocator, update, capacity);
    }
}

pub fn finish(self: Self, body: *std.ArrayList(node.Statement), state: *const node.Expression, type_id: ir.TypeId, deep: bool) Lower.Error!void {
    const lowering = self.lowering;

    for (self.fields.items) |field| {
        if (!deep) {
            const path = try lowering.allocator.alloc(u32, field.path.len);

            for (field.path, path) |part, *output| output.* = @intCast(part);

            const writeback = @import("../object_reduce/append/writeback.zig");
            const source = try writeback.project(lowering, type_id, state, path);
            const owned = try field.storage.take(lowering, body, source, lowering.types[@backingInt(field.element)]);
            const updated = try writeback.replaceLayout(lowering, type_id, state, path, owned);

            try body.append(lowering.allocator, .{ .branch = .{
                .condition = field.storage.started,
                .yes = try lowering.allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = state, .value = updated } }}),
                .no = &.{},
            } });

            continue;
        }

        var target = state;
        var current = type_id;
        var invalidation: std.ArrayList(node.Statement) = .empty;

        for (field.path) |index| {
            try @import("../state_value/origin.zig").clear(lowering, &invalidation, current, target);

            switch (lowering.program.typeOf(current)) {
                .object => |fields| {
                    target = try lowering.field(target, fields.at(index).name);
                    current = fields.at(index).type_id;
                },
                .tuple => |items| {
                    target = try lowering.field(target, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
                    current = items.at(index);
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
    for (self.calls.items) |saved| {
        if (saved.previous) |previous| self.lowering.buffer_calls.put(self.lowering.allocator, saved.id, previous) catch unreachable else _ = self.lowering.buffer_calls.remove(saved.id);
    }

    self.calls.clearRetainingCapacity();

    for (self.overrides.items) |id| {
        _ = self.lowering.list_update_buffers.remove(id);
        _ = self.lowering.collection_buffers.remove(id);
    }

    self.overrides.clearRetainingCapacity();

    for (self.saved_updates.items) |saved| self.lowering.list_update_buffers.put(self.lowering.allocator, saved.id, saved.storage) catch unreachable;

    self.saved_updates.clearRetainingCapacity();
}

fn element(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference, .object, .tuple => true,
        .optional => |child| element(program, child),
        else => false,
    };
}
