const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const conversion = @import("conversion.zig");

pub fn inlineStored(self: *const Lower, list: ir.TypeId) bool {
    if (self.program.typeOf(list) != .list) return false;

    const child = self.program.typeOf(list).list;

    return self.program.typeOf(child) == .object and self.state_plan.selected[@backingInt(child)];
}

pub fn typeExpr(self: *Lower, list: ir.TypeId) Lower.Error!node.ExpressionId {
    return @import("../types.zig").get(self, if (self.state_active and inlineStored(self, list)) self.abi_layouts else self.abi_types, self.program.typeOf(list).list);
}

pub fn write(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!self.state_active) return value;

    return conversion.convert(self, body, self.program.typeOf(list).list, value, if (inlineStored(self, list)) .row_layout else .pointer);
}

pub fn read(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!self.state_active) return value;

    const source = if (inlineStored(self, list)) try aggregate.bind(self, body, value) else value;

    return conversion.convert(self, body, self.program.typeOf(list).list, source, if (inlineStored(self, list)) .row_value else .value);
}

pub fn convert(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, value: node.ExpressionId, input: bool) Lower.Error!node.ExpressionId {
    const lists = @import("list.zig");

    if (!inlineStored(self, list)) return if (input) lists.borrowed(self, list, value) else self.field(value, "items");

    const child = self.program.typeOf(list).list;
    const element = try @import("../types.zig").get(self, if (input) self.abi_layouts else self.abi_types, child);
    const source = try aggregate.bind(self, body, if (input) value else try self.field(value, "items"));
    const empty = try self.cast(try self.builder.expression(.{ .const_slice = element }), try self.builder.expression(.{ .address_of = try self.builder.expression(.{ .array = .{ .element_type = element, .values = &.{} } }) }));
    var filled: std.ArrayList(node.Statement) = .empty;
    const target = try @import("../growth.zig").reserve(self, &filled, element, empty, try self.field(source, "len"), false);
    const capture = try self.fresh("element");
    const index = try self.fresh("index");
    var loop: std.ArrayList(node.Statement) = .empty;
    const captured = try self.builder.identifier(capture);

    const converted = if (input)
        try self.builder.expression(.{ .dereference = captured })
    else
        try conversion.convert(self, &loop, child, try conversion.convert(self, &loop, child, captured, .row_value), .pointer);

    try loop.append(self.allocator, .{ .assignment = .{
        .target = try self.builder.expression(.{ .index = .{ .target = target, .index = try self.builder.identifier(index) } }),
        .value = converted,
    } });

    try filled.append(self.allocator, .{ .for_loop = .{ .iterable = source, .capture = capture, .index_capture = index, .body = try self.builder.statements(loop.items) } });

    const complete = if (input) try lists.create(self, list, target, try self.builder.expression(.{ .boolean = true })) else target;
    const absent = if (input) try lists.borrowed(self, list, empty) else empty;

    return self.builder.expression(.{ .conditional = .{
        .condition = try @import("../intrinsics.zig").binary(self, .equal, try self.field(source, "len"), try self.builder.integer(0)),
        .yes = absent,
        .no = try aggregate.finish(self, &filled, complete),
    } });
}

pub fn captureName(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, symbol: ir.SymbolId) Lower.Error![]const u8 {
    if (!self.used[@backingInt(symbol)]) return "_";

    const name = self.names[@backingInt(symbol)];

    if (!self.state_active or !inlineStored(self, list)) return name;

    const raw = try self.fresh("element");
    var prefix: std.ArrayList(node.Statement) = .empty;
    const value = try read(self, &prefix, list, try self.builder.identifier(raw));

    try prefix.append(self.allocator, .{ .constant = .{ .name = name, .value = value } });
    try body.insertSlice(self.allocator, 0, prefix.items);

    return raw;
}
