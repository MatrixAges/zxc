const std = @import("std");
pub const compiler = @import("compiler");
pub const codec = compiler.project.SemanticCache.codec;
pub const identity = @as([32]u8, @splat(17));
pub const context = @as([32]u8, @splat(29));
pub const source = @import("record_fixture");

pub fn bytes(allocator: std.mem.Allocator) ![]u8 {
    var analysis = try source.analyze(std.testing.allocator);

    defer analysis.deinit();

    var artifact = try compiler.project.artifact.extract(std.testing.allocator, &analysis, 0);

    defer artifact.deinit();

    return codec.encode(allocator, artifact.value, context, identity);
}

pub fn envelope(payload: []const u8) ![]u8 {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(std.testing.allocator, "zxc.module.v2\n{s}\n{s}\n{s}", .{ std.fmt.bytesToHex(identity, .lower), std.fmt.bytesToHex(digest, .lower), payload });
}

pub fn reject(bytes_value: []const u8) !void {
    try std.testing.expectError(error.InvalidCache, codec.decode(std.testing.allocator, bytes_value, identity));
}
