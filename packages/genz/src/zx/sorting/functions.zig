const std = @import("std");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;

pub fn build(self: *Lower, child: node.ExpressionId, errors: ?[]const []const u8) Lower.Error![2]node.Declaration {
    if (!generated) {
        const seed = @import("functions_seed.zig");

        return .{ try seed.less(self, child), try seed.sort(self, child, errors) };
    }

    const entry = @import("generated_sorting_functions");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .child = @backingInt(child),
        .errors = errors,
        .bases = &bases,
        .declaration_base = @intCast(self.builder.nodes.declaration_rows.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const expressions = view.join(view.join(result.expressions.*, result.forms.*), result.extra.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, result.statements);

    _ = @import("../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, result.fields) catch |err| return failure(err);

    try append(self, &self.builder.nodes.declaration_rows, result.declarations);

    return .{
        try declaration(self, result.ordering),
        try declaration(self, result.sort),
    };
}

fn declaration(self: *Lower, index: u32) Lower.Error!node.Declaration {
    return .{ .function = try self.builder.nodes.materializeFunction(self.allocator, index) };
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
