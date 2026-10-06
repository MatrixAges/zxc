const std = @import("std");
const f = @import("fixture.zig");
const mutation = @import("mutation.zig");

fn rejected(mode: mutation.Mode) !void {
    const allocator = std.testing.allocator;
    var result = try f.analyze(allocator);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const program = try mutation.apply(arena.allocator(), result.value.ir, mode);
    const reference = result.value.ir.native_modules[0].types[0].type_id;

    try std.testing.expect(f.ir.nativeReferenceOwner(program, reference) == null);
    try f.rejected(allocator, program);
}

test "independent IR rejects a native reference with no declaration owner" {
    try rejected(.missing_owner);
}

test "independent IR rejects a native reference whose owner binding has another name" {
    try rejected(.renamed_binding);
}

test "independent IR rejects a native reference whose type name has been changed" {
    try rejected(.renamed_type);
}

test "independent IR rejects a reference assigned to two distinct native owners" {
    try rejected(.distinct_owner);
}

test "independent IR permits the same reference under two import aliases of one owner" {
    const allocator = std.testing.allocator;
    var result = try f.analyze(allocator);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const program = try mutation.apply(arena.allocator(), result.value.ir, .same_owner);
    const reference = program.native_modules[0].types[0].type_id;

    try std.testing.expectEqualStrings("zig:host", f.ir.nativeReferenceOwner(program, reference).?);
    try std.testing.expect(try f.compiler.validateIr(allocator, program) == null);

    const bundle = try f.compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);
}
