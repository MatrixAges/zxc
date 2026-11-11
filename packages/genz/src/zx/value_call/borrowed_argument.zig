const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub const Source = union(enum) {
    value: node.ExpressionId,
    tuple: struct { layout: node.ExpressionId, values: []const node.ExpressionId },
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), source: Source) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) {
        const value = switch (source) {
            .value => |value| value,
            .tuple => |tuple| try self.cast(tuple.layout, try self.builder.expression(.{ .tuple = tuple.values })),
        };

        const reference = try aggregate.bind(self, body, value);

        return self.builder.expression(.{ .address_of = reference });
    }

    const entry = @import("generated_value_argument_borrow");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);

    const input: Input = .{
        .value = if (source == .value) @backingInt(source.value) else 0,
        .layout = if (source == .tuple) @backingInt(source.tuple.layout) else null,
        .values = if (source == .tuple) view.slice(@FieldType(Input, "values"), source.tuple.values) else &.{},
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .serial = self.serial,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const name = try self.allocator.dupe(u8, output.name);
    const names = [_][]const u8{name};
    var arguments: [1][]const u32 = undefined;
    var expressions = zx.columns.view(std.meta.Child(@FieldType(Output, "expressions")), output.expressions);
    var statements = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), output.statements);

    expressions.identifier = &names;
    statements.constant_name = &names;

    if (expressions.builtin_arguments.len != 0) {
        arguments[0] = try self.allocator.dupe(u32, expressions.builtin_arguments[0]);
        expressions.builtin_arguments = &arguments;
    }

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return failure(err);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    self.serial = @intCast(output.serial);

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
