const std = @import("std");
const zx = @import("zx");
const entry = @import("generated_store_initializer_validation");
const Storage = @import("frontend").ir_validation_input.Storage(std.meta.Child(entry.Input));

pub fn validate(workspace: std.mem.Allocator, program: zx.ir.Program, native_modules: enum { allowed, forbidden }) std.mem.Allocator.Error!bool {
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const eligible = @import("generated_store_initializer_eligible");

    const header = .{
        .type_only = program.type_only,
        .function_count = @as(u64, program.functions.count()),
        .native_count = @as(u64, program.native_modules.count()),
        .forbid_native = native_modules == .forbidden,
        .store_count = @as(u64, program.stores.count()),
        .contract_count = @as(u64, program.contracts.count()),
    };

    const allowed = zx.columns.invoke(eligible.executeValue, fixed.allocator(), &header) catch unreachable;

    if (!allowed) return false;

    var arena = std.heap.ArenaAllocator.init(workspace);

    defer arena.deinit();

    var storage: Storage = undefined;

    try storage.init(arena.allocator(), &program, 0);

    return entry.execute(&arena, &storage.input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return false,
    };
}

pub fn compatible(actual: []const []const u8, expected: []const []const u8) bool {
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const names = @import("generated_store_initializer_names");

    return zx.columns.invoke(names.executeValue, fixed.allocator(), &.{ .actual = actual, .expected = expected }) catch unreachable;
}
