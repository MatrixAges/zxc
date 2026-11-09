const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn render(allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("root_seed.zig").render(allocator);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());
    const entry = @import("generated_gateway_host");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .capture = null,
        .expression_base = 0,
        .statement_base = 0,
        .field_base = 0,
        .serial = 0,
    };

    const output = zx.columns.invoke(entry.executeValue, builder.allocator, &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    @import("../../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, std.meta.Child(entry.Output), output) catch |err| return failure(err);
    const declarations = try builder.allocator.alloc(node.Declaration, builder.nodes.declaration_rows.tags.items.len);

    for (declarations, 0..) |*declaration, index| declaration.* = try builder.nodes.materializeDeclaration(builder.allocator, @intCast(index));

    return @import("../../render.zig").render(allocator, builder.nodes, declarations);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway host AST"),
    };
}
