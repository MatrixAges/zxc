const std = @import("std");
const Compile = @import("../compile.zig");
const Module = @import("../library/analyze.zig").Module;

pub fn check(context: Compile.Context, modules: []const Module, root: []const u8) !Compile.Status {
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    defer seen.deinit(context.allocator);

    for (modules) |module| {
        for (module.sources) |source| {
            if ((try seen.getOrPut(context.allocator, source.path)).found_existing) continue;

            var selected = context;

            selected.options.input = source.path;

            if (try @import("../lint.zig").checkSource(selected, source.source) != .success) return .failed;
        }

        for (module.store_definitions) |definition| {
            const path = try std.fs.path.resolve(context.allocator, &.{ root, definition.source_path });

            if ((try seen.getOrPut(context.allocator, path)).found_existing) continue;
            if (try file(context, path) != .success) return .failed;
        }
    }

    return .success;
}

pub fn file(context: Compile.Context, path: []const u8) !Compile.Status {
    var selected = context;
    selected.options.input = path;
    const source = try std.Io.Dir.cwd().readFileAlloc(context.io, path, context.allocator, .limited(16 * 1024 * 1024));

    defer context.allocator.free(source);

    return @import("../lint.zig").checkSource(selected, source);
}
