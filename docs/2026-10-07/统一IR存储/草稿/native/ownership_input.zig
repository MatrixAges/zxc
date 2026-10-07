const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("ownership_generated");
const borrow = @import("borrow.zig");
const Input = std.meta.Child(generated.Input);
const Types = std.meta.Child(@FieldType(Input, "types"));
const Symbols = std.meta.Child(@FieldType(Input, "symbols"));
const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
const Control = std.meta.Child(@FieldType(Input, "control"));
const Function = std.meta.Child(std.meta.Elem(@FieldType(Input, "functions")));
const Store = std.meta.Child(std.meta.Elem(@FieldType(Function, "stores")));

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

    for (source, values, pointers) |item, *value, *pointer| {
        value.* = .{
            .output_ownership = switch (item.output_ownership) {
                .copy => .Copy,
                .borrowed => .Borrowed,
                .owned => .Owned,
            },
            .stores = try stores(allocator, item.stores),
        };

        pointer.* = value;
    }

    return pointers;
}

fn stores(allocator: std.mem.Allocator, source: []const ir.StoreSlot) std.mem.Allocator.Error![]const *const Store {
    const values = try allocator.alloc(Store, source.len);
    const pointers = try allocator.alloc(*const Store, source.len);

    for (source, values, pointers) |item, *value, *pointer| {
        value.* = .{ .path = item.path, .type_id = @backingInt(item.type_id), .handle = item.handle, .readable = item.readable, .writable = item.writable };
        pointer.* = value;
    }

    return pointers;
}
