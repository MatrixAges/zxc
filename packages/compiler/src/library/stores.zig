const std = @import("std");
const ir = @import("zx").ir;
const columns = @import("zx").columns;
const Error = std.mem.Allocator.Error || error{ ConflictingStore, InvalidIr };
const generated = @import("parser_options").generated_parser;

pub fn validate(allocator: std.mem.Allocator, stores: []const *const ir.StoreTable) Error!void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const scratch = arena.allocator();

    if (!generated) return validateSeed(scratch, stores);

    const entry = @import("generated_compiled_stores");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .tables = columns.slice(@FieldType(Input, "tables"), stores) };

    const compatible = columns.invoke(entry.executeValue, scratch, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidIr,
    };

    if (!compatible) return error.ConflictingStore;
}

fn validateSeed(allocator: std.mem.Allocator, stores: []const *const ir.StoreTable) Error!void {
    var seen: std.StringHashMapUnmanaged(u32) = .empty;

    for (stores) |table| {
        for (table.paths, table.types) |path, type_id| {
            const entry = try seen.getOrPut(allocator, path);

            if (entry.found_existing and entry.value_ptr.* != type_id) return error.ConflictingStore;

            entry.value_ptr.* = type_id;
        }
    }
}
