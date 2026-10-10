const std = @import("std");
const Input = @import("../model.zig").Input;
pub const Syntax = std.meta.Child(@FieldType(Input, "syntax"));
pub const Native = std.meta.Child(@typeInfo(@FieldType(Input, "native")).optional.child);
pub const Text = std.meta.Child(@FieldType(Native, "text"));
pub const Expressions = std.meta.Child(@FieldType(Syntax, "expressions"));
pub const Blocks = std.meta.Child(@FieldType(Syntax, "blocks"));
pub const Node = Item(Expressions, "nodes");
pub const Edge = Item(Expressions, "items");
pub const Field = Item(Expressions, "fields");
pub const Parameter = Item(Expressions, "parameters");
pub const Part = Item(Expressions, "parts");
pub const Arm = Item(Expressions, "arms");
pub const Statement = Item(Blocks, "statements");
pub const Block = Item(Blocks, "blocks");
pub const BlockItem = Item(Blocks, "items");
pub const Name = Item(Blocks, "names");
pub const Case = Item(Blocks, "cases");
pub const Import = Item(Syntax, "imports");
pub const Declaration = Item(Syntax, "declarations");
pub const Contract = Item(Syntax, "contracts");
pub const Span = std.meta.Child(@FieldType(Node, "span"));
pub const Operator = @FieldType(Node, "operator");
pub const empty_span: Span = .{ .start = 0, .end = 0 };

pub const empty_types: std.meta.Child(@FieldType(Syntax, "types")) = .{ .nodes = &.{}, .fields = &.{}, .items = &.{} };
pub const empty_order: std.meta.Child(@FieldType(Syntax, "type_order")) = .{ .heads = &.{}, .fields = &.{}, .items = &.{} };
pub const empty_diagnostic: std.meta.Child(@FieldType(Syntax, "diagnostic")) = .{ .code = "", .message = "", .start = 0, .end = 0 };

fn Item(comptime Table: type, comptime field: []const u8) type {
    return std.meta.Child(std.meta.Child(@FieldType(Table, field)));
}
