const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");

test "iterate rules callbacks captures and state update targets are checked" {
    const cases = [_]struct { expression: []const u8, code: @FieldType(compiler.Diagnostic, "code"), message: []const u8 }{
        .{ .expression = "iterate(in)", .code = .type_mismatch, .message = "iterate requires an initial state and a rule literal" },
        .{ .expression = "iterate(in, 1)", .code = .type_mismatch, .message = "iterate rules must be an inline literal" },
        .{ .expression = "iterate(in, { next: s => { s += 1 } })", .code = .type_mismatch, .message = "iterate requires while and exactly one next or do step" },
        .{ .expression = "iterate(in, { while: s => false })", .code = .type_mismatch, .message = "iterate requires while and exactly one next or do step" },
        .{ .expression = "iterate(in, { while: s => false, next: s => { s += 1 }, do: s => { s += 1 } })", .code = .name, .message = "iterate requires exactly one next or do step" },
        .{ .expression = "iterate(in, { while: s => false, next: s => { s += 1 }, other: 1 })", .code = .name, .message = "unknown iterate rule; expected while and next or do" },
        .{ .expression = "iterate(in, { while: s => 1, next: s => { s += 1 } })", .code = .type_mismatch, .message = "a numeric literal requires a numeric type" },
        .{ .expression = "iterate(in, { while: () => false, next: s => { s += 1 } })", .code = .type_mismatch, .message = "iterate callbacks require one inline state parameter" },
        .{ .expression = "iterate(in, { while: s => false, next: s => s + 1 })", .code = .type_mismatch, .message = "iterate next and do require a state update block" },
        .{ .expression = "iterate(in, { while: s => false, next: s => { return s } })", .code = .return_path, .message = "iterate steps yield state at the block end; return is not allowed" },
        .{ .expression = "iterate(in, { while: s => false, next: s => { const old = s\n\n old += 1 } })", .code = .ownership, .message = "only the iterate state parameter can be updated" },
        .{ .expression = "iterate(in, { while: s => false, next: s => { const s = 1 } })", .code = .name, .message = "the iterate state parameter cannot be redeclared" },
        .{ .expression = "iterate(in, { while: s => in < 3, next: s => { s += 1 } })", .code = .ownership, .message = "ZX callbacks cannot capture outer bindings; use explicit callback parameters" },
    };

    for (cases) |case| {
        const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{\n  return {s}\n}}\n", .{case.expression});

        defer std.testing.allocator.free(source);

        var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx" });

        defer result.deinit();

        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(case.code, result.value.diagnostic.code);
        try std.testing.expectEqualStrings(case.message, result.value.diagnostic.message);
        try std.testing.expect(result.value.diagnostic.span.start < result.value.diagnostic.span.end);
        try std.testing.expect(result.value.diagnostic.span.end <= source.len);
    }
}

fn valid(allocator: std.mem.Allocator) !void {
    const result = try compiler.compile(allocator, @embedFile("fixtures/next.zx"), "main.zx");

    defer result.deinit(allocator);

    try std.testing.expect(result == .source);
    try std.testing.expect(std.mem.indexOf(u8, result.source, "while (") != null);
    try std.testing.expect(std.mem.indexOf(u8, result.source, "allocator.alloc") == null);
}

test "iterate scalar analysis and lowering clean all allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, valid, .{});
}
