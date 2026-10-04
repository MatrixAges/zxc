const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 3) return error.ExpectedRootAndSources;

    const sources = try allocator.alloc(compiler.project.Source, args.len - 2);

    for (sources, args[2..]) |*source, path| {
        const full_path = try std.fs.path.resolve(allocator, &.{ args[1], path });
        source.* = .{ .path = path, .source = try std.Io.Dir.cwd().readFileAlloc(init.io, full_path, allocator, .unlimited) };
    }

    var heap: std.heap.DebugAllocator(.{}) = .init;
    defer _ = heap.deinit();
    const semantic_allocator = heap.allocator();
    var expected: ?[32]u8 = null;

    var retained = blk: {
        var cache = compiler.project.SemanticCache.init(semantic_allocator);

        defer cache.deinit();

        var generated_cache = compiler.zig.GenerationCache.init(semantic_allocator);

        defer generated_cache.deinit();

        for (0..3) |index| {
            if (index == 2) sources[sources.len - 1].source = try std.mem.concat(allocator, u8, &.{ sources[sources.len - 1].source, "\n" });

            var analyzed = try compiler.analyzeProjectIncremental(semantic_allocator, sources, .{ .entry = sources[0].path, .root_dir = args[1] }, &cache);

            errdefer analyzed.deinit();

            if (analyzed.value == .diagnostic) {
                std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

                return error.InvalidProject;
            }

            var bundle = try compiler.zig.emitModulesCached(semantic_allocator, &analyzed, &generated_cache);

            errdefer bundle.deinit();

            const generated = digest(bundle);

            if (expected) |previous| {
                if (!std.mem.eql(u8, &previous, &generated)) return error.GeneratedSourceMismatch;
            } else expected = generated;

            std.debug.print("pass={d} generated={d} reused={d} same_bundle=true\n", .{ index + 1, generated_cache.generated, generated_cache.reused });
            analyzed.deinit();

            if (index == 2) break :blk bundle;

            bundle.deinit();
        }

        unreachable;
    };

    defer retained.deinit();

    const generated = digest(retained);

    if (!std.mem.eql(u8, &expected.?, &generated)) return error.GeneratedSourceMismatch;

    std.debug.print("released_cache=true retained_result=true\n", .{});
}

fn digest(bundle: compiler.zig.ModuleBundle) [32]u8 {
    var result: [32]u8 = undefined;
    var hasher = std.crypto.hash.sha2.Sha256.init(.{});

    hasher.update(bundle.entry.source);
    hasher.update(bundle.types);

    for (bundle.modules) |module| {
        hasher.update(module.name);
        hasher.update(module.source);
    }

    hasher.final(&result);

    return result;
}
