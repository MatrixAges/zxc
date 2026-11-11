const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");

pub fn field(self: *Lower, value: node.ExpressionId, seed: node.ExpressionId, name: []const u8) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) {
        var body: std.ArrayList(node.Statement) = .empty;

        try body.append(self.allocator, .{ .discard = value });

        const pointer = try self.builder.expression(.{ .address_of = try self.field(seed, name) });

        return @import("../aggregate.zig").finish(self, &body, pointer);
    }

    const entry = @import("generated_object_borrowed_field");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);
    const Block = std.meta.Child(@FieldType(Output, "block"));

    const input: Input = .{
        .evaluated = @backingInt(value),
        .seed = @backingInt(seed),
        .name = name,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);

    if (!output.block.valid) return error.OutOfMemory;

    const pointer = zx.columns.view(std.meta.Child(@FieldType(Output, "pointer")), output.pointer);
    const discard = zx.columns.view(std.meta.Child(@FieldType(Output, "discard")), output.discard);
    var expressions = zx.columns.view(std.meta.Child(@FieldType(Block, "expressions")), output.block.expressions);
    var statements = zx.columns.view(std.meta.Child(@FieldType(Block, "statements")), output.block.statements);
    const label = try self.allocator.dupe(u8, output.block.name);

    expressions.block_label = &.{label};
    statements.break_value_label = &.{label};

    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, &pointer) catch |err| return failure(err);
    rows.appendBorrowed(self.allocator, &self.builder.nodes.statements, &discard) catch |err| return failure(err);
    rows.appendBorrowed(self.allocator, &self.builder.nodes.statements, &statements) catch |err| return failure(err);
    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    self.serial = @intCast(output.block.serial);

    return @fromBackingInt(output.block.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
