const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
pub const artifact = compiler.project.artifact;

pub const orderings = [_][3][]const u8{
    .{ "noise", "first", "second" }, .{ "first", "second", "noise" }, .{ "second", "noise", "first" },
    .{ "noise", "second", "first" }, .{ "first", "noise", "second" }, .{ "second", "first", "noise" },
};

pub fn analyze(allocator: std.mem.Allocator, ordering: [3][]const u8, alias: bool) !compiler.AnalysisResult {
    var source: std.Io.Writer.Allocating = .init(allocator);

    defer source.deinit();

    for (ordering) |name| try source.writer.print("import {s} from \"./{s}\"\n", .{ name, name });
    if (alias) try source.writer.writeAll("import twin from \"./first\"\n");
    try source.writer.writeAll("\nexport type Input = { value: u64 }\n\nexport type Output = { value: u64 }\n\nexport default function (in: Input): Output {\n");
    try source.writer.writeAll(if (alias) "    return first(twin(in))\n}\n" else "    return first(in)\n}\n");

    var result = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = source.written() },
        .{ .path = "first.zx", .source = @embedFile("fixtures/first.zx") },
        .{ .path = "second.zx", .source = @embedFile("fixtures/second.zx") },
        .{ .path = "noise.zx", .source = @embedFile("fixtures/noise.zx") },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("import fixture diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try compiler.validateIr(allocator, result.value.ir));
    try std.testing.expectEqual(@as(usize, 4), result.modules.len);

    return result;
}

pub fn entry(analysis: compiler.AnalysisResult) !usize {
    for (analysis.modules, 0..) |record, index| {
        if (std.mem.eql(u8, record.path, "/project/main.zx")) return index;
    }

    return error.MissingFixtureEntry;
}

pub fn local(module: artifact.Module, name: []const u8) !ir.FunctionId {
    for (module.function_imports) |item| {
        if (std.mem.eql(u8, item.name, name)) return item.id;
    }

    return error.MissingFixtureImport;
}
