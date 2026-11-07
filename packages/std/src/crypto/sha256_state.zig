const std = @import("std");
const Hash = std.crypto.hash.sha2.Sha256;

/// Borrows an initialized Sha256 owned by the host. Updates and finalization require exclusive access.
pub fn update(in: *const anyopaque, bytes: []const u8) void {
    state(in).update(bytes);
}

pub fn updateByte(in: *const anyopaque, value: u8) void {
    state(in).update(&.{value});
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
