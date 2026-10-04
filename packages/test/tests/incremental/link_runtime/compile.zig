const std = @import("std");
const compiler = @import("compiler");
const plain = @import("plain_fixture");
const slots = @import("slots_fixture");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer _ = heap.deinit();

    const allocator = heap.allocator();
    var linked = block: {
        const artifacts = extracted: {
            var analysis = if (std.mem.eql(u8, args[1], "plain")) try plain.analyze(allocator) else try slots.analyze(allocator);

            defer analysis.deinit();

            if (analysis.value != .ir) return error.InvalidAnalysis;

            const original = try compiler.zig.emit(allocator, analysis.value.ir);

            defer allocator.free(original);

            try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = original });

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

    if (try compiler.validateIr(allocator, linked.program) != null) return error.InvalidLinkedIr;

    const generated = try compiler.zig.emit(allocator, linked.program);

    defer allocator.free(generated);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = generated });
}
