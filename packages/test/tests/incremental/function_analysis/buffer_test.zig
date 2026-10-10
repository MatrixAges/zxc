const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("buffer_fixture.zig");

test "owned summaries retain real nested list lanes after scratch release" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try f.owned(std.testing.allocator, try f.program(arena.allocator()));
}

test "owned real nested list summaries clean every failed allocation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const program = try f.program(arena.allocator());

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.owned, .{program});
}
