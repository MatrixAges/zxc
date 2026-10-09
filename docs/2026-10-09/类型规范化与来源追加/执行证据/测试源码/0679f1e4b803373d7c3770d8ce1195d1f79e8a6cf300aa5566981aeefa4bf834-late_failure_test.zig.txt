const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const check = @import("check.zig");
const cases = @import("cases.zig");
const multiple = @import("multiple.zig");
const Outcome = enum { success, conflict, missing };

fn run(allocator: std.mem.Allocator, outcome: Outcome) !void {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const setup = memory.allocator();

    var sources = [_]f.Source{
        try f.source(setup, .{}),
        try f.source(setup, .{ .noise = true, .aliases = true }),
        try f.source(setup, .{ .change = .tuple_tail }),
        try f.source(setup, if (outcome == .conflict) .{ .members = &.{ "First", "Third" } } else .{ .aliases = true }),
    };

    if (outcome == .missing) {
        var selected: f.Origins.Storage = .{};
        const last = &sources[3];

        for (0..last.module.nominal_types.count()) |index| {
            const item = last.module.nominal_types.at(index);

            if (item.type_id == last.ids.mode or item.type_id == last.aliases.?.mode) continue;
            try selected.append(setup, item);
        }

        last.module.nominal_types = selected.view();
    }

    var saved: [4]multiple.Snapshot = undefined;
    var modules: [4]f.compiler.project.artifact.Module = undefined;

    for (sources, 0..) |source, index| {
        saved[index] = try multiple.snapshot(setup, source);
        modules[index] = source.module;
    }

    var result = f.link.merge(allocator, &modules) catch |err| {
        for (sources, saved) |source, before| try multiple.unchanged(before, source);

        if (err == error.OutOfMemory) return err;

        switch (outcome) {
            .success => return err,
            .conflict => try std.testing.expectEqual(error.ConflictingNominalType, err),
            .missing => try std.testing.expectEqual(error.MissingNominalOrigin, err),
        }

        return;
    };

    defer result.deinit();

    try std.testing.expectEqual(Outcome.success, outcome);
    try std.testing.expectEqual(cases.base_count + 7, result.types.count());
    try std.testing.expectEqual(@as(usize, 3), result.nominal_types.count());
    try std.testing.expectEqual(@as(usize, 4), result.mappings.len);
    for (sources, 0..) |source, slot| _ = try check.module(result, source, slot);
    for (sources, saved) |source, before| try multiple.unchanged(before, source);
}

test "fourth module nominal conflict preserves all earlier input graphs" {
    try run(std.testing.allocator, .conflict);
}

test "fourth module missing nominal origin preserves all earlier input graphs" {
    try run(std.testing.allocator, .missing);
}

test "four module merge cleans every allocation failure and preserves all inputs" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Outcome.success});
}

test "fourth module conflict cleans every allocation failure and preserves all inputs" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Outcome.conflict});
}

test "fourth module missing origin cleans every allocation failure and preserves all inputs" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Outcome.missing});
}
