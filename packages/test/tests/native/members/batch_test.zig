const std = @import("std");
const f = @import("fixture.zig");
const batch = @import("batch.zig");

test "mixed native descriptors retain distinct flags and nullable error collections" {
    try f.check(std.testing.allocator, batch.case);
}

test "native descriptor pairing follows reordered declarations" {
    try f.check(std.testing.allocator, .{
        .declaration = "export declare function expanded(left: u64, right: u64): u64 throws {}\n\nexport declare function apply(input: u64): u64 concurrent\n\nexport declare function unknown(io, input: u64): u64 throws\n",
        .members = &.{ .{ .name = "expanded", .expanded = true, .fallible = true, .errors = &.{} }, .{ .name = "apply", .concurrent = true }, .{ .name = "unknown", .io = true, .fallible = true } },
    });
}

test "later native signature diagnostics do not attempt incomplete member pairing" {
    var result = try f.analyze(std.testing.allocator, .{ .declaration = batch.case.declaration ++ "export declare function broken(input: u64): Missing\n", .members = &.{} });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.name, result.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
    try std.testing.expect(std.mem.startsWith(u8, result.value.diagnostic.message, "host.d.zx:"));
}
