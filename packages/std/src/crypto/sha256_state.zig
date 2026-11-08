const std = @import("std");
const Hash = @import("sha256_backend").Sha256;

/// Initializes or restarts host-provided Hash storage without allocating.
pub fn reset(in: *const anyopaque) void {
    state(in).* = Hash.init(.{});
}

/// Borrows an initialized standard.Sha256 owned by the host. Updates and finalization require exclusive access.
pub fn update(in: *const anyopaque, bytes: []const u8) void {
    state(in).update(bytes);
}

pub fn updateByte(in: *const anyopaque, value: u8) void {
    state(in).update(&.{value});
}

pub fn updateU64Le(in: *const anyopaque, value: u64) void {
    var encoded: [@sizeOf(u64)]u8 = undefined;

    std.mem.writeInt(u64, &encoded, value, .little);
    state(in).update(&encoded);
}

/// Finalizes the borrowed state once; the returned digest belongs to allocator.
pub fn digest(allocator: std.mem.Allocator, in: *const anyopaque) std.mem.Allocator.Error![]const u8 {
    const output = try allocator.create([Hash.digest_length]u8);

    state(in).final(output);

    return output;
}

fn state(in: *const anyopaque) *Hash {
    return @ptrCast(@alignCast(@constCast(in)));
}
