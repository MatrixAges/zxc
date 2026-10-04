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

    var cache = compiler.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    for (0..2) |index| {
        var analyzed = try compiler.analyzeProjectWithCache(allocator, sources, .{ .entry = sources[0].path, .root_dir = args[1] }, &cache);

        defer analyzed.deinit();

        if (analyzed.value == .diagnostic) {
            std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

            return error.InvalidProject;
        }

        const bundle = try compiler.zig.emitBundle(allocator, analyzed.value.ir);

        defer bundle.deinit(allocator);

        var generated_digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(bundle.source, &generated_digest, .{});

        const generated_hash = std.fmt.bytesToHex(generated_digest, .lower);

        std.debug.print("pass={d} parsed={d} reused={d} source_bytes={d} source_sha256={s}\n", .{ index + 1, cache.parsed, cache.reused, bundle.source.len, &generated_hash });

        for (analyzed.modules) |module| {
            const digest = std.fmt.bytesToHex(module.source_digest, .lower);

            std.debug.print("module={s} body={s} exports={d} imports={d} sha256={s}\n", .{ module.path, @tagName(module.body), module.exports.len, module.imports.len, &digest });

            if (module.body == .function) std.debug.print("function_owner={s}\n", .{analyzed.value.ir.functions[@intFromEnum(module.body.function)].file_name});

            for (module.imports) |dependency| {
                switch (dependency.target) {
                    .source => |path| std.debug.print("import={s} target={s} kind={s} names={d}\n", .{ dependency.specifier, path, @tagName(dependency.kind), dependency.names.len }),
                    .native, .external => std.debug.print("import={s} target={s} kind={s} names={d}\n", .{ dependency.specifier, @tagName(dependency.target), @tagName(dependency.kind), dependency.names.len }),
                }
            }
        }

        for (analyzed.nominal_types) |item| {
            switch (item.origin) {
                .source, .native => |owner| std.debug.print("nominal={s} kind={s} owner={s} type={d}\n", .{ item.name, @tagName(item.origin), owner, @intFromEnum(item.type_id) }),
                .external => |owner| std.debug.print("nominal={s} importer={s} binding={s} member={s} type={d}\n", .{ item.name, owner.importer, owner.binding, owner.member, @intFromEnum(item.type_id) }),
            }
        }
    }
}
