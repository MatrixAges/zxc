const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");

const unsupported = [_][]const u8{
    "in.forEach(item => item)",
    "in.forEach()",
    "in.forEach(item => item, 0)",
    "in.forEach((item, index) => item)",
};

fn rejected(allocator: std.mem.Allocator, expression: []const u8, list: bool) !void {
    const source = try std.fmt.allocPrint(allocator, "export type Input = {s}\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{\n  return {s}\n}}\n", .{ if (list) "u64[]" else "u64", expression });

    defer allocator.free(source);

    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{ .entry = "main.zx" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.name, result.value.diagnostic.code);
    try std.testing.expectEqualStrings(if (list) "unknown list operation" else "unknown imported function", result.value.diagnostic.message);

    const start = std.mem.indexOf(u8, source, expression).?;

    try std.testing.expectEqual(@as(u32, @intCast(start)), result.value.diagnostic.span.start);
    try std.testing.expectEqual(@as(u32, @intCast(start + (if (list) expression.len else "iterate".len))), result.value.diagnostic.span.end);
}

test "forEach remains rejected independently of callback shape" {
    for (unsupported) |expression| try rejected(std.testing.allocator, expression, true);
}

test "iterate is not retained as a legacy built in alias" {
    try rejected(std.testing.allocator, "iterate(in)", false);
}

fn invalid(allocator: std.mem.Allocator) !void {
    try rejected(allocator, unsupported[0], true);
}

test "retired list method diagnostics release every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, invalid, .{});
}

fn valid(allocator: std.mem.Allocator) !void {
    const source = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return loop(in, { while: state => false, next: state => { state += 1 } })\n}\n";
    const result = try compiler.compile(allocator, source, "main.zx");

    defer result.deinit(allocator);

    try std.testing.expect(result == .source);
    try std.testing.expect(std.mem.indexOf(u8, result.source, "while (") != null);
}

test "loop scalar lowering releases every compilation allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, valid, .{});
}
