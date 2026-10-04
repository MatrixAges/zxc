const std = @import("std");
const program = @import("program");

fn check(input: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const output = program.execute(&arena, input) catch |err| {
        arena.deinit();

        return err;
    };

    arena.deinit();

    try std.testing.expect(output.ptr == input.ptr);
    try std.testing.expectEqualStrings(input, output);
}

test "RX borrowed ASCII survives arena release" {
    var input = "runtime input".*;

    try check(&input);
}

test "RX borrowed UTF8 survives arena release" {
    var input = "中文🌱".*;

    try check(&input);
}

test "RX borrowed empty string preserves identity" {
    var input = "".*;

    try check(&input);
}
