const std = @import("std");
const builtin = @import("builtin");
const Message = std.zig.Server.Message;
pub const Frame = struct { tag: Message.Tag, body: []const u8 };
pub const version: Frame = .{ .tag = .zig_version, .body = builtin.zig_version_string };
pub const finish: Frame = .{ .tag = .error_bundle, .body = &(@as([8]u8, @splat(0))) };
pub const digest: Frame = .{ .tag = .emit_digest, .body = &(@as([(1 + std.Build.Cache.bin_digest_len)]u8, @splat(0))) };
pub const inputs: Frame = .{ .tag = .file_system_inputs, .body = &.{ 1, 'a', '.', 'z', 'i', 'g', 0 } };

pub fn encode(allocator: std.mem.Allocator, frames: []const Frame) ![]u8 {
    var bytes: std.ArrayList(u8) = .empty;

    errdefer bytes.deinit(allocator);

    for (frames) |frame| {
        var header: [8]u8 = undefined;

        std.mem.writeInt(u32, header[0..4], @intFromEnum(frame.tag), .little);
        std.mem.writeInt(u32, header[4..8], @intCast(frame.body.len), .little);

        try bytes.appendSlice(allocator, &header);
        try bytes.appendSlice(allocator, frame.body);
    }

    return bytes.toOwnedSlice(allocator);
}

pub fn errorBody(allocator: std.mem.Allocator, extra: []const u32, strings: []const u8) ![]u8 {
    const bytes = try allocator.alloc(u8, 8 + extra.len * 4 + strings.len);

    std.mem.writeInt(u32, bytes[0..4], @intCast(extra.len), .little);
    std.mem.writeInt(u32, bytes[4..8], @intCast(strings.len), .little);

    for (extra, 0..) |value, index| {
        std.mem.writeInt(u32, bytes[8 + index * 4 ..][0..4], value, .little);
    }

    @memcpy(bytes[8 + extra.len * 4 ..], strings);

    return bytes;
}
