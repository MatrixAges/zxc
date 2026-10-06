const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const check = @import("check.zig");
const Outcome = enum { success, conflict, missing };

fn run(allocator: std.mem.Allocator, outcome: Outcome) !void {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const setup = memory.allocator();
    const options: f.Options = .{ .noise = true, .aliases = true, .mode_origin = .{ .external = .{ .module = "library", .member = "types" } } };
    const left = try f.source(setup, options);
    var right = try f.source(setup, if (outcome == .conflict) .{ .members = &.{ "First", "Third" }, .mode_origin = options.mode_origin } else options);

    if (outcome == .missing) {
        const table = right.module.nominal_types;
        var selected: f.Origins.Storage = .{};

        for (0..table.count()) |index| {
            const item = table.at(index);

            if (item.type_id == right.ids.mode or item.type_id == right.aliases.?.mode) continue;
            try selected.append(setup, item);
        }

        right.module.nominal_types = selected.view();
    }

    const left_types = try f.copyColumns(setup, left.module.types);
    const left_origins = try f.copyColumns(setup, left.module.nominal_types);
    const right_types = try f.copyColumns(setup, right.module.types);
    const right_origins = try f.copyColumns(setup, right.module.nominal_types);

    var result = f.link.merge(allocator, &.{ left.module, right.module }) catch |err| {
        try f.sameColumns(left_types, left.module.types);
        try f.sameColumns(left_origins, left.module.nominal_types);
        try f.sameColumns(right_types, right.module.types);
        try f.sameColumns(right_origins, right.module.nominal_types);

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

    _ = try check.module(result, left, 0);
    _ = try check.module(result, right, 1);

    try std.testing.expectEqual(std.enums.values(f.ir.Scalar).len + @typeInfo(f.Ids).@"struct".field_names.len + 2, result.types.count());
    try std.testing.expectEqual(@as(usize, 3), result.nominal_types.count());
    try f.sameColumns(left_types, left.module.types);
    try f.sameColumns(left_origins, left.module.nominal_types);
    try f.sameColumns(right_types, right.module.types);
    try f.sameColumns(right_origins, right.module.nominal_types);
}

test "full repeated graph merge cleans every allocation failure without mutating inputs" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Outcome.success});
}

test "late nominal conflict cleans every allocation failure without mutating inputs" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Outcome.conflict});
}

test "missing nominal origin cleans every allocation failure without mutating inputs" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Outcome.missing});
}
