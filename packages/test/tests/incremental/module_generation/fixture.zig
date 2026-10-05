const std = @import("std");
pub const compiler = @import("compiler");
const source = @import("record_fixture");
pub const Bundle = compiler.zig.ModuleBundle;

pub fn analyze(allocator: std.mem.Allocator, changed: bool) !compiler.AnalysisResult {
    var sources = source.sources;

    if (changed) sources[3].source = "import type { Count } from \"./shared\"\n export type Input = Count\n export type Output = Count\n export default function (in: Input): Output { return in + 2 }";

    var result = try compiler.project.analyze(allocator, &sources, .{ .entry = "main.zx", .root_dir = "/project" });

    errdefer result.deinit();

    try source.check(result);

    return result;
}

pub fn same(left: Bundle, right: Bundle) !void {
    try std.testing.expectEqualStrings(left.types, right.types);
    try sameFile(left.entry, right.entry);
    try std.testing.expectEqual(left.modules.len, right.modules.len);
    for (left.modules, right.modules) |a, b| try sameFile(a, b);
}

pub fn sameFile(left: compiler.zig.ModuleFile, right: compiler.zig.ModuleFile) !void {
    try std.testing.expectEqualStrings(left.name, right.name);
    try std.testing.expectEqualStrings(left.source, right.source);
    try std.testing.expectEqual(left.imports.len, right.imports.len);
    for (left.imports, right.imports) |a, b| try std.testing.expectEqualStrings(a, b);
}
