//! Byte strings compared in a way that stays fast when built for size. The standard library compares in vector-sized
//! chunks bit-cast from arrays, which a size-optimized build lowers to a byte-by-byte copy through the stack: about a
//! hundred times slower once a string passes 32 bytes. The bootstrap generator builds for size so that it compiles
//! quickly, so where it compares paths and source texts, or keys maps by them, it goes through these instead.
const std = @import("std");

pub fn equal(left: []const u8, right: []const u8) bool {
    if (left.len != right.len) return false;
    if (left.ptr == right.ptr) return true;

    const Chunk = @Vector(16, u8);
    var index: usize = 0;

    while (index + 16 <= left.len) : (index += 16) {
        const a: Chunk = left[index..][0..16].*;
        const b: Chunk = right[index..][0..16].*;

        if (@reduce(.Or, a != b)) return false;
    }

    while (index < left.len) : (index += 1) {
        if (left[index] != right[index]) return false;
    }

    return true;
}

/// Keys maps by byte strings compared through `equal`.
pub const Context = struct {
    pub fn hash(_: Context, key: []const u8) u64 {
        return std.hash.Wyhash.hash(0, key);
    }
    pub fn eql(_: Context, left: []const u8, right: []const u8) bool {
        return equal(left, right);
    }
};

pub fn Map(comptime Value: type) type {
    return std.HashMapUnmanaged([]const u8, Value, Context, std.hash_map.default_max_load_percentage);
}
