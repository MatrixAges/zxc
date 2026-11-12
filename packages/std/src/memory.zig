const std = @import("std");

pub inline fn copyBytes(target: *const anyopaque, offset: u64, source: []const u8, start: u64, end: u64) error{IndexOutOfBounds}!u64 {
    const output: *const []u8 = @ptrCast(@alignCast(target));

    if (start > end or end > source.len or offset > output.len) return error.IndexOutOfBounds;

    const count = end - start;

    if (count > output.len - offset) return error.IndexOutOfBounds;

    @memmove(output.*[@intCast(offset)..][0..@intCast(count)], source[@intCast(start)..@intCast(end)]);

    return count;
}

pub inline fn writeUtf8Scalar(target: *const anyopaque, offset: u64, codepoint: u64) error{ IndexOutOfBounds, InvalidUnicodeScalar }!u64 {
    const output: *const []u8 = @ptrCast(@alignCast(target));
    const scalar = std.math.cast(u21, codepoint) orelse return error.InvalidUnicodeScalar;
    const count = std.unicode.utf8CodepointSequenceLength(scalar) catch return error.InvalidUnicodeScalar;

    if (offset > output.len or count > output.len - offset) return error.IndexOutOfBounds;

    return std.unicode.utf8Encode(scalar, output.*[@intCast(offset)..]) catch return error.InvalidUnicodeScalar;
}

pub inline fn writeU32(target: *const anyopaque, index: u64, value: u32) error{IndexOutOfBounds}!void {
    return write(u32, target, index, value);
}

pub inline fn writeU64(target: *const anyopaque, index: u64, value: u64) error{IndexOutOfBounds}!void {
    return write(u64, target, index, value);
}

pub inline fn writeOptionalU32(target: *const anyopaque, index: u64, value: ?u32) error{IndexOutOfBounds}!void {
    return write(?u32, target, index, value);
}

// The caller exclusively lends a descriptor for a mutable slice for the duration of the call.
inline fn write(comptime T: type, target: *const anyopaque, index: u64, value: T) error{IndexOutOfBounds}!void {
    const buffer: *const []T = @ptrCast(@alignCast(target));

    if (index >= buffer.len) return error.IndexOutOfBounds;

    buffer.*[@intCast(index)] = value;
}

pub inline fn readU32(target: *const anyopaque, index: u64) error{IndexOutOfBounds}!u32 {
    return read(u32, target, index);
}

pub inline fn readU64(target: *const anyopaque, index: u64) error{IndexOutOfBounds}!u64 {
    return read(u64, target, index);
}

inline fn read(comptime T: type, target: *const anyopaque, index: u64) error{IndexOutOfBounds}!T {
    const buffer: *const []T = @ptrCast(@alignCast(target));

    if (index >= buffer.len) return error.IndexOutOfBounds;

    return buffer.*[@intCast(index)];
}
