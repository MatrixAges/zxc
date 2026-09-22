const std = @import("std");
const rx = @import("rx");
const h = @import("helpers.zig");

test "all 512 directed graphs on three modules obey the DAG contract" {
    for (0..512) |edges| {
        var children: [3][3]rx.ast.Node = undefined;
        var sources: [3]rx.ModuleSource = undefined;

        inline for (.{ "a.rx", "b.rx", "c.rx" }, 0..) |path, owner| {
            var count: usize = 0;

            inline for (.{ "a", "b", "c" }, 0..) |target, index| {
                if (hasEdge(edges, owner, index)) {
                    children[owner][count] = h.node("Call", .{ .service = target, .in = "$in" }, &.{});
                    count += 1;
                }
            }

            sources[owner] = .{ .path = path, .node = h.module(children[owner][0..count]) };
        }

        var result = try rx.validateModules(std.testing.allocator, &sources);

        defer result.deinit();
        errdefer std.debug.print("Dependency graph edge mask: {d}\n", .{edges});

        try std.testing.expectEqual(isAcyclic(edges), result.value == .data);

        if (result.value == .diagnostic) {
            try std.testing.expectEqualStrings("service", result.value.diagnostic.issue.attribute.?);
        }
    }
}

test "conditional calls and imports cannot hide circular dependencies" {
    const sources = [_]rx.ModuleSource{
        .{ .path = "a.rx", .node = h.module(&.{h.node("Import", .{ .from = "b" }, &.{})}) },
        .{ .path = "b.rx", .node = h.module(&.{h.node("Switch", .{ .on = "$in.mode" }, &.{
            h.node("Case", .{ .value = "rare" }, &.{h.node("Call", .{ .service = "a", .in = "$in" }, &.{})}),
        })}) },
    };

    var result = try rx.validateModules(std.testing.allocator, &sources);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(@as(usize, 1), result.value.diagnostic.source_index);
    try std.testing.expectEqualStrings("service", result.value.diagnostic.issue.attribute.?);
    try std.testing.expectEqualDeep(h.value_location, result.value.diagnostic.issue.location);
}

fn hasEdge(edges: usize, from: usize, to: usize) bool {
    const shift: std.math.Log2Int(usize) = @intCast(from * 3 + to);

    return edges & (@as(usize, 1) << shift) != 0;
}

fn isAcyclic(edges: usize) bool {
    var indegree = [_]usize{0} ** 3;
    var removed = [_]bool{false} ** 3;

    for (0..3) |from| {
        for (0..3) |to| {
            if (hasEdge(edges, from, to)) indegree[to] += 1;
        }
    }

    for (0..3) |_| {
        const next = for (0..3) |index| {
            if (!removed[index] and indegree[index] == 0) break index;
        } else return false;

        removed[next] = true;

        for (0..3) |target| {
            if (hasEdge(edges, next, target)) indegree[target] -= 1;
        }
    }

    return true;
}
