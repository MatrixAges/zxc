const std = @import("std");
const allocation_testing = @import("allocation_testing");
const graph = @import("graph_fixture.zig");
const allocator = std.testing.allocator;

test "backend diagnostic depth accepts limit and rejects next level" {
    for ([_]usize{ 256, 257 }) |depth| {
        const extra = try graph.chain(allocator, depth, 1);

        defer allocator.free(extra);

        try graph.check(allocator, extra, if (depth == 256) null else error.BackendDiagnosticsTooComplex);
    }
}

test "backend shared DAG counts expanded nodes rather than unique records" {
    for ([_]usize{ 20, 21 }) |depth| {
        const extra = try graph.chain(allocator, depth, 2);

        defer allocator.free(extra);

        try graph.check(allocator, extra, if (depth == 20) null else error.BackendDiagnosticsTooComplex);
    }
}

test "backend multiple roots accept exact expansion limit and reject next node" {
    const original = try graph.chain(allocator, 20, 2);

    defer allocator.free(original);

    var extra: std.ArrayList(u32) = .empty;

    defer extra.deinit(allocator);

    try extra.appendSlice(allocator, original);

    const roots: u32 = @intCast(extra.items.len);
    const leaf: u32 = 4 + 19 * 6;

    try extra.appendSlice(allocator, &.{ 4, leaf, leaf });

    extra.items[0] = 2;
    extra.items[1] = roots;

    try graph.check(allocator, extra.items, null);

    extra.items[0] = 3;

    try graph.check(allocator, extra.items, error.BackendDiagnosticsTooComplex);
}

test "backend diagnostic self reference is rejected" {
    const extra = try graph.chain(allocator, 1, 1);

    defer allocator.free(extra);

    extra[7] = 1;
    extra[8] = 4;

    try graph.check(allocator, extra, error.InvalidBackendProtocol);
}

test "backend diagnostic indirect cycle is rejected" {
    const extra = try graph.chain(allocator, 3, 1);

    defer allocator.free(extra);

    extra[19] = 1;
    extra[20] = 4;

    try graph.check(allocator, extra, error.InvalidBackendProtocol);
}

test "backend repeated roots may share completed diagnostic records" {
    try graph.check(allocator, &.{ 2, 3, 0, 5, 5, 1, 1, 0, 0 }, null);
}

test "backend source location without traces is accepted" {
    try graph.check(allocator, &.{ 1, 3, 0, 4, 1, 1, 8, 0, 1, 0, 0, 0, 0, 0, 0, 0 }, null);
}

test "backend source trace cycle is rejected" {
    try graph.check(allocator, &.{ 1, 3, 0, 4, 1, 1, 8, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 8 }, error.InvalidBackendProtocol);
}

test "backend shared graph releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(allocator, checkResources, .{});
}

fn checkResources(gpa: std.mem.Allocator) !void {
    const extra = try graph.chain(allocator, 12, 2);

    defer allocator.free(extra);

    try graph.check(gpa, extra, null);
}
