const std = @import("std");
const compiler = @import("compiler");
const Code = @FieldType(compiler.Diagnostic, "code");
pub const checkUnicodeComments = @import("unicode_comments.zig").check;
const Phase = enum { parse, analyze, compile };

pub fn check(source: []const u8, phase: Phase, expected: ?Code, span: ?[2]usize) !void {
    if (phase == .compile) {
        var result = try compiler.compile(std.testing.allocator, source, "case.zx");

        defer result.deinit(std.testing.allocator);

        try checkDiagnostic(if (result == .diagnostic) result.diagnostic else null, expected, span);

        return;
    }

    var parsed = try compiler.parse(std.testing.allocator, source, "case.zx");

    defer parsed.deinit();

    if (phase == .parse) {
        try checkDiagnostic(if (parsed.value == .diagnostic) parsed.value.diagnostic else null, expected, span);

        return;
    }

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try checkDiagnostic(if (analyzed.value == .diagnostic) analyzed.value.diagnostic else null, expected, span);

    if (analyzed.value == .ir) {
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, analyzed.value.ir) == null);
    }
}

fn checkDiagnostic(actual: ?compiler.Diagnostic, expected: ?Code, span: ?[2]usize) !void {
    if (expected) |code| {
        try std.testing.expect(actual != null);
        try std.testing.expectEqual(code, actual.?.code);

        if (span) |range| {
            try std.testing.expectEqual(range[0], actual.?.span.start);
            try std.testing.expectEqual(range[1], actual.?.span.end);
        }
    } else {
        try std.testing.expect(actual == null);
    }
}
