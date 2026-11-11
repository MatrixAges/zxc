const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub const Check = struct {
    condition: node.ExpressionId,
    after_step: bool,
    renewed: bool = false,
    guarded_initial: bool = false,
};

pub fn append(self: *Lower, target: *std.ArrayList(node.Statement), body: *std.ArrayList(node.Statement), check: Check) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return seed(self, target, body, check);

    const entry = @import("generated_iteration_frame");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);

    const input: Input = .{
        .condition = @backingInt(check.condition),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .body_count = body.items.len,
        .after_step = check.after_step,
        .renewed = check.renewed,
        .guarded_initial = check.guarded_initial,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);
    const Statement = std.meta.Child(@FieldType(Output, "statement"));
    const statement = zx.columns.view(Statement, output.statement);

    if (output.guard) |guard| {
        const Guard = std.meta.Child(@typeInfo(@FieldType(Output, "guard")).optional.child);
        const expressions = zx.columns.view(std.meta.Child(@FieldType(Guard, "expressions")), guard.expressions);
        const stop = zx.columns.view(std.meta.Child(@FieldType(Guard, "stop")), guard.stop);
        const exit = zx.columns.view(std.meta.Child(@FieldType(Guard, "exit")), guard.exit);

        try appendRows(self, &self.builder.nodes.expressions, &expressions);
        try appendRows(self, &self.builder.nodes.statements, &stop);

        _ = try self.builder.statements(body.items);

        try appendRows(self, &self.builder.nodes.statements, &exit);
    } else {
        _ = try self.builder.statements(body.items);
    }

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, target, &statement) catch |err| return failure(err);
}

fn seed(self: *Lower, target: *std.ArrayList(node.Statement), body: *std.ArrayList(node.Statement), check: Check) Lower.Error!void {
    const trailing = check.after_step or check.renewed or check.guarded_initial;

    if (trailing) try body.append(self.allocator, .{ .branch = .{
        .condition = try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = check.condition } }),
        .yes = try self.builder.statements(&.{.break_loop}),
        .no = .{},
    } });

    try target.append(self.allocator, .{ .while_loop = .{
        .condition = if (trailing) try self.builder.expression(.{ .boolean = true }) else check.condition,
        .body = try self.builder.statements(body.items),
    } });
}

fn appendRows(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, target, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
