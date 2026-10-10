const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");
const borrow = @import("../../../../ir/canonical/borrow.zig");
const Input = std.meta.Child(@import("generated_expression_analysis").Input);
const Syntax = std.meta.Child(@FieldType(Input, "syntax"));
pub const Result = struct { syntax: *const Syntax, native: @FieldType(Input, "native") };

pub fn convert(allocator: std.mem.Allocator, expression: *const zx.ast.Expression) std.mem.Allocator.Error!Result {
    var context = Context{ .allocator = allocator, .types = .{ .allocator = allocator } };
    const result = try context.expression(expression);
    const tables = try @import("finish.zig").apply(&context, &.{}, &.{});
    const syntax = try allocator.create(Syntax);

    syntax.* = .{
        .types = borrow.pointer(@FieldType(Syntax, "types"), &model.empty_types),
        .type_order = borrow.pointer(@FieldType(Syntax, "type_order"), &model.empty_order),
        .expressions = borrow.pointer(@FieldType(Syntax, "expressions"), tables.expressions),
        .blocks = borrow.pointer(@FieldType(Syntax, "blocks"), tables.blocks),
        .tokens = &.{},
        .comments = &.{},
        .result = result,
        .diagnostic = borrow.pointer(@FieldType(Syntax, "diagnostic"), &model.empty_diagnostic),
    };

    return .{ .syntax = syntax, .native = borrow.pointer(@typeInfo(@FieldType(Input, "native")).optional.child, tables.native) };
}
