const std = @import("std");
const fast = @import("bytes_backend");
pub const equal = fast.equal;
pub const hash = fast.hash;

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
