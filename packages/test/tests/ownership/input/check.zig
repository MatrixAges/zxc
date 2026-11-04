const std = @import("std");
pub const compiler = @import("compiler");

pub const Case = struct {
    body: []const u8,
    input: []const u8 = "u64[]",
    output: []const u8 = "u64[]",
    legacy_input: bool = false,
    helper_borrows: bool = false,
    helper_input: []const u8 = "u64[]",
    helper_output: []const u8 = "u64[]",
    helper_body: []const u8 = "  return in.push(in.length)[0]",
    ownership: []const u8 = "owned",
};

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const source = try std.fmt.allocPrint(allocator, "import consume from \"./consume\"\n\nexport type Input = {s}\n\nexport type Output = {s}\n\nexport default function (in: {s}Input): Output {{\n{s}\n}}\n", .{ case.input, case.output, if (case.legacy_input) "owned " else "", case.body });

    defer allocator.free(source);

    const helper = try std.fmt.allocPrint(allocator, "{s}export type Input = {s}\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{ if (case.helper_borrows) "import view from \"./view\"\n" else "", case.helper_input, case.helper_output, case.helper_body });

    defer allocator.free(helper);

    const sources = [_]compiler.project.Source{
        .{ .path = "main.zx", .source = source },
        .{ .path = "consume.zx", .source = helper },
        .{ .path = "view.zx", .source = "export type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return in }\n" },
    };

    var result = try compiler.project.analyze(allocator, sources[0..if (case.helper_borrows) 3 else 2], .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    if (case.legacy_input) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.syntax, result.value.diagnostic.code);
        try std.testing.expectEqual(std.mem.indexOf(u8, source, "owned Input").?, result.value.diagnostic.span.start);
    } else {
        if (result.value == .diagnostic) {
            std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

            return error.UnexpectedDiagnostic;
        }

        var found = false;

        for (0..result.value.ir.functions.count()) |function_row| {
            const function = result.value.ir.functions.at(function_row);

            if (!std.mem.endsWith(u8, function.file_name, "/consume.zx")) continue;

            found = true;
        }

        try std.testing.expect(found);
        try std.testing.expectEqualStrings(case.ownership, @tagName(result.value.ir.output_ownership));
        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
    }
}
