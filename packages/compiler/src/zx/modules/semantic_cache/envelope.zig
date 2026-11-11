const std = @import("std");
const columns = @import("zx").columns;
const layout = @import("generated_semantic_cache_layout");
const opening = @import("generated_semantic_cache_open");
const sealing = @import("generated_semantic_cache_seal");

pub fn encode(allocator: std.mem.Allocator, payload: anytype, compiler_digest: [32]u8) std.mem.Allocator.Error![]u8 {
    const compiler_hex = std.fmt.bytesToHex(compiler_digest, .lower);
    var out: std.Io.Writer.Allocating = .init(allocator);

    errdefer out.deinit();

    const payload_start = headerSize(compiler_hex.len);
    const header_space = out.writer.writableSlice(payload_start) catch return error.OutOfMemory;

    @memset(header_space, 0);
    std.json.Stringify.value(payload, .{}, &out.writer) catch return error.OutOfMemory;

    const encoded = out.writer.buffered();

    seal(encoded[0..payload_start], encoded[payload_start..], &compiler_hex);

    return out.toOwnedSlice();
}

fn headerSize(compiler_width: usize) usize {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const shape = layout.executeValue(empty.allocator(), compiler_width) catch unreachable;

    return @intCast(shape.payload_start);
}

fn seal(header: []u8, payload: []const u8, compiler: []const u8) void {
    var writer: std.Io.Writer = .fixed(header);
    var buffer: [256]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&buffer);

    const input: std.meta.Child(sealing.Input) = .{
        .writer = @ptrCast(&writer),
        .compiler = compiler,
        .payload = payload,
    };

    columns.invoke(sealing.executeValue, scratch.allocator(), &input) catch |err| {
        std.debug.panic("semantic cache header could not be written: {s}", .{@errorName(err)});
    };

    std.debug.assert(writer.end == header.len);
}

pub fn open(source: []const u8, compiler_digest: [32]u8) ?[]const u8 {
    const compiler_hex = std.fmt.bytesToHex(compiler_digest, .lower);
    var buffer: [256]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&buffer);

    const input: std.meta.Child(opening.Input) = .{
        .source = source,
        .compiler = &compiler_hex,
    };

    const start = (columns.invoke(opening.executeValue, scratch.allocator(), &input) catch |err| {
        std.debug.panic("semantic cache header could not be checked: {s}", .{@errorName(err)});
    }) orelse return null;

    return source[@intCast(start)..];
}
