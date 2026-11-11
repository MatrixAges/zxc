const std = @import("std");
const columns = @import("zx").columns;
const layout = @import("generated_library_envelope_layout");
const opening = @import("generated_library_envelope_open");
const sealing = @import("generated_library_envelope_seal");
const versions = @import("generated_library_envelope_versions");

pub const Payload = struct {
    bytes: []const u8,
    maximum_depth: usize,
    legacy: bool,
};

pub fn open(source: []const u8) ?Payload {
    var buffer: [256]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&buffer);

    const payload = (opening.executeValue(scratch.allocator(), source) catch |err| {
        std.debug.panic("library header could not be checked: {s}", .{@errorName(err)});
    }) orelse return null;

    return .{ .bytes = source[@intCast(payload.start)..], .maximum_depth = @intCast(payload.maximum_depth), .legacy = payload.legacy };
}

pub fn encode(allocator: std.mem.Allocator, payload: anytype) std.mem.Allocator.Error![]u8 {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const header_size: usize = @intCast(layout.executeValue(empty.allocator(), {}) catch unreachable);
    var out = try @import("frontend").artifact_json.write(allocator, payload, header_size);

    errdefer out.deinit();

    const encoded = out.writer.buffered();
    var writer: std.Io.Writer = .fixed(encoded[0..header_size]);
    var buffer: [256]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&buffer);
    const input: std.meta.Child(sealing.Input) = .{ .writer = @ptrCast(&writer), .payload = encoded[header_size..] };

    columns.invoke(sealing.executeValue, scratch.allocator(), &input) catch |err| {
        std.debug.panic("library header could not be written: {s}", .{@errorName(err)});
    };

    std.debug.assert(writer.end == header_size);

    return out.toOwnedSlice();
}

pub fn compatible(outer: u32, program: u32, expected: u32) bool {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const input: std.meta.Child(versions.Input) = .{ .outer = outer, .program = program, .expected = expected };

    return versions.executeValue(empty.allocator(), &input) catch unreachable;
}
