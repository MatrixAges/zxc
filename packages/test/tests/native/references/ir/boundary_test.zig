const std = @import("std");
const f = @import("fixture.zig");
const mutation = @import("mutation.zig");

fn rejected(mode: mutation.Mode) !void {
    const allocator = std.testing.allocator;
    var result = try f.analyze(allocator);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    try std.testing.expect(try f.compiler.validateIr(allocator, f.nativeOnly(result.value.ir)) == null);
    try f.rejected(allocator, try mutation.apply(arena.allocator(), result.value.ir, mode));
}

test "isolated native IR remains valid without caller expressions" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    try std.testing.expect(try f.compiler.validateIr(std.testing.allocator, f.nativeOnly(result.value.ir)) == null);
}

test "independent IR rejects an unnamed native reference argument shape" {
    try rejected(.unnamed_input);
}

test "independent IR rejects a native reference argument bound to another exported name" {
    try rejected(.mismatched_input);
}

test "independent IR rejects concurrent access to a native reference" {
    try rejected(.concurrent);
}

test "independent IR rejects a native reference result with only a scalar source" {
    try rejected(.scalar_source);
}

test "independent IR rejects concurrency hidden in nested optional reference lists" {
    try rejected(.nested_concurrent);
}

test "independent IR rejects a nested reference result with only a scalar source" {
    try rejected(.nested_scalar_source);
}

test "independent IR rejects Store retention of optional reference list fields" {
    try rejected(.store);
}
