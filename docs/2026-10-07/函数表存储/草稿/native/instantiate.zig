const std = @import("std");
const ir = @import("core").ir;
const generated = @import("generated");
const borrow = @import("borrow.zig");
const Input = std.meta.Child(generated.Input);
const Functions = std.meta.Child(@FieldType(Input, "functions"));

pub const Source = struct {
    files: []const []const u8,
    input_types: []const u32,
    output_types: []const u32,
    ownership: []const ir.SymbolTable.Ownership,
    roots: []const ?u32,
    symbols: []const *const ir.SymbolTable,
    expressions: []const *const ir.ExpressionTable,
    control: []const *const ir.ControlTable,
    stores: []const *const ir.StoreTable,
};

export fn instantiate(arena: *std.heap.ArenaAllocator, source: *const Source) bool {
    const symbols = borrow.slice(@FieldType(Functions, "symbols"), source.symbols);
    const expressions = borrow.slice(@FieldType(Functions, "expressions"), source.expressions);
    const control = borrow.slice(@FieldType(Functions, "control"), source.control);
    const stores = borrow.slice(@FieldType(Functions, "stores"), source.stores);
    const ownership = borrow.columns(struct { values: @FieldType(Functions, "ownership") }, .{ .values = source.ownership });
    const functions: Functions = .{ .files = source.files, .input_types = source.input_types, .output_types = source.output_types, .ownership = ownership.values, .roots = source.roots, .symbols = symbols, .expressions = expressions, .control = control, .stores = stores };

    return generated.execute(arena, &.{ .functions = &functions }) catch return false;
}

export fn buildColumns(arena: *std.heap.ArenaAllocator, input: [*]const ir.Function, len: usize) bool {
    const allocator = arena.allocator();
    var storage: @import("storage.zig") = .{};

    for (input[0..len]) |value| storage.append(allocator, value) catch return false;

    const table = storage.finish(allocator) catch return false;
    const snapshot = table.snapshot(allocator) catch return false;
    const prefix = snapshot.prefix(snapshot.count());

    if (!prefix.validStructure()) return false;
    if (prefix.count() != 0) _ = prefix.at(0);

    const source: Source = .{ .files = prefix.files, .input_types = prefix.input_types, .output_types = prefix.output_types, .ownership = prefix.ownership, .roots = prefix.roots, .symbols = prefix.symbols, .expressions = prefix.expressions, .control = prefix.control, .stores = prefix.stores };

    return instantiate(arena, &source);
}
