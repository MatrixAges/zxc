const std = @import("std");
const compiler = @import("compiler");

pub fn analyze(allocator: std.mem.Allocator, mode: []const u8) !compiler.AnalysisResult {
    const text = inline for (.{ "fresh", "literal", "chain", "branch", "mixed", "borrowed", "shared", "impure" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ ".zx");
    } else return error.InvalidMode;

    return compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = text },
        .{ .path = "factory/fresh.zx", .source = @embedFile("fixtures/factory/fresh.zx") },
        .{ .path = "factory/literal.zx", .source = @embedFile("fixtures/factory/literal.zx") },
        .{ .path = "factory/chain.zx", .source = @embedFile("fixtures/factory/chain.zx") },
        .{ .path = "factory/branch.zx", .source = @embedFile("fixtures/factory/branch.zx") },
        .{ .path = "factory/mixed.zx", .source = @embedFile("fixtures/factory/mixed.zx") },
        .{ .path = "factory/borrowed.zx", .source = @embedFile("fixtures/factory/borrowed.zx") },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:origin", .path = "origin.d.zx", .source = @embedFile("fixtures/origin.d.zx"), .module = "origin_host" }},
    });
}
