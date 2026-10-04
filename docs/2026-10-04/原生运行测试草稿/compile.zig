const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer _ = heap.deinit();

    const allocator = heap.allocator();
    var linked = block: {
        const artifacts = extracted: {
            var analysis = try compiler.project.analyze(allocator, &.{
                .{ .path = "main.zx", .source = @embedFile("main.zx") },
                .{ .path = "helper.zx", .source = @embedFile("helper.zx") },
            }, .{
                .entry = "main.zx",
                .root_dir = "/project",
                .native_interfaces = &.{.{ .specifier = "zig:choice", .path = "choice.d.zx", .source = @embedFile("choice.d.zx"), .module = "choice" }},
            });

            defer analysis.deinit();

            if (analysis.value != .ir) return error.InvalidAnalysis;

            const bundle = try compiler.zig.emitBundle(allocator, analysis.value.ir);

            defer bundle.deinit(allocator);

            try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[1], .data = bundle.source });
            try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.types });

            const results = try init.arena.allocator().alloc(compiler.project.artifact.Result, analysis.modules.len);
            var count: usize = 0;

            errdefer for (results[0..count]) |*result| result.deinit();

            for (results, 0..) |*result, index| {
                result.* = try compiler.project.artifact.extract(allocator, &analysis, index);
                count += 1;
            }

            break :extracted results;
        };

        defer for (artifacts) |*result| result.deinit();

        const modules = try init.arena.allocator().alloc(compiler.project.artifact.Module, artifacts.len);

        for (artifacts, 0..) |result, index| modules[artifacts.len - 1 - index] = result.value;

        break :block try compiler.project.artifact.linker.link(allocator, modules, "/project/main.zx");
    };

    defer linked.deinit();

    const bundle = try compiler.zig.emitBundle(allocator, linked.program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4], .data = bundle.types });
}
