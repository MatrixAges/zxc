const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");

test "forEach parameters captures void binding and element ownership are checked" {
    const cases = [_]struct { input: []const u8 = "u64[]", body: []const u8, code: @FieldType(compiler.Diagnostic, "code"), message: []const u8 }{
        .{ .body = "in.forEach()", .code = .type_mismatch, .message = "map/filter/forEach require a callback; reduce requires a callback and initial value" },
        .{ .body = "in.forEach(item => item, 1)", .code = .type_mismatch, .message = "map/filter/forEach require a callback; reduce requires a callback and initial value" },
        .{ .body = "in.forEach(() => 1)", .code = .type_mismatch, .message = "callback parameter count does not match the collection operation" },
        .{ .body = "in.forEach((item, index) => item)", .code = .type_mismatch, .message = "callback parameter count does not match the collection operation" },
        .{ .body = "in.forEach(1)", .code = .type_mismatch, .message = "collection callback must be an inline, non-capturing lambda" },
        .{ .body = "const factor = 2\n\n  in.forEach(item => item + factor)", .code = .ownership, .message = "ZX callbacks cannot capture outer bindings; use explicit callback parameters" },
        .{ .body = "in.forEach(item => in[0])", .code = .ownership, .message = "ZX callbacks cannot capture outer bindings; use explicit callback parameters" },
        .{ .body = "const result = in.forEach(item => item)", .code = .type_mismatch, .message = "void results cannot be bound to a value" },
        .{ .body = "in.map(item => item)", .code = .type_mismatch, .message = "expression type does not match its context" },
        .{ .input = "u64", .body = "in.forEach(item => item)", .code = .type_mismatch, .message = "collection methods require a list" },
        .{ .input = "u64[][]", .body = "in.forEach(row => row.reverse())", .code = .ownership, .message = "consuming list operations require an owned value; borrowed values cannot be consumed" },
        .{ .body = "in.forEach(item => item)\n\n  const [next, _] = in.reverse()", .code = .ownership, .message = "consuming list operations require an owned value; borrowed values cannot be consumed" },
    };

    for (cases) |case| {
        const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = {s}\n\nexport type Output = void\n\nexport default function (in: Input): Output {{\n  {s}\n}}\n", .{ case.input, case.body });

        defer std.testing.allocator.free(source);

        const result = try compiler.compile(std.testing.allocator, source, "foreach.zx");

        defer result.deinit(std.testing.allocator);

        try std.testing.expect(result == .diagnostic);
        try std.testing.expectEqual(case.code, result.diagnostic.code);
        try std.testing.expectEqualStrings(case.message, result.diagnostic.message);
        try std.testing.expect(result.diagnostic.span.start < result.diagnostic.span.end);
        try std.testing.expect(result.diagnostic.span.end <= source.len);
    }
}

fn valid(allocator: std.mem.Allocator) !void {
    const source = "export type Input = u64[]\n\nexport type Output = void\n\nexport default function (in: Input): Output {\n  in.forEach(item => item)\n}\n";
    const result = try compiler.compile(allocator, source, "foreach.zx");

    defer result.deinit(allocator);

    try std.testing.expect(result == .source);
    try std.testing.expect(std.mem.indexOf(u8, result.source, "for (") != null);
    try std.testing.expect(std.mem.indexOf(u8, result.source, "allocator.alloc") == null);
}

test "forEach scalar lowering cleans every compilation allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, valid, .{});
}
