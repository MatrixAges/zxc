const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");
const cases = @import("cases.zig");

pub const Snapshot = struct {
    types: f.ir.TypeTable,
    origins: f.Origins.Table,
};

pub fn snapshot(allocator: std.mem.Allocator, source: f.Source) !Snapshot {
    return .{
        .types = try f.copyColumns(allocator, source.module.types),
        .origins = try f.copyColumns(allocator, source.module.nominal_types),
    };
}

pub fn unchanged(saved: Snapshot, source: f.Source) !void {
    try f.sameColumns(saved.types, source.module.types);
    try f.sameColumns(saved.origins, source.module.nominal_types);
}

pub fn permutations(change: f.Change, shared: cases.Shared, added: usize) !void {
    const orders = [_][3]usize{ .{ 0, 1, 2 }, .{ 0, 2, 1 }, .{ 1, 0, 2 }, .{ 1, 2, 0 }, .{ 2, 0, 1 }, .{ 2, 1, 0 } };

    for (orders) |order| {
        var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer memory.deinit();

        const allocator = memory.allocator();

        const sources = [_]f.Source{
            try f.source(allocator, .{}),
            try f.source(allocator, .{ .noise = true, .aliases = true }),
            try f.source(allocator, .{ .change = change }),
        };

        var saved: [3]Snapshot = undefined;
        var modules: [3]f.compiler.project.artifact.Module = undefined;

        for (sources, 0..) |source, index| saved[index] = try snapshot(allocator, source);
        for (order, 0..) |index, slot| modules[slot] = sources[index].module;

        var result = try f.link.merge(std.testing.allocator, &modules);

        defer result.deinit();

        try std.testing.expectEqual(cases.base_count + 2 + added, result.types.count());
        try std.testing.expectEqual(@as(usize, 3), result.nominal_types.count());
        try std.testing.expectEqual(@as(usize, 3), result.mappings.len);

        var mapped: [3]f.Ids = undefined;

        for (order, 0..) |index, slot| mapped[index] = try check.module(result, sources[index], slot);

        inline for (@typeInfo(f.Ids).@"struct".field_names) |name| {
            try std.testing.expectEqual(@field(mapped[0], name), @field(mapped[1], name));
            try std.testing.expectEqual(@field(shared, name), @field(mapped[0], name) == @field(mapped[2], name));
        }

        for (sources, saved) |source, before| try unchanged(before, source);
    }
}
