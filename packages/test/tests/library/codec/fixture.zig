const std = @import("std");
const f = @import("library_fixture");
pub const compiler = f.compiler;
pub const codec = compiler.library.codec;

pub fn library() !compiler.library.Result {
    var left = try f.analyze("call.zx", f.function);
    defer left.deinit();
    var right = try f.analyze("types.zx", f.declaration);
    defer right.deinit();

    return compiler.library.link(std.testing.allocator, &.{ .{ .name = "run", .analysis = &left }, .{ .name = "types", .analysis = &right } });
}

pub fn encoded() ![]u8 {
    var value = try library();
    defer value.deinit();

    return codec.encode(std.testing.allocator, &value);
}

pub fn envelope(text: []const u8) ![]u8 {
    var digest: [32]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(text, &digest, .{});

    return std.fmt.allocPrint(std.testing.allocator, "zxc.library.v1\n{s}\n{s}", .{ std.fmt.bytesToHex(digest, .lower), text });
}

pub fn payload(bytes: []const u8) []const u8 {
    const first = std.mem.indexOfScalar(u8, bytes, '\n').?;
    const second = first + 1 + std.mem.indexOfScalar(u8, bytes[first + 1 ..], '\n').?;

    return bytes[second + 1 ..];
}
