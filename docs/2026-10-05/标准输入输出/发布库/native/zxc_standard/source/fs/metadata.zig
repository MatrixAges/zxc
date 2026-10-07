const std = @import("std");
const api = @import("zxc_abi").native.@"std:fs";
const path = @import("path.zig");
const Allocator = std.mem.Allocator;

pub fn stat(allocator: Allocator, io: std.Io, input: []const u8) !api.Stat {
    return read(allocator, io, input, true);
}

pub fn lstat(allocator: Allocator, io: std.Io, input: []const u8) !api.Stat {
    return read(allocator, io, input, false);
}

fn read(allocator: Allocator, io: std.Io, input: []const u8, follow: bool) !api.Stat {
    try path.validate(input);

    const metadata = try std.Io.Dir.cwd().statFile(io, input, .{ .follow_symlinks = follow });
    const result = try allocator.create(api.stat.OutputValue);

    errdefer allocator.destroy(result);

    result.* = .{
        .kind = switch (metadata.kind) {
            .file => .File,
            .directory => .Directory,
            .sym_link => .SymbolicLink,
            .block_device => .BlockDevice,
            .character_device => .CharacterDevice,
            .named_pipe => .Fifo,
            .unix_domain_socket => .Socket,
            else => .Unknown,
        },
        .size = metadata.size,
        .mtime_ms = try milliseconds(metadata.mtime),
        .ctime_ms = try milliseconds(metadata.ctime),
        .atime_ms = if (metadata.atime) |time| try milliseconds(time) else null,
    };

    return result;
}

fn milliseconds(time: std.Io.Timestamp) !i64 {
    return std.math.cast(i64, @divTrunc(time.nanoseconds, std.time.ns_per_ms)) orelse error.TimestampOutOfRange;
}
