const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("generated_ir_validation");
const Storage = @import("input.zig").Storage(std.meta.Child(generated.Input));
const Verified = @import("../../validate.zig").Verified;

pub fn verify(allocator: std.mem.Allocator, program: *const ir.Program, verified: Verified) std.mem.Allocator.Error!?Verified {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var storage: Storage = undefined;

    try storage.init(arena.allocator(), program, verified);

    const input: *const @TypeOf(storage.input) = &storage.input;

    const output = zx.columns.invoke(generated.executeValue, arena.allocator(), input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return null,
    };

    const result = output orelse return null;

    return .{
        .functions = @intCast(result.functions),
        .types = zx.columns.view(@import("type_prefix.zig"), result.types),
        .native = result.native,
    };
}
