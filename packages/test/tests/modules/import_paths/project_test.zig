const std = @import("std");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "normalized relative and root imports share one module function and cache entry" {
    const source = "import third from \"@/app/helper\"\n\nimport first from \"./helper\"\nimport second from \"./nested/../helper\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return first(second(third(in)))\n}\n";
    var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

    defer cache.deinit();

    var result = try compiler.project.analyzeWithCache(std.testing.allocator, &.{
        .{ .path = "app/main.zx", .source = source },
        .{ .path = "app/helper.zx", .source = f.helper },
    }, .{ .entry = "app/main.zx", .root_dir = "/project" }, &cache);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(@as(usize, 2), result.modules.len);
    try std.testing.expectEqual(@as(usize, 1), result.value.ir.functions.count());
    try std.testing.expectEqual(@as(usize, 2), cache.parsed);
    try std.testing.expectEqualStrings("/project/app/helper.zx", result.modules[0].path);
    try std.testing.expectEqual(@as(usize, 3), result.modules[1].imports.len);

    for ([_][]const u8{ "@/app/helper", "./helper", "./nested/../helper" }, result.modules[1].imports) |specifier, dependency| {
        try std.testing.expectEqualStrings(specifier, dependency.specifier);
        try std.testing.expect(dependency.target == .source);
        try std.testing.expectEqualStrings("/project/app/helper.zx", dependency.target.source);
    }
}

test "type and enum imports share nominal identity across normalized paths" {
    const shared = "export enum Mode { First, Second }\n\nexport type Count = u64\n";
    const helper = "import { Mode } from \"../types/./shared\"\n\nimport type { Count } from \"../types/shared\"\n\nexport type Input = { value: Count, mode: Mode }\n\nexport type Output = Mode\n\nexport default function (in: Input): Output {\n  return in.mode\n}\n";
    const main = "import { Mode } from \"../types/./shared\"\nimport helper from \"./helper\"\n\nimport type { Count } from \"../types/shared\"\n\nexport type Input = { value: Count, mode: Mode }\n\nexport type Output = Mode\n\nexport default function (in: Input): Output {\n  return helper(in)\n}\n";

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "app/main.zx", .source = main },
        .{ .path = "app/helper.zx", .source = helper },
        .{ .path = "types/shared.zx", .source = shared },
    }, .{ .entry = "app/main.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(@as(usize, 3), result.modules.len);
    try std.testing.expectEqualStrings("/project/types/shared.zx", result.modules[0].path);
    try std.testing.expectEqual(@as(usize, 2), result.modules[0].exports.len);

    var enum_count: usize = 0;

    for (0..result.value.ir.types.count()) |type_index| {
        const value = result.value.ir.types.at(type_index);

        if (value == .enumeration) enum_count += 1;
    }

    try std.testing.expectEqual(@as(usize, 1), enum_count);
}

test "extensionless root alias uses the importing package root" {
    const scopes = [_]compiler.project.PackageScope{
        .{ .root = "/workspace/a", .packages = &.{} },
        .{ .root = "/workspace/b", .packages = &.{} },
    };

    for ([_][]const u8{ "a", "b" }) |owner| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const entry = try std.fmt.allocPrint(arena.allocator(), "/workspace/{s}/main.zx", .{owner});
        const helper_path = try std.fmt.allocPrint(arena.allocator(), "/workspace/{s}/helper.zx", .{owner});
        const main = try f.main(arena.allocator(), "@/helper");

        var result = try compiler.project.analyze(std.testing.allocator, &.{
            .{ .path = "/workspace/a/main.zx", .source = main },
            .{ .path = "/workspace/b/main.zx", .source = main },
            .{ .path = "/workspace/a/helper.zx", .source = f.helper },
            .{ .path = "/workspace/b/helper.zx", .source = f.identity },
        }, .{ .entry = entry, .root_dir = "/workspace", .package_scopes = &scopes });

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try std.testing.expectEqual(@as(usize, 2), result.modules.len);
        try std.testing.expectEqualStrings(helper_path, result.modules[0].path);
        try std.testing.expectEqualStrings(helper_path, result.modules[1].imports[0].target.source);
    }
}

test "extensionless parent traversal cannot cross package boundaries" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const source = try f.main(arena.allocator(), "../b/helper");

    const scopes = [_]compiler.project.PackageScope{
        .{ .root = "/workspace/a", .packages = &.{} },
        .{ .root = "/workspace/b", .packages = &.{} },
    };

    try f.expectFailure(&.{
        .{ .path = "/workspace/a/main.zx", .source = source },
        .{ .path = "/workspace/b/helper.zx", .source = f.helper },
    }, .{ .entry = "/workspace/a/main.zx", .root_dir = "/workspace", .package_scopes = &scopes }, "file import crosses a package boundary; declare and import the package dependency");
}

test "extensionless imports do not fall back to directory index modules" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const source = try f.main(arena.allocator(), "./helper");

    try f.expectFailure(&.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "helper/index.zx", .source = f.helper },
    }, .{ .entry = "main.zx", .root_dir = "/project" }, "import target is missing from the source set");
}

test "normalized extensionless paths cannot hide cycles through unused imports" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const main = try f.main(arena.allocator(), "./helper");
    const helper = try f.main(arena.allocator(), "@/main");

    try f.expectFailure(&.{
        .{ .path = "main.zx", .source = main },
        .{ .path = "helper.zx", .source = helper },
    }, .{ .entry = "main.zx", .root_dir = "/project" }, "ZX module imports must be acyclic, including unused imports");
}

test "explicit ZX suffixes are rejected for existing function type and enum modules" {
    const sources = [_][]const u8{
        "import helper from \"./helper.zx\"\n\n" ++ f.identity,
        "import type { Count } from \"./helper.zx\"\n\n" ++ f.identity,
        "import { Mode } from \"./helper.zx\"\n\n" ++ f.identity,
    };

    const target = "export enum Mode { First, Second }\n\nexport type Count = u64\n\n" ++ f.helper;

    for (sources) |source| {
        try f.expectFailure(&.{
            .{ .path = "main.zx", .source = source },
            .{ .path = "helper.zx", .source = target },
        }, .{ .entry = "main.zx", .root_dir = "/project" }, "project imports must omit the .zx extension; runtime and RX imports are forbidden");
    }
}
