const std = @import("std");
pub const f = @import("fixture.zig");

pub fn replace(analysis: *f.compiler.AnalysisResult, selected: usize, imports: []const f.Import) !void {
    const memory = analysis.arena.allocator();
    const records = try memory.dupe(f.Record, analysis.modules);
    records[selected].imports = try memory.dupe(f.Import, imports);
    analysis.modules = records;
}

pub fn types(analysis: *f.compiler.AnalysisResult, imports: []const f.Import) !usize {
    const selected = try f.index(analysis.*, "/project/types.zx");

    try std.testing.expect(analysis.modules[selected].body == .types);
    try std.testing.expectEqual(@as(usize, 0), analysis.modules[selected].function_imports.len);
    try std.testing.expectEqual(@as(usize, 0), analysis.modules[selected].type_imports.len);
    try replace(analysis, selected, imports);

    return selected;
}
