const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");

fn source(allocator: std.mem.Allocator, statement: []const u8) ![]u8 {
    const raw = try std.fmt.allocPrint(allocator, "export type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output {{\n{s}\nreturn in\n}}\n", .{statement});

    defer allocator.free(raw);

    const formatted = try compiler.format(allocator, raw, "main.zx");

    if (formatted == .diagnostic) {
        defer formatted.deinit(allocator);

        return error.InvalidFixtureSyntax;
    }

    return formatted.source;
}

fn valid(allocator: std.mem.Allocator, statement: []const u8, iterations: usize) !void {
    const text = try source(allocator, statement);

    defer allocator.free(text);

    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = text }}, .{ .entry = "main.zx" });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("standalone diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try compiler.validateIr(allocator, result.value.ir));

    var count: usize = 0;

    for (0..result.value.ir.expressions.count()) |expression_index| {
        const expression = result.value.ir.expressions.at(expression_index);

        if (expression.value == .iteration) count += 1;
    }

    try std.testing.expectEqual(iterations, count);

    const bundle = try compiler.zig.emitBundle(allocator, result.value.ir);

    defer bundle.deinit(allocator);

    try std.testing.expect(std.mem.indexOf(u8, bundle.source, "while (") != null);
}

fn rejected(output_type: []const u8, returned: []const u8) !void {
    const allocator = std.testing.allocator;
    const body = try source(allocator, "helper(in)");

    defer allocator.free(body);

    const text = try std.fmt.allocPrint(allocator, "import helper from \"./helper\"\n\n{s}", .{body});
    const helper = try std.fmt.allocPrint(allocator, "export type Input = u64\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n  return {s}\n}}\n", .{ output_type, returned });

    defer allocator.free(helper);
    defer std.testing.allocator.free(text);

    const formatted = try compiler.format(allocator, helper, "helper.zx");

    defer formatted.deinit(allocator);

    try std.testing.expect(formatted == .source);

    var result = try compiler.analyzeProject(allocator, &.{
        .{ .path = "main.zx", .source = text },
        .{ .path = "helper.zx", .source = formatted.source },
    }, .{ .entry = "main.zx" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.type_mismatch, result.value.diagnostic.code);

    var start = std.mem.indexOf(u8, text, "Output {").? + "Output {".len;
    var end = std.mem.lastIndexOf(u8, text, "return in").?;

    while (std.ascii.isWhitespace(text[start])) start += 1;
    while (std.ascii.isWhitespace(text[end - 1])) end -= 1;
    try std.testing.expectEqual(@as(u32, @intCast(start)), result.value.diagnostic.span.start);
    try std.testing.expectEqual(@as(u32, @intCast(end)), result.value.diagnostic.span.end);
}

const scalar = "loop(in, { while: current => current > 0, next: current => { current -= 1 } })";

test "standalone scalar state retains nonvoid iteration IR" {
    try valid(std.testing.allocator, scalar, 1);
}

test "standalone object state can update its fields" {
    try valid(std.testing.allocator, "loop({ remaining: in }, { while: current => current.remaining > 0, next: current => { current.remaining -= 1 } })", 1);
}

test "nested standalone iterations validate state scope bindings" {
    try valid(std.testing.allocator, "loop(in, { while: current => current > 0, next: current => { loop(current, { while: inner => inner > 0, next: inner => { inner -= 1 } })\ncurrent -= 1 } })", 2);
}

test "standalone postcondition state remains valid in a branch" {
    try valid(std.testing.allocator, "if (in > 0) { loop(in, { while: current => current > 0, do: current => { current -= 1 } }) }", 1);
}

test "parentheses preserve direct standalone iteration identity" {
    try valid(std.testing.allocator, "(" ++ scalar ++ ")", 1);
}

test "ordinary scalar returning call cannot be silently discarded" {
    try rejected("u64", "in + 1");
}

test "ordinary object returning call cannot be silently discarded" {
    try rejected("{ value: u64 }", "{ value: in }");
}

test "call returning a loop result is not a direct loop statement" {
    try rejected("u64", scalar);
}

fn allocations(allocator: std.mem.Allocator) !void {
    try valid(allocator, scalar, 1);
}

test "standalone analysis validation and emission release allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, allocations, .{});
}
