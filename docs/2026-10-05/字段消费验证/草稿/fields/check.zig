const std = @import("std");
const compiler = @import("compiler");
pub const pair = "{ first: u64[], second: u64[], count: u64 }";
pub const Case = struct { input: []const u8 = pair, owned: bool = true, body: []const u8, reject: bool = false };

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const source = try std.fmt.allocPrint(allocator, "import borrow from \"./borrow.zx\"\nimport parent from \"./parent.zx\"\nimport count from \"./count.zx\"\n\nexport type Input = {s}\n\nexport type Output = u64\n\nexport default function (in: {s}Input): Output {{\n{s}\n}}\n", .{ case.input, if (case.owned) "owned " else "", case.body });

    defer allocator.free(source);

    const helper = try std.fmt.allocPrint(allocator, "export type Input = {s}\n\nexport type Output = Input\n\nexport default function (in: Input): Output {{\n  return in\n}}\n", .{case.input});

    defer allocator.free(helper);

    var result = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "parent.zx", .source = helper },
        .{ .path = "borrow.zx", .source = "export type Input = u64[]\n\nexport type Output = Input\n\nexport default function (in: Input): Output {\n  return in\n}\n" },
        .{ .path = "count.zx", .source = "export type Input = u64[]\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in.length\n}\n" },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    if (case.reject) {
        try std.testing.expect(result.value == .diagnostic);

        errdefer std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

        try std.testing.expectEqual(.ownership, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
    } else {
        if (result.value == .diagnostic) {
            std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

            return error.UnexpectedDiagnostic;
        }

        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
    }
}
