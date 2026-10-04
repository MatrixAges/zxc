const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 3) return error.ExpectedRootAndSources;

    var heap: std.heap.DebugAllocator(.{}) = .init;
    defer _ = heap.deinit();
    const allocator = heap.allocator();
    const sources = try init.arena.allocator().alloc(compiler.project.Source, args.len - 2);

    for (sources, args[2..]) |*source, path| {
        const full_path = try std.fs.path.resolve(init.arena.allocator(), &.{ args[1], path });
        source.* = .{ .path = path, .source = try std.Io.Dir.cwd().readFileAlloc(init.io, full_path, init.arena.allocator(), .unlimited) };
    }

    var expected_digest: [32]u8 = undefined;
    var expected_types: [32]u8 = undefined;

    var linked = linked_block: {
        const artifacts = blk: {
            var cache = compiler.project.ParseCache{ .allocator = allocator };

            defer cache.deinit();

            var analyzed = try compiler.analyzeProjectWithCache(allocator, sources, .{ .entry = sources[0].path, .root_dir = args[1] }, &cache);

            defer analyzed.deinit();

            if (analyzed.value == .diagnostic) {
                std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

                return error.InvalidProject;
            }

            const bundle = try compiler.zig.emitBundle(allocator, analyzed.value.ir);

            defer bundle.deinit(allocator);
            std.crypto.hash.sha2.Sha256.hash(bundle.source, &expected_digest, .{});
            std.crypto.hash.sha2.Sha256.hash(bundle.types, &expected_types, .{});

            const results = try init.arena.allocator().alloc(compiler.project.artifact.Result, analyzed.modules.len);
            var count: usize = 0;

            errdefer for (results[0..count]) |*artifact| artifact.deinit();

            for (results, 0..) |*artifact, index| {
                artifact.* = try compiler.project.artifact.extract(allocator, &analyzed, index);
                count += 1;
            }

            break :blk results;
        };

        defer for (artifacts) |*artifact| artifact.deinit();

        const modules = try init.arena.allocator().alloc(compiler.project.artifact.Module, artifacts.len);

        for (artifacts, modules) |artifact, *module| module.* = artifact.value;

        for (artifacts) |artifact| {
            const encoded = try std.json.Stringify.valueAlloc(allocator, artifact.value, .{});

            defer allocator.free(encoded);
            std.debug.print("module={s} types={d} functions={d} native={d} bytes={d}\n", .{ artifact.value.path, artifact.value.types.len, artifact.value.functions.len, artifact.value.native_modules.len, encoded.len });
        }

        break :linked_block try compiler.project.artifact.linker.link(allocator, modules, modules[modules.len - 1].path);
    };

    defer linked.deinit();

    const bundle = try compiler.zig.emitBundle(allocator, linked.program);

    defer bundle.deinit(allocator);

    var actual_digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(bundle.source, &actual_digest, .{});

    var actual_types: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(bundle.types, &actual_types, .{});

    const matched = std.mem.eql(u8, &expected_digest, &actual_digest);
    const matched_types = std.mem.eql(u8, &expected_types, &actual_types);
    const digest = std.fmt.bytesToHex(actual_digest, .lower);

    std.debug.print("linked types={d} functions={d} native={d} bytes={d} same_source={} same_types={} sha256={s}\n", .{ linked.program.types.len, linked.program.functions.len, linked.program.native_modules.len, bundle.source.len, matched, matched_types, &digest });

    if (!matched or !matched_types) return error.GeneratedSourceMismatch;
}
