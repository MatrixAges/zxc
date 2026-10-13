const std = @import("std");
const generated = @import("generated");
pub const default_maximum: usize = 120;
pub const Exceeded = struct { lines: usize, maximum: usize };

pub fn check(text: []const u8, maximum: usize) ?Exceeded {
    const lines = run(text, maximum) orelse return null;

    return .{ .lines = lines, .maximum = maximum };
}

pub fn count(text: []const u8) usize {
    return run(text, null).?;
}

fn run(text: []const u8, maximum: ?usize) ?usize {
    const Input = @typeInfo(generated.Input).pointer.child;
    const input: Input = .{ .text = text, .maximum = if (maximum) |limit| @intCast(limit) else null };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const lines = (generated.execute(&arena, &input) catch unreachable) orelse return null;

    return @intCast(lines);
}
