const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../node.zig");
const rows = @import("../node/import_rows.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, id: ir.ExprId, type_expr: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("literals/seed.zig").lower(self, self.program.expression(id), type_expr);

    const generated = @import("generated_literal_emit");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
    const expressions = zx.columns.borrow(Expressions, @as(*const ir.ExpressionTable, &self.program.expressions));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .expressions = &expressions,
        .types = &types,
        .id = @backingInt(id),
        .type_expr = @backingInt(type_expr),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
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

    var emitted = zx.columns.view(std.meta.Child(@FieldType(Output, "nodes")), output.nodes);
    const arguments = if (emitted.builtin_arguments.len == 0) &.{} else try self.allocator.dupe(u32, emitted.builtin_arguments[0]);
    const promoted = [_][]const u32{arguments};

    if (emitted.builtin_arguments.len != 0) emitted.builtin_arguments = &promoted;

    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, &emitted) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @fromBackingInt(output.root);
}
