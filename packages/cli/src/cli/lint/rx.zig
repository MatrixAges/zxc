const std = @import("std");
const Compile = @import("../compile.zig");
const Loaded = @import("../project.zig").Loaded;
const sources = @import("sources.zig");

pub fn run(context: Compile.Context, loaded: Loaded) !Compile.Status {
    const path = loaded.project.entry;

    if (try sources.file(context, path) != .success) return .failed;

    if (std.mem.endsWith(u8, path, ".store.rx")) {
        const root = try std.fs.path.resolve(context.allocator, &.{loaded.project.root_dir});
        const entry = try std.fs.path.relative(context.allocator, root, null, root, path);

        var collection = (try @import("../rx/collection.zig").load(context.allocator, .{
            .io = context.io,
            .root = root,
            .entry = entry,
            .writer = context.stderr,
            .project = loaded.project,
        })) orelse return .failed;

        defer collection.deinit();

        const functions = try @import("../rx/type_sources.zig").collect(context.allocator, .{
            .io = context.io,
            .project = loaded.project,
            .modules = collection.data.modules,
            .stores = collection.data.stores,
            .functions = collection.data.functions,
            .writer = context.stderr,
        }) orelse return .failed;

        return if (try @import("../rx/store_types.zig").validate(context.io, context.allocator, collection.data, functions, loaded.project, context.stderr)) .success else .failed;
    }

    var analyzed = (try @import("../rx/gateway/analyze.zig").run(context.allocator, .{
        .io = context.io,
        .loaded = loaded,
        .writer = context.stderr,
    })) orelse return .failed;

    defer analyzed.deinit();

    if (analyzed.services) |services| {
        if (try sources.check(context, services.modules, loaded.project.root_dir) != .success) return .failed;
    }

    var linked = try analyzed.link(context.allocator);

    defer if (linked) |*library| library.deinit();

    return .success;
}
