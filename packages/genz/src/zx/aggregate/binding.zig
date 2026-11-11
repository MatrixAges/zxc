const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Form = enum { bind, block, guarded };
const Guard = struct { condition: node.ExpressionId, fallback: node.ExpressionId };

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lower(self, body, value, .bind, null);
}

pub fn finish(self: *Lower, body: *std.ArrayList(node.Statement), value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lower(self, body, value, .block, null);
}

pub fn finishGuarded(self: *Lower, body: *std.ArrayList(node.Statement), condition: node.ExpressionId, value: node.ExpressionId, fallback: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lower(self, body, value, .guarded, .{ .condition = condition, .fallback = fallback });
}

fn lower(self: *Lower, body: *std.ArrayList(node.Statement), value: node.ExpressionId, comptime form: Form, guard: ?Guard) Lower.Error!node.ExpressionId {
    const generated = switch (form) {
        .bind => @import("generated_operand_binding"),
        .block => @import("generated_result_block"),
        .guarded => @import("generated_guarded_result_block"),
    };

    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    var input: Input = undefined;
    input.value = @backingInt(value);
    input.expression_base = @intCast(self.builder.nodes.expressions.tags.items.len);
    input.statement_base = @intCast(self.builder.nodes.statements.tags.items.len);
    input.body_count = body.items.len;
    input.serial = self.serial;

    if (form == .guarded) {
        input.condition = @backingInt(guard.?.condition);
        input.fallback = @backingInt(guard.?.fallback);
    }

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

    if (form != .bind) {
        expressions.block_label = &names;
        statements.break_value_label = &names;
    } else {
        expressions.identifier = &names;
        statements.constant_name = &names;
    }

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return failure(err);

    if (form != .bind) _ = try self.builder.statements(body.items);
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
