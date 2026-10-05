const std = @import("std");
const compiler = @import("compiler");
const source = "import native from \"zig:sample\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return native.apply(in)\n}\n";

pub const Contract = struct {
    declaration: []const u8,
    fallible: bool,
    errors: ?[]const []const u8 = null,
    allocating: bool = false,
    io: bool = false,
    concurrent: bool = false,
};

pub const Failure = struct {
    declaration: []const u8,
    code: @FieldType(compiler.Diagnostic, "code"),
    message: ?[]const u8 = null,
};

fn analyze(allocator: std.mem.Allocator, declaration: []const u8) !compiler.AnalysisResult {
    return compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = declaration, .module = "sample" }},
    });
}

pub fn accepted(allocator: std.mem.Allocator, case: Contract) !void {
    var result = try analyze(allocator, case.declaration);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    var count: usize = 0;

    for (result.value.ir.functions) |function| {
        const external = function.external orelse continue;

        count += 1;

        try std.testing.expectEqual(case.fallible, external.fallible);
        try std.testing.expectEqual(case.allocating, external.allocator_argument);
        try std.testing.expectEqual(case.io, external.io_argument);
        try std.testing.expectEqual(case.concurrent, external.concurrent);
        try std.testing.expectEqual(@as(usize, 1), external.member.len);
        try std.testing.expectEqualStrings("apply", external.member[0]);

        if (case.errors) |expected| {
            const actual = external.errors orelse return error.ExpectedFiniteErrors;

            try std.testing.expectEqual(expected.len, actual.len);

            for (expected) |name| {
                var found = false;

                for (actual) |member| {
                    if (std.mem.eql(u8, name, member)) found = true;
                }

                try std.testing.expect(found);
            }
        } else {
            try std.testing.expect(external.errors == null);
        }
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}

pub fn rejected(allocator: std.mem.Allocator, case: Failure) !void {
    var result = try analyze(allocator, case.declaration);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(case.code, result.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
    try std.testing.expect(std.mem.startsWith(u8, result.value.diagnostic.message, "sample.d.zx:"));

    if (case.message) |message| {
        try std.testing.expect(std.mem.endsWith(u8, result.value.diagnostic.message, message));
    }
}
