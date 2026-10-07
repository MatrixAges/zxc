const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const Fixture = @import("fixture.zig").Fixture;
const Mode = enum { valid, missing, cycle, interface };

test "successful link cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Mode.valid});
}

test "missing dependency cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Mode.missing});
}

test "cyclic dependency cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Mode.cycle});
}

test "conflicting interface cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Mode.interface});
}

fn run(allocator: std.mem.Allocator, mode: Mode) !void {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    var dependency = fixture.modules[1].dependencies[0];
    var modules: []const compiler.project.artifact.Module = &fixture.modules;

    switch (mode) {
        .valid => {},
        .missing => modules = modules[1..],
        .cycle => {
            dependency.target = .{ .source = fixture.modules[3].path };
            fixture.modules[0].dependencies = (&dependency)[0..1];
        },
        .interface => fixture.modules[0].exports = &.{},
    }

    var result = compiler.project.artifact.linker.link(allocator, modules, "/project/main.zx") catch |err| {
        if (err == error.OutOfMemory) return err;

        const expected: anyerror = switch (mode) {
            .valid => return err,
            .missing => error.MissingModule,
            .cycle => error.CyclicDependency,
            .interface => error.ConflictingInterface,
        };

        try std.testing.expectEqual(expected, err);

        return;
    };

    defer result.deinit();

    try std.testing.expectEqual(Mode.valid, mode);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.program) == null);
    try std.testing.expectEqual(@as(usize, 2), result.program.functions.count());
}
