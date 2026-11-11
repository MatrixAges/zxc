const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_semantic_cache_version");
const Self = @This();

pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, options: std.json.ParseOptions) std.json.ParseError(@TypeOf(source.*))!Self {
    const actual = try std.json.innerParse(u32, allocator, source, options);
    const input: std.meta.Child(generated.Input) = .{ .actual = actual, .expected = zx.ir_version };

    if (!(try generated.executeValue(allocator, &input))) return error.UnexpectedToken;

    return .{};
}
