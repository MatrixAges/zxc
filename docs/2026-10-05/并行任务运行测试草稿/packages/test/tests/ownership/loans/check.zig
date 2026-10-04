const std = @import("std");
const compiler = @import("compiler");

pub const Case = struct {
    input: []const u8,
    body: []const u8,
    helper_output: []const u8 = "u64",
    helper_body: []const u8 = "  return 0",
    marker: ?[]const u8 = null,
};

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const source = try std.fmt.allocPrint(allocator, "import inspect from \"./inspect.zx\"\nimport count from \"./count.zx\"\n\nexport type Input = void\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{\n  const values: u64[] = [1, 2, 3]\n\n{s}\n}}\n", .{case.body});

    defer allocator.free(source);

    const helper = try std.fmt.allocPrint(allocator, "export type Input = {s}\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{ case.input, case.helper_output, case.helper_body });

    defer allocator.free(helper);

    var result = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "inspect.zx", .source = helper },
        .{ .path = "count.zx", .source = "export type Input = u64[]\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in.length\n}\n" },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    if (case.marker) |marker| {
        try std.testing.expect(result.value == .diagnostic);

        const issue = result.value.diagnostic;

        errdefer std.debug.print("{t}: {s}, span {d}..{d}\n", .{ issue.code, issue.message, issue.span.start, issue.span.end });

        try std.testing.expectEqual(.ownership, issue.code);
        try std.testing.expectEqual(@as(?usize, 0), issue.source_index);
        try std.testing.expectEqual(std.mem.lastIndexOf(u8, source, marker).?, issue.span.start);
    } else {
        if (result.value == .diagnostic) {
            std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

            return error.UnexpectedDiagnostic;
        }

        try std.testing.expectEqual(.copy, result.value.ir.output_ownership);
        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
    }
}
