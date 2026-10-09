const std = @import("std");
const h = @import("native_keys/check.zig");
const f = h.f;

fn failedSequence(sequence: []const usize, missing: usize) !void {
    for (f.orders) |order| {
        var analysis = try f.analyze(order, true);

        defer analysis.deinit();

        var imports: [3]f.Import = undefined;

        for (sequence, 0..) |provider, position| imports[position] = try f.dependency(analysis, f.specifiers[provider]);

        imports[missing].identity = "missing@1";
        const selected = try h.records.types(&analysis, imports[0..sequence.len]);

        try h.rejected(&analysis, selected);
        try h.accepted(&analysis, try f.index(analysis, "/project/main.zx"), &f.identities);
    }
}

fn ignored(target: f.Record.Target) !void {
    for ([_]bool{ false, true }) |matching| {
        var analysis = try f.analyze(f.orders[0], true);

        defer analysis.deinit();

        var item = try f.dependency(analysis, f.specifiers[0]);

        item.target = target;

        if (!matching) {
            item.identity = "missing@1";
            item.specifier = "zig:unresolved";
        }

        const selected = try h.records.types(&analysis, &.{item});

        try h.accepted(&analysis, selected, &.{});
    }
}

test "types with no declared native dependency retain no unrelated native modules" {
    var analysis = try f.analyze(f.orders[0], true);

    defer analysis.deinit();

    try h.accepted(&analysis, try f.index(analysis, "/project/types.zx"), &.{});
}

test "unused native dependency scans through unrelated provider rows in every order" {
    for (f.orders) |order| {
        var analysis = try f.analyze(order, true);

        defer analysis.deinit();

        for (f.specifiers, f.identities) |specifier, key| {
            const item = try f.dependency(analysis, specifier);
            const selected = try h.records.types(&analysis, &.{item});

            try h.accepted(&analysis, selected, &.{key});
        }
    }
}

test "all unused native dependencies are included independently of their source order" {
    for (f.orders) |order| {
        var analysis = try f.analyze(order, true);

        defer analysis.deinit();

        const imports = [_]f.Import{ try f.dependency(analysis, f.specifiers[2]), try f.dependency(analysis, f.specifiers[0]), try f.dependency(analysis, f.specifiers[1]) };
        const selected = try h.records.types(&analysis, &imports);

        try h.accepted(&analysis, selected, &f.identities);
    }
}

test "duplicate native dependencies preserve records while retaining the provider once" {
    var analysis = try f.analyze(f.orders[0], true);

    defer analysis.deinit();

    const item = try f.dependency(analysis, f.specifiers[1]);
    const selected = try h.records.types(&analysis, &.{ item, item, item });

    try h.accepted(&analysis, selected, &.{f.identities[1]});
}

test "a prior matching dependency cannot hide a later missing native key" {
    try failedSequence(&.{ 0, 1 }, 1);
}

test "a later valid dependency cannot rescue an earlier missing native key" {
    try failedSequence(&.{ 0, 1 }, 0);
}

test "valid dependencies on both sides cannot hide a missing middle native key" {
    try failedSequence(&.{ 0, 1, 2 }, 1);
}

test "source targets do not require their keys to match native modules" {
    try ignored(.{ .source = "/project/types.zx" });
}

test "external targets do not require their keys to match native modules" {
    try ignored(.external);
}

test "source helper remaps a later global native provider to local module zero" {
    for (f.orders) |order| {
        var analysis = try f.analyze(order, true);

        defer analysis.deinit();

        const selected = try f.index(analysis, "/project/helper.zx");

        try h.accepted(&analysis, selected, &.{f.identities[2]});
    }
}

test "interleaved repeated native dependencies retain first inclusion order" {
    var analysis = try f.analyze(f.orders[0], true);

    defer analysis.deinit();

    const imports = [_]f.Import{ try f.dependency(analysis, f.specifiers[2]), try f.dependency(analysis, f.specifiers[0]), try f.dependency(analysis, f.specifiers[2]), try f.dependency(analysis, f.specifiers[1]) };
    const selected = try h.records.types(&analysis, &imports);
    var result = try f.artifact.extract(std.testing.allocator, &analysis, selected);

    defer result.deinit();

    try h.module(analysis, selected, result.value, &f.identities);

    for ([_][]const u8{ f.identities[2], f.identities[0], f.identities[1] }, 0..) |key, position| {
        try std.testing.expectEqualStrings(key, result.value.native_modules.at(position).key());
    }
}
