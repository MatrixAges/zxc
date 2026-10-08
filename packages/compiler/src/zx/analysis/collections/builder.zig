const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("../analyzer.zig");
const Types = @import("../types.zig");
const Self = @This();

pub const Field = struct { name: []const u8, value: ir.ExprId };

analyzer: *Analyzer,
span: zx.Span,
pub fn expression(self: Self, type_id: ir.TypeId, value: @FieldType(ir.Expression, "value")) zx.Error!ir.ExprId {
    return self.analyzer.append(.{ .span = self.span, .type_id = type_id, .value = value });
}

pub fn symbol(self: Self, name: []const u8, type_id: ir.TypeId) zx.Error!ir.SymbolId {
    const id: ir.SymbolId = @fromBackingInt(@intCast(self.analyzer.symbols.count()));

    try self.analyzer.symbols.append(self.analyzer.allocator, .{ .name = name, .type_id = type_id, .span = self.span });

    return id;
}

pub fn reference(self: Self, id: ir.SymbolId) zx.Error!ir.ExprId {
    return self.expression(self.analyzer.symbols.at(@backingInt(id)).type_id, .{ .reference = id });
}

pub fn integer(self: Self, value: u64) zx.Error!ir.ExprId {
    return self.expression(Types.scalarId(.u64), .{ .integer = value });
}

pub fn field(self: Self, target: ir.ExprId, name: []const u8) zx.Error!ir.ExprId {
    const fields = self.analyzer.types.get(self.analyzer.node(target).type_id).object;

    for (0..fields.len) |index| {
        const selected = fields.at(index);

        if (std.mem.eql(u8, selected.name, name)) return self.expression(selected.type_id, .{ .field = .{ .target = target, .index = @intCast(index) } });
    }

    unreachable;
}

pub fn object(self: Self, values: []const Field) zx.Error!ir.ExprId {
    const fields = try Types.Fields.init(self.analyzer.allocator, values.len);
    const evaluation = try self.analyzer.allocator.alloc(ir.ExprId, values.len);

    for (values, evaluation, 0..) |value, *evaluated, index| {
        fields.set(index, value.name, self.analyzer.node(value.value).type_id);

        evaluated.* = value.value;
    }

    const type_id = try self.analyzer.types.object(fields);
    const ordered = self.analyzer.types.get(type_id).object;
    const result = try self.analyzer.allocator.alloc(ir.ObjectField, values.len);

    for (result, 0..) |*field_value, index| {
        for (values) |value| {
            if (std.mem.eql(u8, value.name, ordered.at(index).name)) {
                field_value.* = .{ .index = @intCast(index), .value = value.value };

                break;
            }
        }
    }

    return self.expression(type_id, .{ .object = .{ .fields = result, .evaluation = evaluation } });
}

pub fn tuple(self: Self, values: []const ir.ExprId) zx.Error!ir.ExprId {
    const types = try self.analyzer.allocator.alloc(ir.TypeId, values.len);

    for (values, types) |value, *type_id| type_id.* = self.analyzer.node(value).type_id;

    return self.expression(try self.analyzer.types.tuple(types), .{ .tuple = values });
}

pub fn push(self: Self, target: ir.ExprId, value: ir.ExprId) zx.Error!ir.ExprId {
    const type_id = self.analyzer.node(target).type_id;
    const operation = try self.expression(try self.analyzer.types.tuple(&.{ type_id, Types.scalarId(.void) }), .{ .list_operation = .{ .kind = .push, .target = target, .arguments = try self.analyzer.allocator.dupe(ir.ExprId, &.{value}) } });

    return self.expression(type_id, .{ .tuple_field = .{ .target = operation, .index = 0 } });
}
