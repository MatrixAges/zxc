const std = @import("std");
pub const compiler = @import("compiler");

pub const Expected = struct {
    name: []const u8,
    expanded: bool = false,
    allocating: bool = false,
    io: bool = false,
    process: bool = false,
    fallible: bool = false,
    concurrent: bool = false,
    errors: ?[]const []const u8 = null,
};

pub const Case = struct {
    declaration: []const u8,
    call: []const u8 = "host.apply(in)",
    input: []const u8 = "u64",
    path: []const u8 = "host.d.zx",
    namespace: []const []const u8 = &.{ "outer", "api" },
    members: []const Expected,
};

pub fn analyze(allocator: std.mem.Allocator, case: Case) !compiler.AnalysisResult {
    const source = try std.fmt.allocPrint(allocator, "import host from \"zig:host\"\n\nexport type Input = {s}\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{\n  return {s}\n}}\n", .{ case.input, case.call });

    defer allocator.free(source);

    return compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = case.path, .source = case.declaration, .module = "host", .namespace = case.namespace }},
    });
}

pub fn inspect(allocator: std.mem.Allocator, program: compiler.ir.Program, case: Case) !void {
    try std.testing.expect(try compiler.validateIr(allocator, program) == null);
    try std.testing.expectEqual(case.members.len, program.functions.count());

    for (case.members, 0..) |expected, index| {
        const function = program.functions.at(index);
        const external = function.external.?;

        try std.testing.expectEqualStrings(case.path, function.file_name);
        try std.testing.expectEqualStrings(expected.name, external.export_name.?);
        try std.testing.expectEqual(case.namespace.len + 1, external.member.len);
        for (case.namespace, external.member[0..case.namespace.len]) |part, actual| try std.testing.expectEqualStrings(part, actual);
        try std.testing.expectEqualStrings(expected.name, external.member[case.namespace.len]);
        try std.testing.expectEqual(expected.expanded, external.expand_tuple);
        try std.testing.expectEqual(expected.allocating, external.allocator_argument);
        try std.testing.expectEqual(expected.io, external.io_argument);
        try std.testing.expectEqual(expected.process, external.process_argument);
        try std.testing.expectEqual(expected.fallible, external.fallible);
        try std.testing.expectEqual(expected.concurrent, external.concurrent);

        if (expected.errors) |names| {
            const actual = external.errors orelse return error.ExpectedFiniteErrors;

            try std.testing.expectEqual(names.len, actual.len);
            for (names, actual) |name, member| try std.testing.expectEqualStrings(name, member);
        } else try std.testing.expect(external.errors == null);
    }

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);
}

pub fn check(allocator: std.mem.Allocator, case: Case) !void {
    var result = try analyze(allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("member diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try inspect(allocator, result.value.ir, case);
}
