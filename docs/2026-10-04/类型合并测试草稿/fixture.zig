const std = @import("std");
const compiler = @import("compiler");
pub const artifact = compiler.project.artifact;
pub const declaration = "export enum Mode { First, Second } export type Maybe = Mode?; export type Items = Mode[]; export type Pair = [Mode, u64]; export type Record = { mode: Mode; count: u64; };";
pub const structural = "export type Maybe = u64?; export type Items = u64[]; export type Pair = [u64, string]; export type Record = { count: u64; name: string; };";

pub fn extract(path: []const u8, source: []const u8) !artifact.Result {
    var analysis = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = path, .source = source }}, .{ .entry = path, .root_dir = "/project" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);

    return artifact.extract(std.testing.allocator, &analysis, 0);
}

pub fn exportIndex(module: artifact.Module, name: []const u8) !usize {
    for (module.exports) |item| {
        if (std.mem.eql(u8, item.name, name)) return @intFromEnum(item.type_id);
    }

    return error.MissingExport;
}
