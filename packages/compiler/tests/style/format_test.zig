const std = @import("std");
const compiler = @import("compiler");

fn stripWhitespace(allocator: std.mem.Allocator, text: []const u8) ![]u8 {
    var result: std.ArrayList(u8) = .empty;

    for (text) |byte| if (!std.ascii.isWhitespace(byte)) {
        try result.append(allocator, byte);
    };

    return result.toOwnedSlice(allocator);
}

test "style: formatting is idempotent and preserves comments and tokens" {
    const input = "export type Input = u64;\nexport type Output = u64;\nexport default function (in: Input): Output {\n\n const first = in; // keep this comment\n\n const second = first + 1;\n return second;\n\n}\n";
    const first = try compiler.format(std.testing.allocator, input, "format.zx");

    defer first.deinit(std.testing.allocator);

    try std.testing.expect(first == .source);

    const second = try compiler.format(std.testing.allocator, first.source, "format.zx");

    defer second.deinit(std.testing.allocator);

    try std.testing.expectEqualStrings(first.source, second.source);

    const original = try stripWhitespace(std.testing.allocator, input);

    defer std.testing.allocator.free(original);

    const formatted = try stripWhitespace(std.testing.allocator, first.source);

    defer std.testing.allocator.free(formatted);

    try std.testing.expectEqualStrings(original, formatted);
    try std.testing.expect(std.mem.indexOf(u8, first.source, "// keep this comment") != null);
}

test "style: a pure type file does not need an extra blank line at EOF" {
    const source = "export type Value = u64;\n";
    const result = try compiler.format(std.testing.allocator, source, "types.zx");

    defer result.deinit(std.testing.allocator);

    try std.testing.expectEqualStrings(source, result.source);
}

test "style: naming checks reach callback and destructuring bindings" {
    for ([_][]const u8{
        "return in.map((BadName) => BadName);",
        "const values = in.clone(); const [BadName, _] = values.pop(); return BadName;",
    }) |body| {
        const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = u64[]; export type Output = u64[]; export default function (in: Input): Output {{ {s} }}", .{body});

        defer std.testing.allocator.free(source);

        const result = try compiler.compile(std.testing.allocator, source, "naming.zx");

        defer result.deinit(std.testing.allocator);

        try std.testing.expect(result == .diagnostic);
        try std.testing.expectEqualStrings("naming", @tagName(result.diagnostic.code));
    }
}

fn compileAllocationFailures(allocator: std.mem.Allocator) !void {
    const result = try compiler.compile(allocator, "export type Input = u64[]; export type Output = u64[]; export default function (in: Input): Output { return in.map((item) => item + 1); }", "memory.zx");

    defer result.deinit(allocator);

    try std.testing.expect(result == .source);
}

test "integration: compilation frees all allocations at every failure point" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, compileAllocationFailures, .{});
}
