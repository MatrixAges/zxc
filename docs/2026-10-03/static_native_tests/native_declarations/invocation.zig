const std = @import("std");

pub const nested = struct {
    pub const api = struct {
        pub fn seed() u64 {
            return 17;
        }
        pub fn seedAllocated(allocator: std.mem.Allocator) !u64 {
            const value = try allocator.create(u64);
            value.* = 19;

            return value.*;
        }
        pub fn combine(left: u64, right: u64) u64 {
            return left * 3 + right;
        }
        pub fn combineAllocated(allocator: std.mem.Allocator, left: u64, right: u64) ![]const u64 {
            return allocator.dupe(u64, &.{ left, right, left + right });
        }
    };
};
