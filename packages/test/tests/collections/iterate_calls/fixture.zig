const std = @import("std");
const compiler = @import("compiler");

pub fn analyze(allocator: std.mem.Allocator, mode: []const u8) !compiler.AnalysisResult {
    const source = inline for (.{ "identity", "child", "pair", "branch_return", "tuple_identity", "list_alias" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ "_main.zx");
    } else return error.InvalidMode;

    return compiler.analyzeProject(allocator, &.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "types.zx", .source = @embedFile("fixtures/types.zx") },
        .{ .path = "identity.zx", .source = @embedFile("fixtures/identity.zx") },
        .{ .path = "child.zx", .source = @embedFile("fixtures/child.zx") },
        .{ .path = "pair.zx", .source = @embedFile("fixtures/pair.zx") },
        .{ .path = "branch.zx", .source = @embedFile("fixtures/branch.zx") },
        .{ .path = "tuple_identity.zx", .source = @embedFile("fixtures/tuple_identity.zx") },
        .{ .path = "list_child.zx", .source = @embedFile("fixtures/list_child.zx") },
    }, .{ .entry = "main.zx", .root_dir = "/project" });
}
