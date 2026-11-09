const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error![3]node.Declaration {
    if (comptime !@import("genz_options").generated_analysis) return .{
        try @import("http_seed.zig").readBody(builder),
        try @import("http_seed.zig").respond(builder),
        try @import("head_seed.zig").lower(builder),
    };

    const entry = @import("generated_gateway_http");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const output = zx.columns.invoke(entry.executeValue, builder.allocator, &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const first = builder.nodes.declaration_rows.tags.items.len;
    @import("../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, std.meta.Child(entry.Output), output) catch |err| return failure(err);

    var result: [3]node.Declaration = undefined;

    for (&result, 0..) |*declaration, index| declaration.* = try builder.nodes.materializeDeclaration(builder.allocator, @intCast(first + index));

    return result;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway HTTP AST"),
    };
}
