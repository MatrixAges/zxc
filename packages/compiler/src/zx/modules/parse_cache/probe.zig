const std = @import("std");
const zx = @import("zx");

pub const Action = enum { reuse, upgrade, parse };

pub fn run(source: []const u8, text: ?[]const u8, stored: ?*const [32]u8, native: bool, indexed: bool, digest: *[32]u8) Action {
    const text_matches = if (text) |value| zx.bytes.equal(value, source) else false;

    if (comptime @import("parser_options").generated_parser) {
        const generated = @import("generated_parse_cache_probe");
        const Input = std.meta.Child(generated.Input);
        const Format = std.meta.Child(@FieldType(Input, "format"));
        const format: Format = .{ .native = native, .indexed = indexed };
        const input: Input = .{ .format = &format, .text_matches = text_matches, .source = source, .stored = if (stored) |value| value else null };
        var buffer: [256]u8 = undefined;
        var fixed = std.heap.FixedBufferAllocator.init(&buffer);
        const result = zx.columns.invoke(generated.executeValue, fixed.allocator(), &input) catch unreachable;

        if (result.digest) |value| digest.* = value[0..digest.len].*;

        return switch (result.action) {
            .Reuse => .reuse,
            .Upgrade => .upgrade,
            .Parse => .parse,
        };
    }

    if (!text_matches) {
        zx.Sha256.hash(source, digest, .{});

        if (stored == null or !std.mem.eql(u8, stored.?, digest)) return .parse;
    }

    return if (native and indexed) .upgrade else .reuse;
}
