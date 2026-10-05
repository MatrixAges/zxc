const std = @import("std");
const program = @import("program");
const host = @import("host");

pub fn output(input: program.Input, expected: program.Output, calls: usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
    try std.testing.expectEqual(calls, host.calls);
}

pub fn failure(input: program.Input, expected: anyerror, calls: usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset();

    try std.testing.expectError(expected, program.execute(&arena, input));
    try std.testing.expectEqual(calls, host.calls);
}
