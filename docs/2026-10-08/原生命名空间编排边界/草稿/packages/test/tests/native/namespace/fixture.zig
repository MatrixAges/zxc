const std = @import("std");
pub const compiler = @import("compiler");
pub const Code = @FieldType(compiler.Diagnostic, "code");
pub const valid = "export type Value = u64\n\nexport declare function apply(input: Value): Value\n";
pub const message = "native namespaces require nonempty UTF-8 member names";
pub const Case = struct { namespace: []const []const u8 = &.{}, declaration: []const u8 = valid, type_only: bool = false, expected: ?Code = null };

pub fn analyze(allocator: std.mem.Allocator, case: Case) !compiler.AnalysisResult {
    const source = if (case.type_only)
        "import type { Value } from \"zig:sample\"\n\nexport type Input = Value\n\nexport type Output = Value\n\nexport default function (in: Input): Output {\n  return in\n}\n"

    else
        "import native from \"zig:sample\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return native.apply(in)\n}\n";

    return compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = case.declaration, .module = "sample", .namespace = case.namespace }},
    });
}

pub fn inspect(allocator: std.mem.Allocator, program: compiler.ir.Program, namespace: []const []const u8) !void {
    try std.testing.expect(try compiler.validateIr(allocator, program) == null);
    try std.testing.expectEqual(@as(usize, 1), program.functions.count());

    const function = program.functions.at(0);
    const external = function.external.?;

    try std.testing.expectEqual(namespace.len + 1, external.member.len);
    for (namespace, external.member[0..namespace.len]) |expected, actual| try std.testing.expectEqualStrings(expected, actual);
    try std.testing.expectEqualStrings("apply", external.member[namespace.len]);
    try std.testing.expectEqual(.u64, program.typeOf(function.input_type).scalar);
    try std.testing.expectEqual(.u64, program.typeOf(function.output_type).scalar);
    try std.testing.expectEqual(@as(usize, 1), external.input.?.names.len);
    try std.testing.expectEqualStrings("Value", external.input.?.names[0].?);

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);
}

pub fn check(allocator: std.mem.Allocator, case: Case) !void {
    var result = try analyze(allocator, case);

    defer result.deinit();

    if (case.expected) |code| {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(code, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expect(std.mem.startsWith(u8, result.value.diagnostic.message, "sample.d.zx:"));
        if (code == .module) try std.testing.expect(std.mem.endsWith(u8, result.value.diagnostic.message, message));

        return;
    }

    if (result.value == .diagnostic) std.debug.print("namespace diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);

    if (case.type_only) {
        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
    } else try inspect(allocator, result.value.ir, case.namespace);
}

pub fn invalid(bytes: []const u8) !void {
    for (0..3) |position| {
        var parts: [3][]const u8 = .{ "outer", "middle", "inner" };
        parts[position] = bytes;

        try check(std.testing.allocator, .{ .namespace = &parts, .expected = .module });
        try check(std.testing.allocator, .{ .namespace = &parts, .type_only = true, .expected = .module });
    }
}
