const std = @import("std");
const compiler = @import("compiler");
const h = @import("check.zig");

test "same named source enums keep distinct declaration identities" {
    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import helper from \"./helper.zx\"\n " ++ h.declaration ++ " " ++ h.identity },
        .{ .path = "helper.zx", .source = h.declaration ++ " " ++ h.identity },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try h.check(result, 2);
    try std.testing.expectEqualStrings("/project/helper.zx", result.nominal_types[0].origin.source);
    try std.testing.expectEqualStrings("/project/main.zx", result.nominal_types[1].origin.source);
}

test "shared source declaration is recorded once through repeated imports" {
    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import helper from \"./helper.zx\"\n import { Mode } from \"./shared.zx\"\n " ++ h.identity },
        .{ .path = "helper.zx", .source = "import { Mode } from \"./shared.zx\"\n " ++ h.identity },
        .{ .path = "shared.zx", .source = h.declaration },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try h.check(result, 1);
    try std.testing.expectEqualStrings("/project/shared.zx", result.nominal_types[0].origin.source);
}

test "same native specifier reuses enum identity across source modules" {
    var result = try h.native(std.testing.allocator, false);

    defer result.deinit();

    try h.check(result, 1);
    try std.testing.expectEqualStrings("zig:first", result.nominal_types[0].origin.native);
    try std.testing.expectEqual(@as(usize, 2), result.modules.len);
    try std.testing.expect(result.modules[0].imports[0].target == .native);
    try std.testing.expect(result.modules[1].imports[0].target == .source);
    try std.testing.expect(result.modules[1].imports[1].target == .native);
    try std.testing.expectEqualStrings("zig:first", result.modules[1].imports[1].specifier);
}

test "different native specifiers do not merge same shaped enums" {
    var result = try h.native(std.testing.allocator, true);

    defer result.deinit();

    try h.check(result, 2);
    try std.testing.expectEqualStrings("zig:second", result.nominal_types[0].origin.native);
    try std.testing.expectEqualStrings("zig:first", result.nominal_types[1].origin.native);
}

test "legacy default bindings share the exported enum identity" {
    var result = try h.legacy(std.testing.allocator, false);

    defer result.deinit();

    try h.check(result, 1);
    try std.testing.expectEqualStrings("lib:sample", result.nominal_types[0].origin.external.module);
    try std.testing.expectEqualStrings("first", result.nominal_types[0].origin.external.member);

    for (result.modules[0].imports) |dependency| {
        try std.testing.expect(dependency.target == .external);
        try std.testing.expectEqualStrings("lib:sample", dependency.specifier);
    }
}

test "legacy named members share identity across bindings and remain distinct exports" {
    var result = try h.legacy(std.testing.allocator, true);

    defer result.deinit();

    try h.check(result, 2);

    for (result.nominal_types, 0..) |item, index| {
        try std.testing.expectEqualStrings("lib:sample", item.origin.external.module);
        try std.testing.expectEqualStrings(if (index == 0) "first" else "second", item.origin.external.member);
    }
}

test "context seeded enum is not attributed to the consuming module" {
    var provider = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "provider.zx", .source = h.declaration }}, .{ .entry = "provider.zx", .root_dir = "/project" });

    defer provider.deinit();

    try h.check(provider, 1);

    var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = h.identity }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .context = .{ .types = provider.value.ir.types },
    });

    defer result.deinit();

    try h.check(result, 0);
    try std.testing.expect(result.value.ir.types[@intFromEnum(provider.nominal_types[0].type_id)] == .enumeration);
}

test "legacy imports in different source modules share the exported enum identity" {
    const signature = h.declaration ++ " export type Input = Mode\n export type Output = Mode\n";
    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import helper from \"./helper.zx\"\n import alpha from \"lib:sample\"\n " ++ h.identity },
        .{ .path = "helper.zx", .source = "import alpha from \"lib:sample\"\n " ++ h.identity },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .externals = &.{.{ .specifier = "lib:sample", .signature = signature, .implementation = .{ .module = "sample", .member = "echo" } }},
    });

    defer result.deinit();

    try h.check(result, 1);
    try std.testing.expectEqualStrings("lib:sample", result.nominal_types[0].origin.external.module);
    try std.testing.expectEqualStrings("echo", result.nominal_types[0].origin.external.member);
}

test "native origin owns provider specifier after mutation and release" {
    var result = blk: {
        var provider = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer provider.deinit();

        const specifier = try provider.allocator().dupe(u8, "zig:sample");
        var analyzed = try compiler.project.analyze(std.testing.allocator, &.{.{
            .path = "main.zx",
            .source = "import { Mode } from \"zig:sample\"\n " ++ h.identity,
        }}, .{
            .entry = "main.zx",
            .root_dir = "/project",
            .native_interfaces = &.{.{ .specifier = specifier, .path = "sample.d.zx", .source = h.declaration, .module = "sample" }},
        });

        errdefer analyzed.deinit();

        try h.check(analyzed, 1);
        @memset(specifier, 'x');

        break :blk analyzed;
    };

    defer result.deinit();

    try h.check(result, 1);
    try std.testing.expectEqualStrings("zig:sample", result.nominal_types[0].origin.native);
}

test "single legacy enum binding is a valid control for repeated imports" {
    const signature = h.declaration ++ " export type Input = Mode\n export type Output = Mode\n";
    var result = try compiler.project.analyze(std.testing.allocator, &.{.{
        .path = "main.zx",
        .source = "import alpha from \"lib:sample\"\n " ++ h.identity,
    }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .externals = &.{.{ .specifier = "lib:sample", .signature = signature, .implementation = .{ .module = "sample", .member = "echo" } }},
    });

    defer result.deinit();

    try h.check(result, 1);
    try std.testing.expectEqualStrings("lib:sample", result.nominal_types[0].origin.external.module);
    try std.testing.expectEqualStrings("echo", result.nominal_types[0].origin.external.member);
}
