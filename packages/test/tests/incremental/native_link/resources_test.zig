const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

test "native relink cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "native ABI conflict cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

fn run(allocator: std.mem.Allocator, conflict: bool) !void {
    var fixture = try f.Fixture.init();

    defer fixture.deinit();

    var native = fixture.modules[1].native_modules[0];

    if (conflict) {
        native.type_namespace = &.{"Other"};
        fixture.modules[1].native_modules = (&native)[0..1];
    }

    var result = f.artifact.linker.link(allocator, &fixture.modules, "/project/main.zx") catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expect(conflict);
        try std.testing.expectEqual(error.ConflictingInterface, err);

        return;
    };

    defer result.deinit();

    try std.testing.expect(!conflict);
    try f.check(result);
}
