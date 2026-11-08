const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, id: ir.FunctionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("worker_seed.zig").lower(self, id);

    const function = self.program.functions.at(@backingInt(id));
    const input_type = try self.typeExpr(function.input_type);
    const output_type = try self.typeExpr(function.output_type);
    const callee = try self.functionReference(id);
    const entry = @import("generated_parallel_worker");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .input_type = @backingInt(input_type),
        .output_type = @backingInt(output_type),
        .callee = @backingInt(callee),
        .bases = &bases,
        .declaration_base = @intCast(self.builder.nodes.declaration_rows.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const values = view.join(result.expressions.*, result.forms.*);
    const expressions = view.join(values, result.extra.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, result.statements);
    try append(self, &self.builder.nodes.declaration_rows, result.declarations);

    _ = @import("../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);

    return @fromBackingInt(result.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, target, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
