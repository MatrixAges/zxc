const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("generated_ir_validation");
const Storage = @import("input.zig").Storage(std.meta.Child(generated.Input));

pub fn validate(allocator: std.mem.Allocator, program: ir.Program, verified: usize) std.mem.Allocator.Error!bool {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var storage: Storage = undefined;

    try storage.init(arena.allocator(), &program, verified);

    return generated.execute(&arena, &storage.input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return false,
    };
}
