const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");
const Change = @import("../object_update.zig").Change;

pub fn expression(self: *Lower, change: Change) Lower.Error!node.ExpressionId {
    const generated = @import("generated_object_update_expression");
    const Input = std.meta.Child(generated.Input);
    const Write = std.meta.Child(@FieldType(Input, "source"));
    const name = try self.fresh("updated");
    const layout = try self.layoutExpr(change.type_id);
    const initial = try self.expr(change.reference);
    const value = try self.expr(change.field.value);
    const value_name = try self.fresh("operand");
    const label = try self.fresh("block");
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Write, "types")), self.program.types);

    const source: Write = .{
        .types = &types,
        .type_id = @backingInt(change.type_id),
        .field = change.field.index,
        .target_name = name,
        .value_name = value_name,
        .value = @backingInt(value),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
    };

    const input: Input = .{ .source = &source, .layout = @backingInt(layout), .initial = @backingInt(initial), .label = label };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);
    const emitted = view.join(output.statements.*, output.variables.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, &emitted);

    return @fromBackingInt(output.root);
}

pub fn statements(self: *Lower, target: *std.ArrayList(node.Statement), change: Change) Lower.Error!void {
    const generated = @import("generated_object_update_statements");
    const Input = std.meta.Child(generated.Input);
    const value = try self.expr(change.field.value);
    const name = try self.fresh("operand");
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .types = &types,
        .type_id = @backingInt(change.type_id),
        .field = change.field.index,
        .target_name = self.names[@backingInt(change.previous)],
        .value_name = name,
        .value = @backingInt(value),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);
    const flat = view.join(output.statements.*, output.variables.*);

    try append(self, &self.builder.nodes.expressions, &expressions);

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, target, &flat) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    self.used[@backingInt(change.previous)] = true;
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
