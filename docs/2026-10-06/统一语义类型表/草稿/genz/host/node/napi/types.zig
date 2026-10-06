const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{UnsupportedNodeType};

builder: Builder,
values: ir.TypeTable,
aliases: []?*const node.Expression,
reads: []bool,
writes: []bool,
pub fn init(builder: Builder, values: ir.TypeTable) std.mem.Allocator.Error!Self {
    const aliases = try builder.allocator.alloc(?*const node.Expression, values.count());
    const reads = try builder.allocator.alloc(bool, values.count());
    const writes = try builder.allocator.alloc(bool, values.count());

    @memset(aliases, null);
    @memset(reads, false);
    @memset(writes, false);

    return .{ .builder = builder, .values = values, .aliases = aliases, .reads = reads, .writes = writes };
}

pub fn mark(self: Self, id: ir.TypeId, source: *const node.Expression, incoming: bool) Error!void {
    const index = @backingInt(id);
    const seen = if (incoming) self.reads else self.writes;

    if (seen[index]) return;

    seen[index] = true;

    if (self.aliases[index] == null) self.aliases[index] = source;

    const builder = self.builder;
    const parent = try self.typeExpression(id);

    switch (self.values.at(index)) {
        .task => return error.UnsupportedNodeType,
        .optional, .list => |child| {
            const info = try builder.builtin(.typeInfo, &.{parent});
            const kind = if (self.values.at(index) == .optional) "optional" else "pointer";

            try self.mark(child, try builder.field(try builder.field(info, kind), "child"), incoming);
        },
        .object => |fields| for (0..fields.len) |view_index| {
            const field = fields.at(view_index);

            try self.mark(field.type_id, try self.fieldType(id, field.name), incoming);
        },
        .tuple => |children| for (0..children.len) |position| {
            const child = children.at(position);

            try self.mark(child, try self.fieldType(id, try std.fmt.allocPrint(builder.allocator, "{d}", .{position})), incoming);
        },
        else => {},
    }
}

pub fn name(self: Self, prefix: []const u8, id: ir.TypeId) std.mem.Allocator.Error![]const u8 {
    return std.fmt.allocPrint(self.builder.allocator, "{s}{d}", .{ prefix, @backingInt(id) });
}

pub fn typeExpression(self: Self, id: ir.TypeId) std.mem.Allocator.Error!*const node.Expression {
    return self.builder.identifier(try self.name("Type", id));
}

pub fn layout(self: Self, id: ir.TypeId) std.mem.Allocator.Error!*const node.Expression {
    return self.builder.field(try self.builder.field(try self.builder.builtin(.typeInfo, &.{try self.typeExpression(id)}), "pointer"), "child");
}

fn fieldType(self: Self, id: ir.TypeId, field: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return self.builder.builtin(.FieldType, &.{ try self.layout(id), try self.builder.string(field) });
}
