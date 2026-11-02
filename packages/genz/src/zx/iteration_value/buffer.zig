const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const intrinsic = @import("../intrinsics.zig");

pub fn create(self: *Context, id: ir.TypeId, source: node.ExpressionId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    const child = lowering.program.typeOf(id).list;
    const element = try @import("types.zig").get(self, child);
    const owner_type = try intrinsic.standard(lowering, &.{"ArrayList"}, &.{element}, false);
    const name = try lowering.fresh("value_buffer");
    const owner = try lowering.builder.identifier(name);
    const allocator = try lowering.builder.identifier("allocator");

    try self.declarations.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = owner_type, .value = try lowering.builder.expression(.{ .enum_literal = "empty" }) } });
    try self.declarations.append(lowering.allocator, .{ .defer_expression = try lowering.call(try lowering.field(owner, "deinit"), &.{allocator}, false) });

    var body: std.ArrayList(node.Statement) = .empty;
    const input = try aggregate.bind(lowering, &body, source);
    const address = try lowering.builder.expression(.{ .address_of = owner });

    if (!@import("../iteration_layout.zig").represented(lowering, child)) return aggregate.finish(lowering, &body, try view(self, id, address, input, false));

    try body.append(lowering.allocator, .{ .expression = try lowering.call(try lowering.field(owner, "ensureTotalCapacity"), &.{ allocator, try lowering.field(input, "len") }, true) });

    const capture = try lowering.fresh("element");
    const item = try lowering.builder.identifier(capture);
    const value = try @import("conversion.zig").convert(self, child, item, false);
    const append = try lowering.call(try lowering.field(owner, "appendAssumeCapacity"), &.{value}, false);

    try body.append(lowering.allocator, .{ .for_loop = .{ .iterable = input, .capture = capture, .body = try lowering.builder.statements(&.{.{ .expression = append }}) } });

    return aggregate.finish(lowering, &body, try view(self, id, address, try lowering.field(owner, "items"), true));
}

pub fn view(self: *Context, id: ir.TypeId, owner: node.ExpressionId, items: node.ExpressionId, owned: bool) Lower.Error!node.ExpressionId {
    return self.lowering.builder.expression(.{ .object = .{ .type_expr = try @import("types.zig").get(self, id), .fields = try self.lowering.allocator.dupe(node.Field, &.{
        .{ .name = "owner", .value = owner },
        .{ .name = "items", .value = items },
        .{ .name = "owned", .value = try self.lowering.builder.expression(.{ .boolean = owned }) },
    }) } });
}

pub fn prepare(self: *Context, body: *std.ArrayList(node.Statement), source: node.ExpressionId) Lower.Error!void {
    const lowering = self.lowering;
    const owner = try lowering.field(source, "owner");
    const items = try lowering.field(source, "items");
    const copied = node.Statement{ .expression = try lowering.call(try lowering.field(owner, "appendSlice"), &.{ try lowering.builder.identifier("allocator"), items }, true) };
    const sync = node.Statement{ .assignment = .{ .target = try lowering.field(try lowering.field(owner, "items"), "len"), .value = try lowering.field(items, "len") } };

    try body.append(lowering.allocator, try lowering.builder.branch(try lowering.field(source, "owned"), &.{sync}, &.{copied}));
}
