const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lower(self, body, value, false);
}

pub fn finish(self: *Lower, body: *std.ArrayList(node.Statement), value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lower(self, body, value, true);
}

fn lower(self: *Lower, body: *std.ArrayList(node.Statement), value: node.ExpressionId, comptime block: bool) Lower.Error!node.ExpressionId {
    const generated = if (block) @import("generated_result_block") else @import("generated_operand_binding");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);

    const input: Input = .{
        .value = @backingInt(value),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .body_count = body.items.len,
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = zx.columns.invoke(generated.executeValue, buffered.allocator(), @as(*const Input, &input)) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    var expressions = zx.columns.view(std.meta.Child(@FieldType(Output, "expressions")), output.expressions);
    var statements = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), output.statements);
    const name = try self.allocator.dupe(u8, output.name);
    const names = [_][]const u8{name};

    if (block) {
        expressions.block_label = &names;
        statements.break_value_label = &names;
    } else {
        expressions.identifier = &names;
        statements.constant_name = &names;
    }

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return failure(err);

    if (block) _ = try self.builder.statements(body.items);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    self.serial = output.serial;

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
