const std = @import("std");
const compiler = @import("compiler");

pub const Case = struct {
    input: []const u8 = "u64[]",
    output: []const u8 = "u64[]",
    body: []const u8,
    ownership: []const u8 = "owned",
    code: []const u8 = "ownership",
    marker: ?[]const u8 = null,
};

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const source = try std.fmt.allocPrint(allocator, "export type Input = {s}\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{ case.input, case.output, case.body });

    defer allocator.free(source);

    var result = try compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    if (case.marker) |marker| {
        try std.testing.expect(result.value == .diagnostic);

        const issue = result.value.diagnostic;

        errdefer std.debug.print("{t}: {s}, span {d}..{d}\n", .{ issue.code, issue.message, issue.span.start, issue.span.end });

        try std.testing.expectEqualStrings(case.code, @tagName(issue.code));
        try std.testing.expectEqual(@as(?usize, 0), issue.source_index);
        try std.testing.expectEqual(std.mem.lastIndexOf(u8, source, marker).?, issue.span.start);
    } else {
        if (result.value == .diagnostic) {
            std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

            return error.UnexpectedDiagnostic;
        }

        try std.testing.expectEqualStrings(case.ownership, @tagName(result.value.ir.output_ownership));
        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
    }
}
