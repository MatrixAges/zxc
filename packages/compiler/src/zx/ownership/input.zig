const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("generated_ownership");
const borrow = @import("../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);
const Types = std.meta.Child(@FieldType(Input, "types"));
const Symbols = std.meta.Child(@FieldType(Input, "symbols"));
const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
const Control = std.meta.Child(@FieldType(Input, "control"));
const Function = std.meta.Child(std.meta.Elem(@FieldType(Input, "functions")));
const Stores = std.meta.Child(@FieldType(Function, "stores"));

pub fn execute(arena: *std.heap.ArenaAllocator, program: ir.Program) !generated.Output {
    const types = ir.TypeTable.borrow(Types, program.types);
    const symbols = borrow.columns(Symbols, program.symbols);
    const expressions = borrow.columns(Expressions, program.expressions);
    const control = borrow.columns(Control, program.body.control.*);

    const input: Input = .{
        .types = &types,
        .symbols = &symbols,
        .expressions = &expressions,
        .control = &control,
        .body = if (program.body.root) |root| @backingInt(root) else null,
        .functions = try functions(arena.allocator(), program.functions),
        .type_only = program.type_only,
    };

    return generated.execute(arena, &input);
}

fn functions(allocator: std.mem.Allocator, source: []const ir.Function) std.mem.Allocator.Error![]const *const Function {
    const values = try allocator.alloc(Function, source.len);
    const pointers = try allocator.alloc(*const Function, source.len);
    const slots = try allocator.alloc(Stores, source.len);

    for (source, values, pointers, slots) |item, *value, *pointer, *stores| {
        stores.* = borrow.columns(Stores, item.stores);

        value.* = .{
            .output_ownership = switch (item.output_ownership) {
                .copy => .Copy,
                .borrowed => .Borrowed,
                .owned => .Owned,
            },
            .stores = stores,
        };

        pointer.* = value;
    }

    return pointers;
}
