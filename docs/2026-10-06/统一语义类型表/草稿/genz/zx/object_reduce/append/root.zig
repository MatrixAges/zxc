const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Builder = @import("builder.zig");
const Capacity = @import("../../iteration_buffer/capacity.zig");
const Self = @This();
const Field = struct { path: []const u32, element: ir.TypeId, builder: Builder };
const Saved = struct { id: ir.ExprId, previous: ?Builder };
const SavedCall = struct { id: ir.ExprId, previous: ?[]const ?Builder };

lowering: *Lower,
type_id: ir.TypeId,
fields: std.ArrayList(Field) = .empty,
saved: std.ArrayList(Saved) = .empty,
saved_calls: std.ArrayList(SavedCall) = .empty,
pub fn init(lowering: *Lower, transform: ir.Transform, body: *std.ArrayList(node.Statement)) Lower.Error!Self {
    const type_id = lowering.program.expression(transform.body).type_id;
    var self = Self{ .lowering = lowering, .type_id = type_id };

    errdefer self.restore();

    var paths: std.ArrayList([]const u32) = .empty;

    defer paths.deinit(lowering.allocator);

    try @import("../../buffer_call/analysis/flow.zig").leaves(lowering.allocator, lowering.program, type_id, &.{}, false, &paths);

    for (paths.items) |path| {
        const projections = if (path.len == 1) try @import("analysis.zig").analyze(lowering.allocator, lowering.program, transform, path[0]) else null;
        const cross = try @import("../../buffer_call/reduce.zig").match(lowering, transform, path);

        if (projections == null and cross == null) continue;

        var selected = type_id;

        for (path) |part| selected = switch (lowering.program.typeOf(selected)) {
            .object => |items| items.at(part).type_id,
            .tuple => |items| items.at(part),
            else => unreachable,
        };

        const element = lowering.program.typeOf(selected).list;
        const name = try lowering.fresh("field_items");
        const started_name = try lowering.fresh("field_started");
        const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{lowering.types[@backingInt(element)]}, false);
        const builder = Builder{ .buffer = try lowering.builder.identifier(name), .started = try lowering.builder.identifier(started_name) };

        try body.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = try lowering.builder.expression(.{ .enum_literal = "empty" }) } });
        try body.append(lowering.allocator, .{ .variable = .{ .name = started_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });
        try body.append(lowering.allocator, .{ .defer_expression = try builder.method(lowering, "deinit", &.{}, false) });
        try self.fields.append(lowering.allocator, .{ .path = path, .element = element, .builder = builder });

        for (projections orelse &.{}) |id| {
            try self.saved.append(lowering.allocator, .{ .id = id, .previous = lowering.append_overrides.get(id) });
            try lowering.append_overrides.put(lowering.allocator, id, builder);
        }

        if (cross) |call| {
            try self.saved_calls.append(lowering.allocator, .{ .id = call.expression, .previous = lowering.buffer_calls.get(call.expression) });
            try @import("../../buffer_call/root.zig").bind(lowering, call.expression, call.lane, builder);
        }
    }

    return self;
}

pub fn restore(self: *Self) void {
    var index = self.saved_calls.items.len;

    while (index > 0) {
        index -= 1;
        const saved = self.saved_calls.items[index];

        if (saved.previous) |previous| self.lowering.buffer_calls.put(self.lowering.allocator, saved.id, previous) catch unreachable else _ = self.lowering.buffer_calls.remove(saved.id);
    }

    self.saved_calls.clearRetainingCapacity();

    for (self.saved.items) |saved| {
        if (saved.previous) |previous| self.lowering.append_overrides.put(self.lowering.allocator, saved.id, previous) catch unreachable else _ = self.lowering.append_overrides.remove(saved.id);
    }

    self.saved.clearRetainingCapacity();
}

pub fn finish(self: Self, body: *std.ArrayList(node.Statement), accumulator: *const node.Expression) Lower.Error!void {
    const lowering = self.lowering;

    for (self.fields.items) |field| {
        const selected = lowering.program.typeOf(self.type_id).object.at(field.path[0]);
        const target = try lowering.field(accumulator, selected.name);
        const source = try @import("writeback.zig").project(lowering, self.type_id, accumulator, field.path);
        const capacity = Capacity{ .buffer = field.builder.buffer, .started = field.builder.started };
        const owned = try capacity.take(lowering, body, source, lowering.types[@backingInt(field.element)]);
        const value = try @import("writeback.zig").replace(lowering, selected.type_id, target, field.path[1..], owned);
        var writes: std.ArrayList(node.Statement) = .empty;

        try writes.append(lowering.allocator, .{ .assignment = .{
            .target = target,
            .value = value,
        } });

        try @import("../../state_value/origin.zig").clear(lowering, &writes, self.type_id, accumulator);
        try body.append(lowering.allocator, .{ .branch = .{ .condition = field.builder.started, .yes = try writes.toOwnedSlice(lowering.allocator), .no = &.{} } });
    }
}
