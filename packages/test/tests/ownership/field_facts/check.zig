const std = @import("std");
const compiler = @import("compiler");

pub fn analyze(allocator: std.mem.Allocator, source: []const u8, ownership: compiler.ir.Ownership) !compiler.AnalysisResult {
    var result = try compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx", .root_dir = "/project" });

    errdefer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{t}: {s}, bytes {d}..{d}\n{s}\n", .{ issue.code, issue.message, issue.span.start, issue.span.end, source });

        return error.UnexpectedDiagnostic;
    }

    try std.testing.expectEqual(ownership, result.value.ir.output_ownership);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    return result;
}
