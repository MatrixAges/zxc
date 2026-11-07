const std = @import("std");
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const rows = @import("../../../node/import_rows.zig");
const view = @import("../../../node/view.zig");

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), name: []const u8, type_expr: node.ExpressionId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const generated = @import("generated_ownership_projected");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .name = name,
        .type_expr = @backingInt(type_expr),
        .value = @backingInt(value),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    return emit(self, body, generated, &input);
}

fn emit(self: *Lower, body: *std.ArrayList(node.Statement), comptime generated: type, input: generated.Input) Lower.Error!node.ExpressionId {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), input) catch |err| return failure(err);
    const state = output.state;

    if (!state.valid) return error.OutOfMemory;

    const expressions = view.join(state.expressions.*, state.forms.*);
    const statements = view.join(state.statements.*, state.variables.*);

    rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
    @import("../../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return imported(err);

    return @fromBackingInt(output.id);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid ownership projection generation"),
    };
}

fn imported(err: rows.Error) Lower.Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.InvalidAst => @panic("invalid ownership projection AST"),
    };
}
