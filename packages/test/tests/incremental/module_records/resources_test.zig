const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "module records success cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "partial module loading failure returns no records or nominal origins" {
    try run(std.testing.allocator, true);
}

test "partial module loading failure cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

fn run(allocator: std.mem.Allocator, missing: bool) !void {
    const prefix = "import helper from \"./helper\"\nimport absent from \"./absent\"\n";
    var sources = f.sources;

    if (missing) sources[0].source = prefix ++ f.unused;

    var result = try compiler.project.analyze(allocator, &sources, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    if (missing) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.module, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expectEqual(@as(usize, 0), result.modules.len);
        try std.testing.expectEqual(@as(usize, 0), result.nominal_types.len);
    } else {
        try f.check(result);
    }
}
