const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn owned(allocator: std.mem.Allocator, original: []const u8, expected: []const u8) !void {
    const source = try allocator.dupe(u8, original);

    const output = compiler.format(allocator, source, "imports.zx") catch |err| {
        allocator.free(source);

        return err;
    };

    allocator.free(source);
    defer output.deinit(allocator);

    try std.testing.expect(output == .source);
    try std.testing.expectEqualStrings(expected, output.source);

    const later = try compiler.format(allocator, f.body, "later.zx");

    defer later.deinit(allocator);

    try std.testing.expect(later == .source);
    try std.testing.expectEqualStrings(f.body, later.source);
    try std.testing.expectEqualStrings(expected, output.source);
}

fn invalid(allocator: std.mem.Allocator) !void {
    const source = try allocator.dupe(u8, "import broken from \"unterminated");

    const output = compiler.format(allocator, source, "imports.zx") catch |err| {
        allocator.free(source);

        return err;
    };

    allocator.free(source);
    defer output.deinit(allocator);

    try std.testing.expect(output == .diagnostic);
    try std.testing.expectEqual(.lexical, output.diagnostic.code);
    try std.testing.expect(output.diagnostic.message.len > 0);
}

test "sorted output owns its bytes after source release through every allocation failure" {
    const source = "import zeta from \"./zeta\" // zeta\nimport root from \"@/root\"\nimport alpha from \"./alpha\" /* alpha */\nimport type { Value } from \"./value\"\n\n" ++ f.body;
    const expected = "import root from \"@/root\"\n\nimport alpha from \"./alpha\" /* alpha */\nimport zeta from \"./zeta\" // zeta\n\nimport type { Value } from \"./value\"\n\n" ++ f.body;

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, owned, .{ source, expected });
}

test "lint and idempotent formatter release every failed allocation" {
    const source = "import zeta from \"./zeta\"\nimport alpha from \"./alpha\"\n\n" ++ f.body;
    const expected = "import alpha from \"./alpha\"\nimport zeta from \"./zeta\"\n\n" ++ f.body;

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, f.check, .{ source, expected });
}

test "invalid import diagnostics survive source release and clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, invalid, .{});
}
