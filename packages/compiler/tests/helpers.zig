const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");

pub fn parseValid(source: []const u8) !compiler.ParseResult {
    var result = try compiler.parse(std.testing.allocator, source, "case.zx");

    errdefer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("unexpected parse diagnostic {t} at {d}: {s}\n", .{ issue.code, issue.span.start, issue.message });

        return error.UnexpectedDiagnostic;
    }

    return result;
}

pub fn parseInvalid(source: []const u8, code: @FieldType(zx.Diagnostic, "code")) !void {
    var result = try compiler.parse(std.testing.allocator, source, "negative.zx");

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(code, result.value.diagnostic.code);
}

pub fn analyzeCase(source: []const u8, expected: ?@FieldType(zx.Diagnostic, "code")) !void {
    var parsed = try parseValid(source);

    defer parsed.deinit();

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    if (expected) |code| {
        try std.testing.expect(analyzed.value == .diagnostic);
        try std.testing.expectEqual(code, analyzed.value.diagnostic.code);
    } else {
        if (analyzed.value == .diagnostic) {
            std.debug.print("unexpected analysis diagnostic {t}: {s}\n", .{ analyzed.value.diagnostic.code, analyzed.value.diagnostic.message });
        }

        try std.testing.expect(analyzed.value == .ir);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, analyzed.value.ir) == null);
    }
}
