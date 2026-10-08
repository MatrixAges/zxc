const std = @import("std");
const compiler = @import("compiler");

const samples = [_]struct { path: []const u8, source: []const u8 }{
    .{ .path = "map.zx", .source = @embedFile("源程序/map.zx") },
    .{ .path = "filter.zx", .source = @embedFile("源程序/filter.zx") },
    .{ .path = "every.zx", .source = @embedFile("源程序/every.zx") },
    .{ .path = "some.zx", .source = @embedFile("源程序/some.zx") },
};

test "compile frozen explicit context fixtures through the public compiler" {
    const memory = std.testing.allocator;

    for (samples) |sample| {
        const formatted = try compiler.format(memory, sample.source, sample.path);

        defer formatted.deinit(memory);

        try std.testing.expect(formatted == .source);
        try std.testing.expectEqualStrings(sample.source, formatted.source);

        const result = try compiler.compile(memory, sample.source, sample.path);

        defer result.deinit(memory);

        if (result == .diagnostic) std.debug.print("{s}: {t}: {s}\n", .{ sample.path, result.diagnostic.code, result.diagnostic.message });
        try std.testing.expect(result == .source);

        std.debug.print("\x1e{s}\x1f{s}\x1d", .{ sample.path, result.source });
    }
}
