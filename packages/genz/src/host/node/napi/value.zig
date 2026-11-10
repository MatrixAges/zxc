const std = @import("std");
const zx = @import("zx");
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");

pub fn declarations(builder: Builder) std.mem.Allocator.Error![]const node.Declaration {
    if (comptime !@import("genz_options").generated_analysis) return @import("value_seed.zig").declarations(builder);

    const entry = @import("generated_node_napi_value");
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
    @import("../../../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, std.meta.Child(entry.Output), output) catch |err| return failure(err);

    const count = builder.nodes.declaration_rows.tags.items.len - first;
    const result = try builder.allocator.alloc(node.Declaration, count);

    for (result, 0..) |*declaration, index| declaration.* = try builder.nodes.materializeDeclaration(builder.allocator, @intCast(first + index));

    return result;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Node N-API value AST"),
    };
}
