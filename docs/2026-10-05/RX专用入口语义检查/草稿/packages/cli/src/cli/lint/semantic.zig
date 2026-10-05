const std = @import("std");
const Compile = @import("../compile.zig");
const model = @import("../../package/manifest/model.zig");

pub fn run(context: Compile.Context) !Compile.Status {
    var arena = std.heap.ArenaAllocator.init(context.allocator);

    defer arena.deinit();

    var scoped = context;

    scoped.allocator = arena.allocator();

    return execute(scoped) catch |err| {
        if (err == error.OutOfMemory or err == error.Canceled) return err;
        try context.stderr.print("{s}: semantic lint: {s}\n", .{ context.options.input, @errorName(err) });

        return .failed;
    };
}

fn execute(context: Compile.Context) !Compile.Status {
    const path = context.options.input;
    const manifest = std.mem.eql(u8, std.fs.path.basename(path), "pkg.yaml");

    if (!manifest and !std.mem.endsWith(u8, path, ".zx") and !std.mem.endsWith(u8, path, ".rx")) return error.InvalidSemanticInput;

    if (manifest) {
        if (try @import("../configuration/root.zig").run(context) != .success) return .failed;
    }

    var loaded = try @import("../project.zig").load(context.io, context.allocator, path, context.options.project);

    if (loaded.diagnostic) |message| {
        try context.stderr.print("{s}\n", .{message});

        return .failed;
    }

    if (!manifest) loaded.config.library = null;

    const entry = if (manifest) loaded.config.entry else loaded.project.entry;

    if (entry) |selected| {
        if (std.mem.endsWith(u8, selected, ".gateway.rx") or std.mem.endsWith(u8, selected, ".store.rx")) {
            loaded.project.entry = try std.fs.path.resolve(context.allocator, &.{ loaded.project.root_dir, selected });

            return @import("rx.zig").run(context, loaded);
        }
    }

    const fallback = [_]model.Export{.{
        .path = ".",
        .source = if (manifest) loaded.config.entry orelse "" else loaded.project.entry,
    }};

    if (!manifest or loaded.config.exports.len == 0) {
        if (fallback[0].source.len == 0) return error.MissingPublicModules;

        loaded.config.exports = &fallback;
    }

    var analyzed = (try @import("../library/analyze.zig").run(context.allocator, .{ .io = context.io, .loaded = loaded, .writer = context.stderr })) orelse return .failed;

    defer analyzed.deinit();

    if (try @import("sources.zig").check(context, analyzed.modules, loaded.project.root_dir) != .success) return .failed;

    var library = try analyzed.link(context.allocator);

    defer library.deinit();

    return .success;
}
