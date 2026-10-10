const std = @import("std");
const compiler = @import("compiler");
const source = @import("frontier_source");

test "replay real project dependency depths before extraction" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const memory = arena.allocator();

    for ([_]usize{ 65, 129, 193, 255, 257 }) |depth| {
        std.debug.print("BEFORE analyze depth={d}\n", .{depth});

        var analysis = try compiler.project.analyze(memory, try source.create(memory, .{ .depth = depth, .width = 1 }), .{ .entry = "main.zx", .root_dir = "/project" });

        defer analysis.deinit();
        std.debug.print("AFTER analyze depth={d} result={t}\n", .{ depth, std.meta.activeTag(analysis.value) });

        if (analysis.value == .diagnostic) {
            try std.testing.expectEqualStrings("module dependency depth exceeds 256", analysis.value.diagnostic.message);

            continue;
        }

        std.debug.print("BEFORE extract depth={d}\n", .{depth});

        const index = for (analysis.modules, 0..) |record, position| {
            if (std.mem.eql(u8, record.path, "/project/main.zx")) break position;
        } else return error.MissingEntry;

        var result = try compiler.project.artifact.extract(std.testing.allocator, &analysis, index);

        defer result.deinit();
        std.debug.print("AFTER extract depth={d}\n", .{depth});
    }
}
