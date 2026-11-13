const std = @import("std");
const zx = @import("zx");

pub fn path(allocator: std.mem.Allocator, directory: []const u8, key: []const u8, native: bool) std.mem.Allocator.Error![]u8 {
    var hash: [32]u8 = undefined;

    zx.Sha256.hash(key, &hash, .{});

    const digest = std.fmt.bytesToHex(hash, .lower);

    if (comptime !@import("parser_options").generated_parser) {
        return std.fmt.allocPrint(allocator, "{s}/{s}{s}.cache", .{ directory, if (native) "native/" else "", &digest });
    }

    const entry = @import("generated_semantic_file_key");
    const Input = std.meta.Child(entry.Input);
    var buffer: [128]u8 = undefined;
    var writer: std.Io.Writer = .fixed(&buffer);
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const input: Input = .{ .writer = @ptrCast(&writer), .native = native, .digest = &digest };

    try entry.executeValue(empty.allocator(), &input);

    return std.fmt.allocPrint(allocator, "{s}/{s}", .{ directory, writer.buffered() });
}
