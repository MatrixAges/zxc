const std = @import("std");
const compiler = @import("compiler");

pub fn analyze(allocator: std.mem.Allocator, mode: []const u8) !compiler.AnalysisResult {
    const source = inline for (.{ "object", "tuple", "dual", "fresh", "modular" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ ".zx");
    } else return error.InvalidMode;

    return compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "model.zx", .source = @embedFile("fixtures/model.zx") },
        .{ .path = "append.zx", .source = @embedFile("fixtures/append.zx") },
        .{ .path = "fresh.zx", .source = @embedFile("fixtures/fresh.zx") },
    }, .{ .entry = "main.zx", .root_dir = "/project" });
}
