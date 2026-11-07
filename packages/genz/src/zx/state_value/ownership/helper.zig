const std = @import("std");
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const rows = @import("../../../node/import_rows.zig");
const view = @import("../../../node/view.zig");

pub fn prepare(self: *Lower) Lower.Error!node.ExpressionId {
    const generated = @import("generated_ownership_helper_prepare");
    const Input = std.meta.Child(generated.Input);
    const input: Input = .{ .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len) };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);

    rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);

    return @fromBackingInt(output.root);
}

pub fn declare(self: *Lower, name: []const u8, type_expr: node.ExpressionId, body: node.Block) Lower.Error!void {
    const generated = @import("generated_ownership_helper_declare");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .name = name,
        .type_expr = @backingInt(type_expr),
        .body_start = body.start,
        .body_count = body.len,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .declaration_base = @intCast(self.task_declarations.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);

    rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
    @import("../../../node/import_functions.zig").appendBorrowingText(self.allocator, self.task_declarations, output.declarations, output.parameters) catch |err| return imported(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid helper declaration generation"),
    };
}

fn imported(err: rows.Error) Lower.Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.InvalidAst => @panic("invalid helper declaration AST"),
    };
}
