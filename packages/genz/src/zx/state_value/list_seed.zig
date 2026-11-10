const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
pub const Storage = enum { plain, owned, shared, exclusive };

pub fn selected(self: *const Lower, id: ir.TypeId) bool {
    return self.state_active and self.state_plan.selected[@backingInt(id)] and self.program.typeOf(id) == .list;
}

pub fn definition(self: *Lower, id: ir.TypeId, child: ir.TypeId) Lower.Error!node.ExpressionId {
    const element = if (self.program.typeOf(child) == .list and @import("elements.zig").inlineStored(self, id)) self.state_types else if (self.program.typeOf(child) == .object and self.state_plan.selected[@backingInt(child)]) self.abi_layouts else self.abi_types;
    const slice_type = try self.builder.expression(.{ .const_slice = try @import("../types.zig").get(self, element, child) });

    const storage_type = try self.builder.expression(.{ .enum_type = .{
        .members = &.{ "plain", "owned", "shared", "exclusive" },
        .base = try self.builder.expression(.{ .primitive = .usize }),
    } });

    return self.builder.expression(.{ .struct_type = try self.allocator.dupe(node.Field, &.{
        .{ .name = "items", .value = slice_type },
        .{ .name = "storage", .value = storage_type },
    }) });
}

pub fn tag(self: *Lower, storage: Storage) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .enum_literal = @tagName(storage) });
}

pub fn headered(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const storage = try self.field(value, "storage");

    return @import("../intrinsics.zig").binary(self, .greater_equal, try self.builtin(.intFromEnum, &.{storage}), try self.builder.integer(@backingInt(Storage.shared)));
}

pub fn exclusive(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return @import("../intrinsics.zig").binary(self, .equal, try self.field(value, "storage"), try tag(self, .exclusive));
}

pub fn writable(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const storage = try self.builtin(.intFromEnum, &.{try self.field(value, "storage")});
    const permission = try self.builtin(.rem, &.{ storage, try self.builder.integer(@backingInt(Storage.shared)) });

    return @import("../intrinsics.zig").binary(self, .not_equal, permission, try self.builder.integer(@backingInt(Storage.plain)));
}

pub fn weakened(self: *Lower, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return choose(self, try headered(self, value), .shared, .plain);
}

fn choose(self: *Lower, condition: node.ExpressionId, yes: Storage, no: Storage) Lower.Error!node.ExpressionId {
    const value = self.builder.nodes.get(condition);

    if (value == .boolean) return tag(self, if (value.boolean) yes else no);

    return self.builder.expression(.{ .conditional = .{ .condition = condition, .yes = try tag(self, yes), .no = try tag(self, no) } });
}

pub fn create(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, has_header: node.ExpressionId) Lower.Error!node.ExpressionId {
    return construct(self, id, slice, try choose(self, has_header, .shared, .plain));
}

pub fn proven(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, has_header: node.ExpressionId, is_unique: node.ExpressionId) Lower.Error!node.ExpressionId {
    const header = self.builder.nodes.get(has_header);

    const storage = if (header == .boolean)
        (if (header.boolean) try choose(self, is_unique, .exclusive, .shared) else try choose(self, is_unique, .owned, .plain))

    else if (has_header == is_unique)
        try choose(self, has_header, .exclusive, .plain)
    else
        try self.builder.expression(.{ .conditional = .{ .condition = has_header, .yes = try choose(self, is_unique, .exclusive, .shared), .no = try choose(self, is_unique, .owned, .plain) } });

    return construct(self, id, slice, storage);
}

pub fn owned(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, has_header: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!selected(self, id)) return slice;

    return proven(self, id, slice, has_header, try self.builder.expression(.{ .boolean = true }));
}

fn construct(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, storage: node.ExpressionId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .object = .{
        .type_expr = try @import("../types.zig").get(self, self.state_types, id),
        .fields = try self.allocator.dupe(node.Field, &.{
            .{ .name = "items", .value = slice },
            .{ .name = "storage", .value = storage },
        }),
    } });
}

pub fn borrowed(self: *Lower, id: ir.TypeId, slice: node.ExpressionId) Lower.Error!node.ExpressionId {
    return create(self, id, slice, try self.builder.expression(.{ .boolean = false }));
}

pub fn items(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!selected(self, id)) return value;

    const expression_value = self.builder.nodes.get(value);

    if (expression_value == .object) {
        const fields = expression_value.object.fields;

        if (fields.len == 2) {
            const first = self.builder.nodes.field_columns.get(fields.start);
            const second = self.builder.nodes.field_columns.get(fields.start + 1);

            if (std.mem.eql(u8, first.name, "items") and std.mem.eql(u8, second.name, "storage")) return first.value;
        }
    }

    return self.field(value, "items");
}

pub fn reserve(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const source = try aggregate.bind(self, body, value);
    const view = try self.field(source, "items");
    var yes: std.ArrayList(node.Statement) = .empty;
    var no: std.ArrayList(node.Statement) = .empty;
    const element = try @import("elements.zig").typeExpr(self, id);
    const copied = try @import("../growth.zig").reserve(self, &no, element, view, count, false);

    const result = if (frontier) chosen: {
        const extended = try @import("../growth.zig").reserve(self, &yes, element, view, count, true);

        break :chosen try self.builder.expression(.{ .conditional = .{
            .condition = try headered(self, source),
            .yes = try aggregate.finish(self, &yes, extended),
            .no = try aggregate.finish(self, &no, copied),
        } });
    } else try aggregate.finish(self, &no, copied);

    return aggregate.bind(self, body, result);
}

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    return items(self, self.program.expression(id).type_id, try self.expr(id));
}

pub fn wrap(self: *Lower, id: ir.TypeId, value: node.ExpressionId, has_header: bool) Lower.Error!node.ExpressionId {
    if (!selected(self, id)) return value;

    return create(self, id, value, try self.builder.expression(.{ .boolean = has_header }));
}
