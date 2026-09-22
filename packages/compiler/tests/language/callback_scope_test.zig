const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const helpers = @import("../helpers.zig");

fn check(source: []const u8, expected: ?@FieldType(zx.Diagnostic, "code")) !void {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    if (expected) |code| {
        try std.testing.expect(analyzed.value == .diagnostic);
        try std.testing.expectEqual(code, analyzed.value.diagnostic.code);
    } else if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("unexpected diagnostic {t}: {s}\n", .{ issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }
}

test "zx-callback-scope: explicit map parameter is visible" {
    try check("export type Input = u64[]; export type Output = u64[]; export default function (in: Input): Output { return in.map((item) => item + 1); }", null);
}

test "zx-callback-scope: outer const is not captured" {
    try check("export type Input = u64[]; export type Output = u64[]; export default function (in: Input): Output { const offset = 1; return in.map((item) => item + offset); }", .ownership);
}

test "zx-callback-scope: function input is not captured" {
    try check("export type Input = { items: u64[]; offset: u64; }; export type Output = u64[]; export default function (in: Input): Output { return in.items.map((item) => item + in.offset); }", .ownership);
}

test "zx-callback-scope: same named parameter shadows outer binding" {
    try check("export type Input = u64[]; export type Output = u64[]; export default function (in: Input): Output { const item = 100; return in.map((item) => item + 1); }", null);
}

test "zx-callback-scope: nested callbacks have independent parameter scopes" {
    try check("export type Input = u64[][]; export type Output = u64[][]; export default function (in: Input): Output { return in.map((row) => row.map((item) => item + 1)); }", null);
}

test "zx-callback-scope: inner callback cannot capture outer callback parameter" {
    try check("export type Input = u64[][]; export type Output = u64[][]; export default function (in: Input): Output { return in.map((row) => row.map((item) => row[0])); }", .ownership);
}

test "zx-callback-scope: leaving nested callback restores enclosing scope" {
    try check("export type Input = u64[][]; export type Output = u64[]; export default function (in: Input): Output { return in.map((row) => row.reduce((sum, item) => sum + item, 0) + row[0]); }", null);
}

test "zx-callback-scope: reduce initial value is evaluated outside callback" {
    try check("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const initial = 10; return in.reduce((sum, item) => sum + item, initial); }", null);
}

test "zx-callback-scope: reduce body cannot capture its initial binding" {
    try check("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const initial = 10; return in.reduce((sum, item) => sum + initial, initial); }", .ownership);
}

test "zx-callback-scope: duplicate parameters are rejected" {
    try check("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { return in.reduce((item, item) => item, 0); }", .name);
}

test "zx-callback-scope: callback cannot be stored as a value" {
    try check("export type Input = u64; export type Output = u64; export default function (in: Input): Output { const callback = (item) => item; return in; }", .unsupported);
}

test "zx-callback-scope: outer scope is restored after map" {
    try check("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const offset = 4; const values = in.map((item) => item + 1); return offset; }", null);
}

test "zx-callback-scope: static enum names do not capture values" {
    try check("export enum Mode { On, Off } export type Input = u64[]; export type Output = Mode[]; export default function (in: Input): Output { return in.map((item) => Mode.On); }", null);
}

test "zx-callback-scope: sibling callback cannot read a previous callback parameter" {
    try check("export type Input = u64[]; export type Output = u64[]; export default function (in: Input): Output { return in.map((item) => item + 1).map((next) => item); }", .name);
}

fn analyzeWithAllocator(allocator: std.mem.Allocator) !void {
    var parsed = try compiler.parse(allocator, "export type Input = u64[][]; export type Output = u64[]; export default function (in: Input): Output { return in.map((row) => row.reduce((sum, item) => sum + item, 0)); }", "allocation.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
}

test "zx-callback-scope: nested analysis frees allocations on failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, analyzeWithAllocator, .{});
}
