const std = @import("std");
const generated = @import("generated");
pub const Opening = struct { marker: usize, end: usize, self_closing: bool };
pub const Closing = struct { start: usize, end: usize };

fn call(kind: u8, source: []const u8, start: usize) generated.Output {
    var storage: [256]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    return generated.executeIn(fixed.allocator(), &.{
        .kind = kind,
        .source = source,
        .start = start,
    }) catch unreachable;
}

pub fn opening(source: []const u8, start: usize) Opening {
    const output = call(0, source, start);

    return .{
        .marker = @intCast(output.start),
        .end = @intCast(output.end),
        .self_closing = output.self_closing,
    };
}

pub fn closing(source: []const u8, start: usize) Closing {
    const output = call(1, source, start);

    return .{
        .start = @intCast(output.start),
        .end = @intCast(output.end),
    };
}

pub fn commentEnd(source: []const u8, start: usize) usize {
    const output = call(2, source, start);

    return @intCast(output.end);
}

pub fn tagEnd(source: []const u8, start: usize) usize {
    const output = call(3, source, start);

    return @intCast(output.end);
}
