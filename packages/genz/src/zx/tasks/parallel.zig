const std = @import("std");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const emit = @import("emitting.zig");

pub fn awaitAll(self: *Lower, output: *std.ArrayList(node.Statement), futures: []const []const u8, results: []const []const u8) Lower.Error!void {
    const entry = @import("generated_task_parallel_await");
    const Input = std.meta.Child(entry.Input);
    const bases = emit.context(std.meta.Child(@FieldType(Input, "bases")), self);
    const input: Input = .{ .futures = futures, .results = results, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const awaited = entry.executeIn(memory.allocator(), &input) catch |err| return emit.failure(err);

    if (!awaited.valid) return error.OutOfMemory;
    try emit.append(self, &self.builder.nodes.expressions, awaited.expressions);
    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, output, awaited.statements) catch |err| return emit.failure(err);
}

pub fn result(self: *Lower, output: *std.ArrayList(node.Statement), results: []const []const u8, values: []const ?[]const u8, fields: []const ?[]const u8, object: bool) Lower.Error!node.ExpressionId {
    const entry = @import("generated_task_parallel_result");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .results = results, .values = values, .fields = fields, .object = object, .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const compiled = entry.executeIn(memory.allocator(), &input) catch |err| return emit.failure(err);

    if (!compiled.valid) return error.OutOfMemory;

    const expressions = view.join(compiled.expressions.*, compiled.forms.*);

    try emit.append(self, &self.builder.nodes.expressions, &expressions);

    _ = @import("../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, compiled.fields) catch |err| return emit.failure(err);
    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, output, compiled.statements) catch |err| return emit.failure(err);

    return @fromBackingInt(compiled.root);
}
