const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");
const fixture = @import("fixture.zig");

fn valid(allocator: std.mem.Allocator) !void {
    var analysis = try fixture.analyze(allocator, "list_alias");

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);

    var library = try compiler.library.link(allocator, &.{.{ .name = "run", .analysis = &analysis }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();
    @memset(bytes, 0);

    const program = try decoded.module(0);

    try std.testing.expect(try compiler.validateIr(allocator, program) == null);

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.testing.expect(std.mem.indexOf(u8, bundle.source, "while (") != null);
}

test "loop scopes updates and borrowed calls release every compile archive allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, valid, .{});
}
