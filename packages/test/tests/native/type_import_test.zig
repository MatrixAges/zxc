const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const source = "import type { Value } from \"zig:sample\"\n\nexport type Input = Value\n\nexport type Output = Value\n\nexport default function (in: Input): Output {\n  return in\n}\n";

fn check(allocator: std.mem.Allocator, namespace: []const []const u8, rejected: bool) !void {
    var result = try compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = "export type Value = u64\n", .module = "sample", .namespace = namespace }},
    });

    defer result.deinit();

    if (rejected) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.module, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expect(std.mem.indexOf(u8, result.value.diagnostic.message, "native namespaces require nonempty UTF-8 member names") != null);
    } else {
        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
    }
}

test "type-only native imports validate namespace metadata" {
    for ([_][]const u8{ "", "bad\x00name", "bad\xffname" }) |name| {
        try check(std.testing.allocator, &.{name}, true);
    }

    try check(std.testing.allocator, &.{}, false);
    try check(std.testing.allocator, &.{ "nested", "api" }, false);
}

test "type-only native imports clean allocations on rejection" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as([]const []const u8, &.{""}), true });
}
