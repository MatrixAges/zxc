const std = @import("std");
const zx = @import("zx");
const FunctionImport = @import("../../function_import.zig");
const Request = @import("native_input.zig").Request;
const eligible = @import("generated_native_cache_eligible");
const bindings = @import("generated_native_cache_bindings");
const Input = std.meta.Child(bindings.Input);
const Row = std.meta.Child(std.meta.Elem(@FieldType(Input, "imports")));
const batch_size = @import("../../package_scope.zig").lookup_batch_size;
const Error = std.mem.Allocator.Error || error{InvalidModule};

pub fn check(allocator: std.mem.Allocator, request: *const Request, imports: []const FunctionImport) Error!void {
    if (!(zx.columns.invoke(eligible.executeValue, allocator, request) catch |err| return failure(err))) return error.InvalidModule;

    var rows: [batch_size]Row = undefined;
    var pointers: [batch_size]*const Row = undefined;
    var first: usize = 0;

    while (first < imports.len) {
        const count = @min(rows.len, imports.len - first);

        for (imports[first..][0..count], rows[0..count], pointers[0..count]) |*source, *row, *pointer| {
            row.* = source.borrow(Row);
            pointer.* = row;
        }

        const input: Input = .{ .signatures = request.signatures, .declaration = request.declaration, .imports = pointers[0..count], .first = first };

        if (!(zx.columns.invoke(bindings.executeValue, allocator, &input) catch |err| return failure(err))) return error.InvalidModule;

        first += count;
    }
}

fn failure(err: anyerror) Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => error.InvalidModule,
    };
}
