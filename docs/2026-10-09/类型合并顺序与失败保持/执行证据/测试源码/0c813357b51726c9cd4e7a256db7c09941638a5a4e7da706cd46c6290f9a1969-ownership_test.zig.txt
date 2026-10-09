const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");

fn owned(options: f.Options) !void {
    var kept = block: {
        var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer memory.deinit();

        const allocator = memory.allocator();
        var source = try f.source(allocator, options);
        const types = try f.copyColumns(allocator, source.module.types);
        const origins = try f.copyColumns(allocator, source.module.nominal_types);
        var result = try f.link.merge(std.testing.allocator, &.{source.module});

        errdefer result.deinit();

        const ids = try check.module(result, source, 0);

        try f.sameColumns(types, source.module.types);
        try f.sameColumns(origins, source.module.nominal_types);

        source.poison();

        break :block .{ .result = result, .ids = ids };
    };

    defer kept.result.deinit();

    try check.graph(kept.result.types, kept.ids, options);
    try check.origin(kept.result, kept.ids.mode, options.mode_origin, options.mode_name);
    try check.origin(kept.result, kept.ids.node, .{ .native = options.native_owner }, options.native_name);
    try std.testing.expectEqual(@as(usize, 1), kept.result.mappings.len);
}

test "all type names fields members and child arrays survive source poisoning and release" {
    try owned(.{ .noise = true, .aliases = true });
}

test "source nominal owner survives source poisoning and release" {
    try owned(.{ .mode_origin = .{ .source = "/source/owned/types.zx" } });
}

test "native nominal owner survives source poisoning and release" {
    try owned(.{ .mode_origin = .{ .native = "zig:owned" }, .native_owner = "zig:other" });
}

test "external nominal owner and member survive source poisoning and release" {
    try owned(.{ .mode_origin = .{ .external = .{ .module = "owned_library", .member = "owned_types" } } });
}

test "remapped task result and errors survive source poisoning and release" {
    try owned(.{ .noise = true, .aliases = true, .change = .task_errors });
}
