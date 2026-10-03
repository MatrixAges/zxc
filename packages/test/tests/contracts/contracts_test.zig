const std = @import("std");
const compiler = @import("compiler");
const prefix = "export type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output ";
const suffix = " {\n  return in;\n}\n";
const valid = prefix ++ "requires(in > 0) ensures(out >= in)" ++ suffix;

test "contract IR has scoped bool predicates and emission requires proof" {
    var parsed = try compiler.parse(std.testing.allocator, valid, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    const program = analyzed.value.ir;

    try std.testing.expectEqual(@as(usize, 2), program.contracts.len);
    try std.testing.expectEqual(.requires, program.contracts[0].kind);
    try std.testing.expectEqual(.ensures, program.contracts[1].kind);
    try std.testing.expectEqual(@as(usize, 1), program.contracts[0].symbols.len);
    try std.testing.expectEqual(@as(usize, 2), program.contracts[1].symbols.len);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);
    try std.testing.expectError(error.UnverifiedContracts, compiler.zig.emit(std.testing.allocator, program));
}

test "contract predicates reject invalid scope type and order" {
    const Case = struct { source: []const u8, parse_error: bool = false, code: @FieldType(compiler.Diagnostic, "code") };

    const cases = [_]Case{
        .{ .source = prefix ++ "requires(in)" ++ suffix, .code = .type_mismatch },
        .{ .source = prefix ++ "ensures(out)" ++ suffix, .code = .type_mismatch },
        .{ .source = prefix ++ "requires(out > 0)" ++ suffix, .code = .name },
        .{ .source = prefix ++ "ensures(missing > 0)" ++ suffix, .code = .name },
        .{ .source = prefix ++ "ensures(true) requires(true)" ++ suffix, .parse_error = true, .code = .contract },
        .{ .source = prefix ++ "requires true" ++ suffix, .parse_error = true, .code = .syntax },
    };

    for (cases) |case| {
        var parsed = try compiler.parse(std.testing.allocator, case.source, "main.zx");

        defer parsed.deinit();

        if (case.parse_error) {
            try std.testing.expect(parsed.value == .diagnostic);
            try std.testing.expectEqual(case.code, parsed.value.diagnostic.code);
        } else {
            try std.testing.expect(parsed.value == .parsed);

            var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

            defer analyzed.deinit();

            try std.testing.expect(analyzed.value == .diagnostic);
            try std.testing.expectEqual(case.code, analyzed.value.diagnostic.code);
        }
    }
}

test "contract analysis cleans up every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{});
}

fn checkAllocation(allocator: std.mem.Allocator) !void {
    var parsed = try compiler.parse(allocator, valid, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, analyzed.value.ir) == null);
}

test "project compilation cannot bypass an imported unverified contract" {
    const result = try compiler.compileProject(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import dependency from \"./dependency.zx\";\n\nexport type Input = u64;\n\nexport type Output = u64;\n\nexport default function (in: Input): Output {\n  return dependency(in);\n}\n" },
        .{ .path = "dependency.zx", .source = valid },
    }, .{ .entry = "main.zx" });

    defer result.deinit(std.testing.allocator);

    try std.testing.expect(result == .diagnostic);
    try std.testing.expectEqual(.contract, result.diagnostic.code);
    try std.testing.expectEqualStrings("formal contract verification is required before code generation", result.diagnostic.message);
}

test "public compilation refuses even constant unverified contracts" {
    const sources = [_][]const u8{
        valid,
        prefix ++ "requires(true)" ++ suffix,
        prefix ++ "requires(false)" ++ suffix,
        prefix ++ "ensures(false)" ++ suffix,
    };

    for (sources) |source| {
        const result = try compiler.compile(std.testing.allocator, source, "main.zx");

        defer result.deinit(std.testing.allocator);

        try std.testing.expect(result == .diagnostic);
        try std.testing.expectEqual(.contract, result.diagnostic.code);
        try std.testing.expectEqualStrings("formal contract verification is required before code generation", result.diagnostic.message);
    }
}
