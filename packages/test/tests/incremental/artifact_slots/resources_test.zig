const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const h = @import("check.zig");

test "entry capabilities artifact cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as(usize, 1)});
}

test "helper extraction with entry capabilities cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as(usize, 0)});
}

fn run(allocator: std.mem.Allocator, index: usize) !void {
    var analysis = try h.analyze(allocator);

    defer analysis.deinit();

    var result = try compiler.project.artifact.extract(allocator, &analysis, index);

    defer result.deinit();

    if (index == 1) try h.check(result.value) else {
        try std.testing.expectEqual(@as(usize, 0), result.value.stores.len);
    }
}
