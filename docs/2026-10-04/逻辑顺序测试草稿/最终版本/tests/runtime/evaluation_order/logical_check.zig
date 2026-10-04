const std = @import("std");
const program = @import("program");
const probe = @import("probe");

pub fn check(args: struct {
    input: program.Input,
    trace: []const u8,
    expected: union(enum) { value: bool, failure: anyerror },
}) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    probe.count = 0;

    const result = program.execute(&arena, args.input);

    try std.testing.expectEqualStrings(args.trace, probe.trace[0..probe.count]);

    switch (args.expected) {
        .value => |value| try std.testing.expectEqual(value, try result),
        .failure => |failure| try std.testing.expectError(failure, result),
    }
}
