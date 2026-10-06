const std = @import("std");
const compiler = @import("compiler");
const allocations = @import("../support/allocation_testing.zig");
const f = @import("fixture.zig");
const Route = enum { compile, format, compile_project };

fn check(allocator: std.mem.Allocator, route: Route) !void {
    const output = blk: {
        var caller = std.heap.ArenaAllocator.init(allocator);

        defer caller.deinit();

        const source = try caller.allocator().dupe(u8, f.source);
        const path = try caller.allocator().dupe(u8, "main.zx");

        const result = switch (route) {
            .compile => try compiler.compile(allocator, source, path),
            .format => try compiler.format(allocator, source, path),
            .compile_project => try compiler.compileProject(allocator, &.{.{ .path = path, .source = source }}, f.options),
        };

        @memset(source, 'x');
        @memset(path, 'x');

        break :blk result;
    };

    defer output.deinit(allocator);

    try std.testing.expect(output == .diagnostic);
    try f.check(output.diagnostic, if (route == .compile_project) 0 else null);
}

test "compile parse diagnostic owns text after internal and caller arenas end" {
    try check(std.testing.allocator, .compile);
}

test "ZX format syntax diagnostic owns text after internal and caller arenas end" {
    try check(std.testing.allocator, .format);
}

test "compileProject clones a still valid project syntax diagnostic" {
    try check(std.testing.allocator, .compile_project);
}

test "compile and format syntax diagnostics release every failed allocation" {
    for (std.enums.values(Route)) |route| {
        try allocations.checkAllAllocationFailures(std.testing.allocator, check, .{route});
    }
}
