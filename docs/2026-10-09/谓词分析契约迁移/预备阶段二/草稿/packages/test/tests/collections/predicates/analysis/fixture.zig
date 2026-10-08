const std = @import("std");
pub const compiler = @import("compiler");

pub const Case = struct {
    body: []const u8,
    input: []const u8 = "i64[]",
};

pub fn analyze(case: Case) !compiler.AnalysisResult {
    const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = {s}\n\nexport type Output = bool\n\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{ case.input, case.body });

    defer std.testing.allocator.free(source);

    return compiler.analyzeProject(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx", .root_dir = "/project" });
}

pub fn accepted(case: Case) !void {
    var result = try analyze(case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
    try std.testing.expectEqual(compiler.ir.Ownership.copy, result.value.ir.output_ownership);
}

pub fn rejected(case: Case, code: @FieldType(compiler.Diagnostic, "code"), message: ?[]const u8) !void {
    var result = try analyze(case);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;

    if (issue.code != code) std.debug.print("unexpected diagnostic {t}: {s}\n", .{ issue.code, issue.message });
    try std.testing.expectEqual(code, issue.code);
    try std.testing.expectEqual(@as(?usize, 0), issue.source_index);
    if (message) |expected| try std.testing.expectEqualStrings(expected, issue.message);
}

pub fn method(method_name: []const u8, callback: []const u8, accepted_case: bool) !void {
    const body = try std.fmt.allocPrint(std.testing.allocator, "return in.{s}({s})", .{ method_name, callback });

    defer std.testing.allocator.free(body);

    if (accepted_case) try accepted(.{ .body = body }) else try rejected(.{ .body = body }, .type_mismatch, null);
}
