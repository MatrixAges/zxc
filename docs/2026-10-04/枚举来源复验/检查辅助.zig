const std = @import("std");
const compiler = @import("compiler");

pub const declaration = "export enum Mode { First, Second }";
pub const identity = "export type Input = u64; export type Output = u64; export default function (in: Input): Output { return in; }";

pub fn check(result: compiler.AnalysisResult, count: usize) !void {
    if (result.value == .diagnostic) std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(count, result.nominal_types.len);
    const issue = try compiler.validateIr(std.testing.allocator, result.value.ir);

    if (issue) |diagnostic| std.debug.print("{t}: {s}\n", .{ diagnostic.code, diagnostic.message });

    try std.testing.expect(issue == null);

    if (count != 0) {
        var enumerations: usize = 0;

        for (result.value.ir.types) |value| {
            if (value == .enumeration) enumerations += 1;
        }

        try std.testing.expectEqual(count, enumerations);
    }

    for (result.nominal_types, 0..) |item, index| {
        try std.testing.expectEqualStrings("Mode", item.name);
        const value = result.value.ir.types[@intFromEnum(item.type_id)];

        try std.testing.expect(value == .enumeration);
        try std.testing.expectEqualStrings("Mode", value.enumeration.name);
        try std.testing.expectEqualStrings("First", value.enumeration.members[0]);
        try std.testing.expectEqualStrings("Second", value.enumeration.members[1]);

        for (result.nominal_types[0..index]) |previous| try std.testing.expect(previous.type_id != item.type_id);
    }
}

pub fn native(allocator: std.mem.Allocator, different: bool) !compiler.AnalysisResult {
    const helper = if (different)
        "import { Mode } from \"zig:second\"; " ++ identity
    else
        "import { Mode } from \"zig:first\"; " ++ identity;

    return compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = "import helper from \"./helper.zx\"; import { Mode } from \"zig:first\"; " ++ identity },
        .{ .path = "helper.zx", .source = helper },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{
            .{ .specifier = "zig:first", .path = "first.d.zx", .source = declaration, .module = "first" },
            .{ .specifier = "zig:second", .path = "second.d.zx", .source = declaration, .module = "second" },
        },
    });
}

pub fn legacy(allocator: std.mem.Allocator, named: bool) !compiler.AnalysisResult {
    const signature = declaration ++ " export type Input = Mode; export type Output = Mode;";
    const entries = [_]compiler.project.External{
        .{ .specifier = "lib:sample", .export_name = if (named) "first" else null, .signature = signature, .implementation = .{ .module = "sample", .member = "first" } },
        .{ .specifier = "lib:sample", .export_name = "second", .signature = signature, .implementation = .{ .module = "sample", .member = "second" } },
    };

    return compiler.project.analyze(allocator, &.{.{
        .path = "main.zx",
        .source = "import alpha from \"lib:sample\"; import beta from \"lib:sample\"; " ++ identity,
    }}, .{ .entry = "main.zx", .root_dir = "/project", .externals = entries[0..@as(usize, if (named) 2 else 1)] });
}
