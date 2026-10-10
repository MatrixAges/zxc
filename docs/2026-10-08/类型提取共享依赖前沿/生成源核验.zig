const std = @import("std");
const compiler = @import("compiler");
const source = @import("frontier_source");

test "generated frontier sources retain physical line limits and stable formatting" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const memory = arena.allocator();

    for ([_]source.Case{
        .{ .depth = 0, .width = 0 },
        .{ .depth = 1, .width = 1 },
        .{ .depth = 17, .width = 17 },
        .{ .depth = 65, .width = 65 },
        .{ .depth = 255, .width = 1 },
        .{ .depth = 257, .width = 1 },
    }) |args| {
        const files = try source.create(memory, args);

        for (files) |file| {
            const result = try compiler.format(memory, file.source, file.path);

            defer result.deinit(memory);

            try std.testing.expect(result == .source);
            try std.testing.expectEqualStrings(file.source, result.source);

            std.debug.print("\x1e{d}/{d}/{s}\x1f{s}", .{ args.depth, args.width, file.path, file.source });
        }
    }
}
