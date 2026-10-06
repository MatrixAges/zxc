const std = @import("std");
const compiler = @import("compiler");
const Result = @import("../mixed/analyze.zig").Result;

pub fn analyze(allocator: std.mem.Allocator) !Result {
    return .{
        .analysis = try compiler.project.analyze(allocator, &.{
            .{ .path = "main.zx", .source = @embedFile("main.zx") },
            .{ .path = "helper.zx", .source = @embedFile("helper.zx") },
        }, .{ .entry = "main.zx", .root_dir = "/project", .native_interfaces = &.{.{ .specifier = "zig:choice", .path = "choice.d.zx", .source = @embedFile("choice.d.zx"), .module = "choice" }} }),
        .context_digest = try compiler.project.SemanticCache.contextDigest(allocator, .{}),
    };
}
