const std = @import("std");
const interface = @import("../../interface.zig");
const scopes = @import("../../package_scope.zig");
const Options = @import("../../project.zig").Options;
const registry = @import("../../project/target/registry.zig");
const specifier = @import("../../specifier.zig");
const batch_size = scopes.lookup_batch_size;

pub fn prefetch(header: anytype, path: []const u8, project: *const Options, callback: anytype) !void {
    comptime std.debug.assert(batch_size <= @bitSizeOf(u64));

    var paths: [batch_size][]const u8 = undefined;
    var offset: usize = 0;
    var scoped: ?[]const interface.Native = null;
    const count = header.importCount();

    while (offset < count) {
        const size = @min(paths.len, count - offset);
        const batch = paths[0..size];

        for (batch, offset..) |*specifier_path, index| specifier_path.* = header.importAt(index).path;

        var mask = eligible(batch);

        if (mask != 0 and scoped == null) scoped = scopes.nativeInterfaces(project.package_scopes, path, project.native_interfaces);

        while (mask != 0) {
            const index = @ctz(mask);

            mask &= mask - 1;

            switch (registry.native(scoped.?, batch[index], false)) {
                .found => |entry| try callback.loadNative(entry.key()),
                .missing => {},
                .duplicate => unreachable,
            }
        }

        offset += size;
    }
}

fn eligible(paths: []const []const u8) u64 {
    if (comptime @import("parser_options").generated_parser) {
        var scratch = std.heap.FixedBufferAllocator.init(&.{});

        return @import("generated_semantic_cache_imports").executeValue(scratch.allocator(), paths) catch unreachable;
    }

    var mask: u64 = 0;

    for (paths, 0..) |path, index| {
        const kind = specifier.classify(path) catch continue;

        if (kind != .file and kind != .package) mask |= @as(u64, 1) << @intCast(index);
    }

    return mask;
}
