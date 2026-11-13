const std = @import("std");
const zx = @import("zx");
const Context = @import("../../../../analysis/analyze.zig").Context;
const StoreBinding = @import("../../../../analysis/analyze.zig").StoreBinding;

pub fn digest(allocator: std.mem.Allocator, context: Context) std.mem.Allocator.Error![32]u8 {
    if (comptime !@import("parser_options").generated_parser) {
        const encoded = try std.json.Stringify.valueAlloc(allocator, context, .{});

        defer allocator.free(encoded);

        var result: [32]u8 = undefined;

        zx.Sha256.hash(encoded, &result, .{});

        return result;
    }

    var buffer: [1024]u8 = undefined;
    var hash: std.Io.Writer.Hashing(zx.Sha256) = .init(&buffer);
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const memory = empty.allocator();
    const entry = @import("generated_semantic_context_encode");
    const Input = std.meta.Child(entry.Input);
    const Origins = std.meta.Child(@FieldType(Input, "origins"));
    const Bindings = std.meta.Child(@FieldType(Origins, "bindings"));
    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), context.types);
    const modules = zx.columns.columns(std.meta.Child(@FieldType(Input, "native_modules")), context.native_modules);
    const bindings = @TypeOf(context.nominal_types).borrow(Bindings, context.nominal_types);
    const origins: Origins = .{ .bindings = &bindings, .names = context.nominal_types.names };

    const input: Input = .{
        .writer = @ptrCast(&hash.writer),
        .types = &types,
        .origins = &origins,
        .native_modules = &modules,
        .stores = context.stores.len,
    };

    entry.executeValue(memory, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    try stores(memory, input.writer, context.stores);

    hash.writer.flush() catch unreachable;

    var result: [32]u8 = undefined;

    hash.hasher.final(&result);

    return result;
}

fn stores(memory: std.mem.Allocator, writer: anytype, bindings: []const StoreBinding) std.mem.Allocator.Error!void {
    const generated = @import("generated_semantic_context_stores");
    const Input = std.meta.Child(generated.Input);
    const Store = std.meta.Child(std.meta.Child(@FieldType(Input, "bindings")));
    const batch_size = 32;
    var rows: [batch_size]Store = undefined;
    var pointers: [batch_size]*const Store = undefined;
    var remaining = bindings;

    while (remaining.len != 0) {
        const count = @min(rows.len, remaining.len);

        for (remaining[0..count], rows[0..count], pointers[0..count]) |*binding, *row, *pointer| {
            row.* = .{
                .handle = binding.handle,
                .path = binding.path,
                .type_name = binding.type_name,
                .type_id = if (binding.type_id) |id| @backingInt(id) else null,
                .readable = binding.readable,
                .writable = binding.writable,
            };

            pointer.* = row;
        }

        const input: Input = .{ .writer = writer, .bindings = pointers[0..count] };

        zx.columns.invoke(generated.executeValue, memory, &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory => return error.OutOfMemory,
            else => unreachable,
        };

        remaining = remaining[count..];
    }
}
