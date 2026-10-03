const std = @import("std");
const library = @import("library");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const input: library.Input = &.{ .items = &.{&.{ .value = 7 }}, .pair = &.{ &.{ .value = 11 }, &.{ .value = 13 } } };
    const output = try library.execute(&arena, input);

    if (output != input or output.items.ptr != input.items.ptr or output.pair != input.pair) return error.ReferenceChanged;
    if (arena.queryCapacity() != 0) return error.UnexpectedAllocation;

    std.debug.print("packaged library preserves object, tuple and array references; arena capacity: {d}\n", .{arena.queryCapacity()});
}
