const std = @import("std");
const frame = @import("generated_generation_cache_envelope");
const columns = @import("zx").columns;
pub const Header = struct { bytes: []const u8, payload_size: usize };

pub fn prepare(buffer: []u8, compiler: []const u8, key: []const u8, size: u64, reading: bool) ?Header {
    var writer: std.Io.Writer = .fixed(buffer);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const input: std.meta.Child(frame.Input) = .{
        .writer = @ptrCast(&writer),
        .compiler = compiler,
        .key = key,
        .size = size,
        .reading = reading,
    };

    const layout = columns.invoke(frame.executeValue, empty.allocator(), &input) catch |err| {
        std.debug.panic("generation cache header could not be encoded: {s}", .{@errorName(err)});
    };

    if (!layout.accepted) return null;

    return .{ .bytes = writer.buffered(), .payload_size = @intCast(layout.payload_size) };
}
