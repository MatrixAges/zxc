const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn selected(self: *const Lower, id: ir.TypeId) bool {
    return self.state_active and self.state_plan.selected[@backingInt(id)] and self.program.typeOf(id) == .list;
}

pub fn definition(self: *Lower, child: ir.TypeId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .struct_type = try self.allocator.dupe(node.Field, &.{
        .{ .name = "items", .value = try self.builder.expression(.{ .const_slice = try @import("../types.zig").get(self, self.abi_types, child) }) },
        .{ .name = "headered", .value = try self.builder.expression(.{ .primitive = .bool }) },
    }) });
}

pub fn create(self: *Lower, id: ir.TypeId, slice: node.ExpressionId, headered: node.ExpressionId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .object = .{
        .type_expr = try @import("../types.zig").get(self, self.state_types, id),
        .fields = try self.allocator.dupe(node.Field, &.{
            .{ .name = "items", .value = slice },
            .{ .name = "headered", .value = headered },
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

            if (std.mem.eql(u8, first.name, "items") and std.mem.eql(u8, second.name, "headered")) return first.value;
        }
    }

    return self.field(value, "items");
}

pub fn reserve(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const child = self.program.typeOf(id).list;
    const source = try aggregate.bind(self, body, value);
    const view = try self.field(source, "items");
    var yes: std.ArrayList(node.Statement) = .empty;
    var no: std.ArrayList(node.Statement) = .empty;
    const element = try @import("../types.zig").get(self, self.abi_types, child);
    const copied = try @import("../growth.zig").reserve(self, &no, element, view, count, false);

    const result = if (frontier) chosen: {
        const extended = try @import("../growth.zig").reserve(self, &yes, element, view, count, true);

        break :chosen try self.builder.expression(.{ .conditional = .{
            .condition = try self.field(source, "headered"),
            .yes = try aggregate.finish(self, &yes, extended),
            .no = try aggregate.finish(self, &no, copied),
        } });
    } else try aggregate.finish(self, &no, copied);

    return aggregate.bind(self, body, result);
}

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    return items(self, self.program.expression(id).type_id, try self.expr(id));
}

pub fn wrap(self: *Lower, id: ir.TypeId, value: node.ExpressionId, headered: bool) Lower.Error!node.ExpressionId {
    if (!selected(self, id)) return value;

    return create(self, id, value, try self.builder.expression(.{ .boolean = headered }));
}
