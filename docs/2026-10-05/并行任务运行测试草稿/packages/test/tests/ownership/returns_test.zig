const std = @import("std");
const compiler = @import("compiler");

fn source(allocator: std.mem.Allocator, input: []const u8, output: []const u8, body: []const u8, imported: bool) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}export type Input = {s}\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{
        if (imported) "import dependency from \"./dependency.zx\"\n\n" else "",
        input,
        output,
        body,
    });
}

test "function return ownership distinguishes new data and borrowed views" {
    const cases = [_]struct { input: []const u8, output: []const u8, dependency: []const u8, body: []const u8, rejected: bool }{
        .{ .input = "u64", .output = "u64[]", .dependency = "  return [in]\n", .body = "  const values = dependency(in)\n  const [next, _] = values.reverse()\n\n  return next\n", .rejected = false },
        .{ .input = "u64[]", .output = "u64[]", .dependency = "  return in\n", .body = "  const values = dependency(in)\n  const [next, _] = values.reverse()\n\n  return next\n", .rejected = true },
        .{ .input = "{ choose: bool\n items: u64[] }", .output = "u64[]", .dependency = "  if (in.choose) {\n    return [1]\n  }\n\n  return in.items\n", .body = "  const values = dependency(in)\n  const [next, _] = values.reverse()\n\n  return next\n", .rejected = true },
    };

    for (cases) |case| {
        const main = try source(std.testing.allocator, case.input, case.output, case.body, true);

        defer std.testing.allocator.free(main);

        const dependency = try source(std.testing.allocator, case.input, case.output, case.dependency, false);

        defer std.testing.allocator.free(dependency);

        var result = try compiler.project.analyze(std.testing.allocator, &.{ .{ .path = "main.zx", .source = main }, .{ .path = "dependency.zx", .source = dependency } }, .{ .entry = "main.zx", .root_dir = "/project" });

        defer result.deinit();

        if (case.rejected) {
            try std.testing.expect(result.value == .diagnostic);
            try std.testing.expectEqual(.ownership, result.value.diagnostic.code);
        } else {
            try std.testing.expect(result.value == .ir);
            try std.testing.expectEqual(.owned, result.value.ir.output_ownership);
            try std.testing.expectEqual(.owned, result.value.ir.functions[0].output_ownership);
            try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
        }
    }
}

test "borrowed return cannot be forged into an owned IR contract" {
    const text = try source(std.testing.allocator, "u64[]", "u64[]", "  return in\n", false);

    defer std.testing.allocator.free(text);

    var parsed = try compiler.parse(std.testing.allocator, text, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expectEqual(.borrowed, analyzed.value.ir.output_ownership);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, analyzed.value.ir) == null);

    var forged = analyzed.value.ir;
    forged.output_ownership = .owned;

    const diagnostic = (try compiler.validateIr(std.testing.allocator, forged)).?;

    try std.testing.expectEqual(.contract, diagnostic.code);
}

test "a returned read-only view prevents consuming its source owner" {
    const main = try source(std.testing.allocator, "void", "u64", "  const values: u64[] = [1, 2]\n  const view = dependency(values)\n  const [next, _] = values.reverse()\n\n  return view.length + next.length\n", true);

    defer std.testing.allocator.free(main);

    const dependency = try source(std.testing.allocator, "u64[]", "u64[]", "  return in\n", false);

    defer std.testing.allocator.free(dependency);

    var result = try compiler.project.analyze(std.testing.allocator, &.{ .{ .path = "main.zx", .source = main }, .{ .path = "dependency.zx", .source = dependency } }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.ownership, result.value.diagnostic.code);
}

comptime {
    _ = @import("loans/root.zig");
}
