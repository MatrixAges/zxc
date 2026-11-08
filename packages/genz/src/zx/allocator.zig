const std = @import("std");
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, with_io: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("allocator_seed.zig").lower(self, with_io);

    const entry = @import("generated_allocator_type");
    const Input = std.meta.Child(entry.Input);

    const bases: std.meta.Child(@FieldType(Input, "bases")) = .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .with_io = with_io,
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

    _ = @import("../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);

    return @fromBackingInt(result.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../node/import_rows.zig").appendBorrowingText(self.allocator, target, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
