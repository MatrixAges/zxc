const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Builder = @import("builder.zig");
const Self = @This();
const Field = struct { name: []const u8, builder: Builder };
const Saved = struct { id: ir.ExprId, previous: ?Builder };

lowering: *Lower,
fields: std.ArrayList(Field) = .empty,
saved: std.ArrayList(Saved) = .empty,
pub fn init(lowering: *Lower, transform: ir.Transform, body: *std.ArrayList(node.Statement)) Lower.Error!Self {
    var self = Self{ .lowering = lowering };

    errdefer self.restore();

    const fields = lowering.program.typeOf(lowering.program.expression(transform.body).type_id).object;

    for (fields, 0..) |field, index| {
        const field_type = lowering.program.typeOf(field.type_id);

        if (field_type != .list) continue;

        const projections = try @import("analysis.zig").analyze(lowering.allocator, lowering.program, transform, @intCast(index)) orelse continue;
        const name = try lowering.fresh("field_items");
        const started_name = try lowering.fresh("field_started");
        const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{lowering.types[@intFromEnum(field_type.list)]}, false);
        const builder = Builder{ .buffer = try lowering.builder.identifier(name), .started = try lowering.builder.identifier(started_name) };

        try body.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = try lowering.builder.expression(.{ .enum_literal = "empty" }) } });
        try body.append(lowering.allocator, .{ .variable = .{ .name = started_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });
        try body.append(lowering.allocator, .{ .defer_expression = try builder.method(lowering, "deinit", &.{}, false) });
        try self.fields.append(lowering.allocator, .{ .name = field.name, .builder = builder });

        for (projections) |id| {
            try self.saved.append(lowering.allocator, .{ .id = id, .previous = lowering.append_overrides.get(id) });
            try lowering.append_overrides.put(lowering.allocator, id, builder);
        }
    }

    return self;
}

pub fn restore(self: *Self) void {
    for (self.saved.items) |saved| {
        if (saved.previous) |previous| self.lowering.append_overrides.put(self.lowering.allocator, saved.id, previous) catch unreachable else _ = self.lowering.append_overrides.remove(saved.id);
    }

    self.saved.clearRetainingCapacity();
}

pub fn finish(self: Self, body: *std.ArrayList(node.Statement), accumulator: *const node.Expression) Lower.Error!void {
    const lowering = self.lowering;

    for (self.fields.items) |field| try body.append(lowering.allocator, .{ .branch = .{ .condition = field.builder.started, .yes = try lowering.allocator.dupe(node.Statement, &.{.{ .assignment = .{
        .target = try lowering.field(accumulator, field.name),
        .value = try field.builder.method(lowering, "toOwnedSlice", &.{}, true),
    } }}), .no = &.{} } });
}
