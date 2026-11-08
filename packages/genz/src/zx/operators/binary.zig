const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");
const Operation = @FieldType(@FieldType(ir.ExpressionRow, "value"), "binary");

pub fn lower(self: *Lower, value: Operation) Lower.Error!node.ExpressionId {
    const generated = @import("generated_binary_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const Expressions = std.meta.Child(@FieldType(Input, "expressions"));

    comptime view.compatible(@FieldType(Operation, "operator"), @FieldType(Input, "operator"));

    const left = try self.expr(value.left);
    const right = try self.expr(value.right);
    const type_expr = try self.typeExpr(self.program.expression(value.left).type_id);
    const expressions = zx.columns.borrow(Expressions, @as(*const ir.ExpressionTable, &self.program.expressions));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .expressions = &expressions,
        .types = &types,
        .operator = @fromBackingInt(@intCast(@backingInt(value.operator))),
        .left_ir = @backingInt(value.left),
        .right_ir = @backingInt(value.right),
        .left = @backingInt(left),
        .right = @backingInt(right),
        .type_expr = @backingInt(type_expr),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = zx.columns.invoke(generated.executeValue, buffered.allocator(), @as(*const Input, &input)) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expression_rows = zx.columns.view(std.meta.Child(@FieldType(Output, "expressions")), output.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Output, "forms")), output.forms);
    const statement_rows = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), output.statements);
    const variables = zx.columns.view(std.meta.Child(@FieldType(Output, "variables")), output.variables);
    const expressions_out = view.join(expression_rows, forms);
    const statements = view.join(statement_rows, variables);

    try append(self, &self.builder.nodes.expressions, &expressions_out);
    try append(self, &self.builder.nodes.statements, &statements);

    self.serial = output.serial;

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
