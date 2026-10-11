const std = @import("std");

/// Identity of the running generator: its own executable, so a rebuilt generator never reuses earlier output.
pub fn create(io: std.Io, allocator: std.mem.Allocator) ![32]u8 {
    const executable = try std.process.executablePathAlloc(io, allocator);
    const binary = try std.Io.Dir.cwd().readFileAlloc(io, executable, allocator, .unlimited);
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(binary, &digest, .{});

    return digest;
}
