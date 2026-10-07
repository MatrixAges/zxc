const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");

fn analyze(source: []const u8) !compiler.AnalysisResult {
    return compiler.analyzeProject(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx", .root_dir = "/project" });
}

fn sourceFor(method: []const u8, expression: []const u8) ![]const u8 {
    return std.fmt.allocPrint(std.testing.allocator, "export type Input = i64[]\n\nexport type Output = bool\n\nexport default function (in: Input): Output {{ return in.{s}({s}) }}", .{ method, expression });
}

test "native predicates have copy bool results and no container error effect" {
    for ([_][]const u8{ "every", "some" }) |method| {
        const source = try sourceFor(method, "item => item > 0");

        defer std.testing.allocator.free(source);

        var result = try analyze(source);

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
        try std.testing.expectEqual(compiler.ir.Ownership.copy, result.value.ir.output_ownership);

        const effects = (try zx.error_effects.program(std.testing.allocator, result.value.ir)).?;

        defer std.testing.allocator.free(effects);

        try std.testing.expectEqual(@as(usize, 0), effects.len);
    }
}

test "native predicates reject non bool callback results" {
    for ([_][]const u8{ "every", "some" }) |method| {
        const source = try sourceFor(method, "item => item");

        defer std.testing.allocator.free(source);

        var result = try analyze(source);

        defer result.deinit();

        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.type_mismatch, result.value.diagnostic.code);
    }
}

test "native predicates reject extra parameters and missing callbacks" {
    for ([_][]const u8{ "every", "some" }) |method| {
        for ([_][]const u8{ "(item, index) => item > 0", "", "item => item > 0, true" }) |callback| {
            const source = try sourceFor(method, callback);

            defer std.testing.allocator.free(source);

            var result = try analyze(source);

            defer result.deinit();

            try std.testing.expect(result.value == .diagnostic);
            try std.testing.expectEqual(.type_mismatch, result.value.diagnostic.code);
        }
    }
}

test "native predicate callbacks retain the non capturing scope contract" {
    var result = try analyze("export type Input = i64[]\n\nexport type Output = bool\n\nexport default function (in: Input): Output { const limit: i64 = 0\n return in.every(item => item > limit) }");

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
}

test "nested predicates validate and emit unused constant callback captures" {
    for ([_][]const u8{
        "export type Input = i64[][]\n\nexport type Output = bool\n\nexport default function (in: Input): Output { return in.every(row => row.some(item => item > 0)) }",
        "export type Input = i64[]\n\nexport type Output = bool\n\nexport default function (in: Input): Output { return in.every(item => true) }",
        "export type Input = i64[]\n\nexport type Output = bool\n\nexport default function (in: Input): Output { return in.some(item => false) }",
    }) |source| {
        var result = try analyze(source);

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);

        const bundle = try compiler.zig.emitBundle(std.testing.allocator, result.value.ir);

        defer bundle.deinit(std.testing.allocator);

        try std.testing.expect(std.mem.indexOf(u8, bundle.source, "predicate_") != null);
    }
}

test "native predicate IR rejects forged initial values and non bool bodies" {
    const source = try sourceFor("every", "item => item > 0");

    defer std.testing.allocator.free(source);

    var result = try analyze(source);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);

    for ([_]bool{ false, true }) |wrong_body| {
        var program = result.value.ir;
        const values = try std.testing.allocator.dupe(compiler.ir.Expression, program.expressions);

        defer std.testing.allocator.free(values);

        program.expressions = values;

        var found = false;

        for (values) |*value| {
            if (value.value != .transform) continue;

            found = true;

            if (wrong_body) value.value.transform.body = value.value.transform.target else value.value.transform.initial = value.value.transform.body;
        }

        try std.testing.expect(found);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) != null);
    }
}
