const std = @import("std");
pub const compiler = @import("compiler");
pub const call = "import run from \"sample\"\nimport { Mode } from \"sample/types\"\nexport type Input = Mode\nexport type Output = Mode\nexport default function (in: Input): Output { return run(in) }\n";

pub fn library() !compiler.library.Result {
    const sources = [_]compiler.project.Source{
        .{ .path = "run.zx", .source = "import { Mode } from \"./types\"\nexport type Input = Mode\nexport type Output = Mode\nexport default function (in: Input): Output { return in }\n" },
        .{ .path = "types.zx", .source = "export enum Mode { First, Second }\n" },
    };

    var run = try compiler.project.analyze(std.testing.allocator, &sources, .{ .entry = "run.zx", .root_dir = "/library" });

    defer run.deinit();

    var types = try compiler.project.analyze(std.testing.allocator, &sources, .{ .entry = "types.zx", .root_dir = "/library" });

    defer types.deinit();

    try std.testing.expect(run.value == .ir and types.value == .ir);

    return compiler.library.link(std.testing.allocator, &.{ .{ .name = "call", .analysis = &run }, .{ .name = "types", .analysis = &types } });
}

pub fn dependency(value: *const compiler.library.Result) compiler.project.compiled.Library {
    return .{ .instance = "sample@1", .artifact = "sample.zxlib", .program = value.program, .exports = value.exports, .nominal_types = value.nominal_types };
}

pub fn package(specifier: []const u8, name: []const u8) compiler.project.Package {
    return .{ .specifier = specifier, .compiled = .{ .instance = "sample@1", .artifact = "sample.zxlib", .name = name } };
}

pub fn analyze(source: []const u8, packages: []const compiler.project.Package, libraries: []const compiler.project.compiled.Library) !compiler.AnalysisResult {
    return compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = packages,
        .compiled_libraries = libraries,
    });
}

pub fn reject(packages: []const compiler.project.Package, libraries: []const compiler.project.compiled.Library, message: []const u8) !void {
    var result = try analyze(call, packages, libraries);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.module, result.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
    try std.testing.expectEqualStrings(message, result.value.diagnostic.message);
}
