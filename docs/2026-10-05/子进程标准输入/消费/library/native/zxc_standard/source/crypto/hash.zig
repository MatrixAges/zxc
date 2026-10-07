const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn sha256(allocator: Allocator, input: []const u8) Allocator.Error![]const u8 {
    const Hash = std.crypto.hash.sha2.Sha256;
    const output = try allocator.create([Hash.digest_length]u8);

    Hash.hash(input, output, .{});

    return output;
}

pub fn sha512(allocator: Allocator, input: []const u8) Allocator.Error![]const u8 {
    const Hash = std.crypto.hash.sha2.Sha512;
    const output = try allocator.create([Hash.digest_length]u8);

    Hash.hash(input, output, .{});

    return output;
}
