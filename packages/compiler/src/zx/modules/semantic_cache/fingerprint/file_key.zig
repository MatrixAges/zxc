const std = @import("std");
const zx = @import("zx");

pub fn path(allocator: std.mem.Allocator, directory: []const u8, key: []const u8, native: bool) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("parser_options").generated_parser) {
        var hash: [32]u8 = undefined;

        zx.Sha256.hash(key, &hash, .{});

        const digest = std.fmt.bytesToHex(hash, .lower);

        return std.fmt.allocPrint(allocator, "{s}/{s}{s}.cache", .{ directory, if (native) "native/" else "", &digest });
    }

    const entry = @import("generated_semantic_file_key");
    const Input = std.meta.Child(entry.Input);
    var buffer: [128]u8 = undefined;
    var writer: std.Io.Writer = .fixed(&buffer);
    var memory: [256]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&memory);
    const input: Input = .{ .writer = @ptrCast(&writer), .native = native, .key = key };

    entry.executeValue(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidRange, error.Overflow => unreachable,
    };

    return std.fmt.allocPrint(allocator, "{s}/{s}", .{ directory, writer.buffered() });
}
