const std = @import("std");
const zx = @import("zx");
const frontend = @import("compiler");
const grammar = frontend.grammar;
const Parser = frontend.Parser;
const helpers = @import("../helpers.zig");
const source = "export type Input = u64;";

fn parserFor(parsed: frontend.ParseResult, reporter: *zx.Reporter) Parser {
    return .{ .allocator = std.testing.allocator, .source = source, .tokens = parsed.value.parsed.lexed.tokens, .reporter = reporter };
}

test "grammar: sequence preserves typed token results" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);
    const rule = grammar.sequence(.{ grammar.token("export"), grammar.token("type") });
    const result = try grammar.run(rule, &parser, "expected declaration");

    try std.testing.expectEqualStrings("export", result[0].text(source));
    try std.testing.expectEqualStrings("type", result[1].text(source));
    try std.testing.expectEqual(@as(usize, 2), parser.index);
}

test "grammar: a missed sequence restores its starting cursor" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);
    const rule = grammar.sequence(.{ grammar.token("export"), grammar.token("enum") });

    try std.testing.expect(try rule.parse(&parser) == .miss);
    try std.testing.expectEqual(@as(usize, 0), parser.index);
}

test "grammar: choice tries the next alternative only after a miss" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);

    const rule = grammar.choice(.{
        grammar.sequence(.{ grammar.token("export"), grammar.token("enum") }),
        grammar.sequence(.{ grammar.token("export"), grammar.token("type") }),
    });

    try std.testing.expect(try rule.parse(&parser) == .hit);
    try std.testing.expectEqual(@as(usize, 2), parser.index);
}

test "grammar: required commits syntax errors instead of backtracking" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);

    const rule = grammar.choice(.{
        grammar.sequence(.{ grammar.token("export"), grammar.required(grammar.token("enum"), "expected enum") }),
        grammar.sequence(.{ grammar.token("export"), grammar.token("type") }),
    });

    try std.testing.expectError(error.InvalidSource, rule.parse(&parser));
    try std.testing.expectEqual(@as(usize, 1), parser.index);
    try std.testing.expectEqualStrings("expected enum", reporter.diagnostic.?.message);
}

test "grammar: optional miss consumes nothing" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);
    const result = try grammar.optional(grammar.token("enum")).parse(&parser);

    try std.testing.expect(result.hit == null);
    try std.testing.expectEqual(@as(usize, 0), parser.index);
}

test "grammar: repetitions reject empty matches" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);
    const rule = grammar.many(grammar.optional(grammar.token("enum")));

    try std.testing.expectError(error.InvalidSource, rule.parse(&parser));
    try std.testing.expectEqual(@as(@FieldType(zx.Diagnostic, "code"), .contract), reporter.diagnostic.?.code);
}

test "grammar: keyword matching does not accept identifier prefixes" {
    var parsed = try helpers.parseValid("export type constellation = u64;");

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);

    parser.source = parsed.value.parsed.source;
    parser.index = 2;

    try std.testing.expect(try grammar.token("const").parse(&parser) == .miss);
    try std.testing.expectEqual(@as(usize, 2), parser.index);
}

fn failAllocation(_: *Parser) zx.Error!zx.syntax.Token {
    return error.OutOfMemory;
}

test "grammar: choice propagates allocation failure without trying another rule" {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var reporter: zx.Reporter = .{};
    var parser = parserFor(parsed, &reporter);
    const rule = grammar.choice(.{ grammar.reference(zx.syntax.Token, failAllocation), grammar.token("export") });

    try std.testing.expectError(error.OutOfMemory, rule.parse(&parser));
    try std.testing.expect(reporter.diagnostic == null);
}

fn parseWithAllocator(allocator: std.mem.Allocator) !void {
    var parsed = try frontend.parse(allocator, "export type Input = u64; export type Output = u64; export default function (in: Input): Output { const value: u64 = in + 1; return value; }", "allocation.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);
}

test "grammar: parser frees its arena at every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, parseWithAllocator, .{});
}
