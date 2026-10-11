//! Byte strings compared and hashed in a way that stays fast when built for size. The standard library compares in
//! vector-sized chunks bit-cast from arrays, which a size-optimized build lowers to a byte-by-byte copy through the
//! stack: about a hundred times slower once a string passes 32 bytes; it reads the words it hashes the same way, as a
//! loop over their bytes. The bootstrap generator builds for size so that it compiles quickly, so where it compares or
//! hashes paths, source texts and outputs, or keys maps by them, it goes through these instead.
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

/// `std.hash.Wyhash.hash`, with the same results, reading each word with one load.
pub fn hash(seed: u64, input: []const u8) u64 {
    const secret = [_]u64{ 0xa0761d6478bd642f, 0xe7037ed1a0b428db, 0x8ebc6af09c88c6e3, 0x589965cc75374cc3 };
    var state: [3]u64 = @splat(seed ^ mix(seed ^ secret[0], secret[1]));
    var a: u64 = 0;
    var b: u64 = 0;

    if (input.len > 16) {
        var index: usize = 0;

        if (input.len >= 48) {
            while (index + 48 < input.len) : (index += 48) {
                inline for (&state, 0..) |*lane, at| lane.* = mix(word(u64, input, index + 16 * at) ^ secret[at + 1], word(u64, input, index + 16 * at + 8) ^ lane.*);
            }

            state[0] ^= state[1] ^ state[2];
        }

        while (index + 16 < input.len) : (index += 16) state[0] = mix(word(u64, input, index) ^ secret[1], word(u64, input, index + 8) ^ state[0]);

        a = word(u64, input, input.len - 16);
        b = word(u64, input, input.len - 8);
    } else if (input.len >= 4) {
        const end = input.len - 4;
        const quarter = (input.len >> 3) << 2;
        a = @as(u64, word(u32, input, 0)) << 32 | word(u32, input, quarter);
        b = @as(u64, word(u32, input, end)) << 32 | word(u32, input, end - quarter);
    } else if (input.len > 0) {
        a = @as(u64, input[0]) << 16 | @as(u64, input[input.len >> 1]) << 8 | input[input.len - 1];
    }

    a ^= secret[1];
    b ^= state[0];
    const product = @as(u128, a) * b;

    return mix(@as(u64, @truncate(product)) ^ secret[0] ^ input.len, @as(u64, @truncate(product >> 64)) ^ secret[1]);
}

fn mix(a: u64, b: u64) u64 {
    const product = @as(u128, a) * b;

    return @as(u64, @truncate(product)) ^ @as(u64, @truncate(product >> 64));
}

fn word(comptime Word: type, input: []const u8, at: usize) Word {
    return std.mem.littleToNative(Word, @as(*align(1) const Word, @ptrCast(input[at..].ptr)).*);
}

/// Keys maps by byte strings hashed and compared through `hash` and `equal`.
pub const Context = struct {
    pub fn hash(_: Context, key: []const u8) u64 {
        return @import("bytes.zig").hash(0, key);
    }
    pub fn eql(_: Context, left: []const u8, right: []const u8) bool {
        return equal(left, right);
    }
};

pub fn Map(comptime Value: type) type {
    return std.HashMapUnmanaged([]const u8, Value, Context, std.hash_map.default_max_load_percentage);
}
