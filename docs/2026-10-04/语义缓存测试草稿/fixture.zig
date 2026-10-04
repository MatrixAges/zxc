const std = @import("std");
pub const compiler = @import("compiler");
pub const source = @import("parse_fixture");
pub const Cache = compiler.project.SemanticCache;
pub const incompatible = "export type Input = bool; export type Output = bool; export default function (in: Input): Output { return in; }";

pub fn run(allocator: std.mem.Allocator, cache: *Cache, helper: []const u8) !compiler.AnalysisResult {
    return compiler.project.analyzeIncremental(allocator, &.{
        .{ .path = "main.zx", .source = source.main },
        .{ .path = "helper.zx", .source = helper },
    }, .{ .entry = "main.zx", .root_dir = "/project" }, cache);
}

pub fn check(result: compiler.AnalysisResult, increment: u64) !void {
    try source.check(result);
    try source.increment(result, increment);
}
