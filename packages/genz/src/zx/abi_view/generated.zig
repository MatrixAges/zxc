const std = @import("std");
const Builder = @import("../../builder.zig");
const rows = @import("../../node/import_rows.zig");
const Alias = @import("../abi_view.zig").Alias;
const generated = @import("generated_abi_view");

pub fn render(allocator: std.mem.Allocator, type_names: []const []const u8, aliases: []const Alias, imported: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const builder = try Builder.init(temporary);
    const Input = std.meta.Child(generated.Input);
    const Item = std.meta.Child(@FieldType(Input, "aliases"));
    const values = try temporary.alloc(std.meta.Child(Item), aliases.len);
    const borrowed = try temporary.alloc(Item, aliases.len);

    for (aliases, values, borrowed) |alias, *value, *target| {
        value.* = .{ .name = alias.name, .identity = alias.identity };
        target.* = value;
    }

    const input: Input = .{
        .names = type_names,
        .aliases = borrowed,
        .imported = imported,
    };

    const output = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    rows.appendBorrowed(temporary, &builder.nodes.expressions, output.expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    rows.appendBorrowed(temporary, &builder.nodes.declaration_rows, output.members) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    rows.appendBorrowed(temporary, &builder.nodes.declaration_rows, output.roots) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return @import("../../render.zig").renderStored(allocator, builder.nodes, .{
        .start = @intCast(output.members.tags.len),
        .len = @intCast(output.roots.tags.len),
    });
}
