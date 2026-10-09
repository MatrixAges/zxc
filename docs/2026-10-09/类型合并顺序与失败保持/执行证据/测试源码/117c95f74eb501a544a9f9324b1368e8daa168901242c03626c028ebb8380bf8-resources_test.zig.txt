const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const f = @import("record_fixture");

test "entry artifact extraction cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as(usize, 3)});
}

test "type artifact extraction cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as(usize, 0)});
}

fn run(allocator: std.mem.Allocator, index: usize) !void {
    var analysis = try f.analyze(allocator);

    defer analysis.deinit();

    var result = try compiler.project.artifact.extract(allocator, &analysis, index);

    defer result.deinit();

    try std.testing.expectEqualStrings(analysis.modules[index].path, result.value.path);
}
