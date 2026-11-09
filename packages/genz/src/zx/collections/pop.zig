const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const elements = @import("../state_value/element_emission.zig");
const conversion = @import("../state_value/conversion_emission.zig");

pub const Request = struct {
    type_id: ir.TypeId,
    result_type: ir.TypeId,
    items: node.ExpressionId,
    value: node.ExpressionId,
    header: node.ExpressionId,
    element: node.ExpressionId,
    length: node.ExpressionId,
    retract: bool,
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), args: Request) Lower.Error!node.ExpressionId {
    const entry = @import("generated_collection_pop");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const Element = std.meta.Child(@typeInfo(@FieldType(Input, "element")).optional.child);
    const Choice = std.meta.Child(@FieldType(Element, "choice"));
    const Prepared = std.meta.Child(@typeInfo(@FieldType(Element, "conversion")).optional.child);
    const serial = self.serial;
    const declarations = self.task_declarations.count();
    const statements = self.builder.nodes.statements.tags.items.len;
    const roots = body.items.len;
    const dynamic = @import("../state_value/list.zig").selected(self, args.type_id);
    const layout = if (dynamic) try @import("../types.zig").get(self, self.state_types, args.type_id) else null;
    const decision = elements.choice(self, args.type_id, .Read, false);
    const choice = zx.columns.view(Choice, decision);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    var boundary: conversion.Capture = undefined;

    const capture = if (self.capture) |value| captured: {
        boundary = .{ .name = value.name, .label = value.label, .failure = @backingInt(value.failure) };

        break :captured &boundary;
    } else null;

    var common: Prepared = undefined;

    if (!decision.passthrough and !decision.stored) common = zx.columns.view(Prepared, try elements.prepare(self, memory.allocator(), decision, @fromBackingInt(0), capture));

    const element_layout = if (!decision.passthrough and decision.stored) try @import("../types.zig").get(self, self.state_types, @fromBackingInt(decision.type_id)) else null;
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("../state_value/list_emission.zig").borrow(self));
    const origin_ast = @import("../construction/ast.zig").borrow(std.meta.Child(@FieldType(Input, "origin_ast")), self);
    const selected_result = self.state_active and self.state_plan.selected[@backingInt(args.result_type)];

    std.debug.assert(serial == self.serial and declarations == self.task_declarations.count());
    std.debug.assert(statements == self.builder.nodes.statements.tags.items.len and roots == body.items.len);

    const bases: Bases = .{
        .capture = if (self.capture) |value| &.{ .name = value.name, .label = value.label, .failure = @backingInt(value.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const element: Element = .{
        .choice = &choice,
        .conversion = if (!decision.passthrough and !decision.stored) &common else null,
        .ast = &ast,
        .layout = if (element_layout) |value| @backingInt(value) else 0,
        .value = 0,
        .name = &.{},
        .capture = bases.capture,
        .expression_base = bases.expression_base,
        .statement_base = bases.statement_base,
        .field_base = bases.field_base,
        .serial = bases.serial,
    };

    const input: Input = .{
        .items = @backingInt(args.items),
        .value = @backingInt(args.value),
        .header = @backingInt(args.header),
        .element_type = @backingInt(args.element),
        .length = @backingInt(args.length),
        .dynamic = dynamic,
        .layout = if (layout) |value| @backingInt(value) else 0,
        .retract = args.retract,
        .shared = self.shared_types,
        .element = if (!decision.passthrough) &element else null,
        .origin = selected_result,
        .arity = self.program.typeOf(args.result_type).tuple.len,
        .origin_ast = &origin_ast,
        .ast = &ast,
        .bases = &bases,
    };

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return @import("emission.zig").failure(err);

    return conversion.apply(self, body, body, output);
}
