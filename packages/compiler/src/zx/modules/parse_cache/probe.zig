const std = @import("std");
const zx = @import("zx");
pub const Action = if (generated) @FieldType(@typeInfo(@TypeOf(@import("generated_parse_cache_probe").executeValue(undefined, undefined))).error_union.payload, "action") else enum { Reuse, Upgrade, Parse };
const generated = @import("parser_options").generated_parser;

pub fn run(source: []const u8, text: ?[]const u8, stored: ?*const [32]u8, native: bool, indexed: bool, digest: *[32]u8) Action {
    if (comptime generated) {
        const rule = @import("generated_parse_cache_probe");
        const Input = std.meta.Child(rule.Input);
        const Format = std.meta.Child(@FieldType(Input, "format"));
        const format: Format = .{ .native = native, .indexed = indexed };
        const input: Input = .{ .format = &format, .source = source, .text = text, .stored = if (stored) |value| value else null };
        var buffer: [256]u8 = undefined;
        var fixed = std.heap.FixedBufferAllocator.init(&buffer);
        const result = zx.columns.invoke(rule.executeValue, fixed.allocator(), &input) catch unreachable;

        if (result.digest) |value| digest.* = value[0..digest.len].*;

        return result.action;
    }

    const text_matches = if (text) |value| zx.bytes.equal(value, source) else false;

    if (!text_matches) {
        zx.Sha256.hash(source, digest, .{});

        if (stored == null or !std.mem.eql(u8, stored.?, digest)) return .Parse;
    }

    return if (native and indexed) .Upgrade else .Reuse;
}
