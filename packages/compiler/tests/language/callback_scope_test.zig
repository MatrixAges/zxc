const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const helpers = @import("../helpers.zig");

fn check(source: []const u8, expected: ?@FieldType(zx.Diagnostic, "code")) !void {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var analyzed = try helpers.analyze(std.testing.allocator, parsed.value.parsed);

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
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return map(in, (item) => item + 1) }", null);
}

test "zx-callback-scope: utils map carries an outer const in loop context" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { const offset = 1\n return map(in, (item) => item + offset) }", null);
}

test "zx-callback-scope: utils map borrows function input in loop context" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = { items: u64[]\n offset: u64 }\n export type Output = u64[]\n export default function (in: Input): Output { return map(in.items, (item) => item + in.offset) }", null);
}

test "zx-callback-scope: same named parameter shadows outer binding" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { const item = 100\n return map(in, (item) => item + 1) }", null);
}

test "zx-callback-scope: nested callbacks have independent parameter scopes" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[][]\n export type Output = u64[][]\n export default function (in: Input): Output { return map(in, (row) => map(row, (item) => item + 1)) }", null);
}

test "zx-callback-scope: nested utils map borrows outer loop context" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[][]\n export type Output = u64[][]\n export default function (in: Input): Output { return map(in, (row) => map(row, (item) => row[0])) }", null);
}

test "zx-callback-scope: leaving nested callback restores enclosing scope" {
    try check("import { map, reduce } from \"std:utils\"\n\nexport type Input = u64[][]\n export type Output = u64[]\n export default function (in: Input): Output { return map(in, (row) => reduce(row, (sum, item) => sum + item, 0) + row[0]) }", null);
}

test "zx-callback-scope: reduce initial value is evaluated outside callback" {
    try check("import { reduce } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const initial = 10\n return reduce(in, (sum, item) => sum + item, initial) }", null);
}

test "zx-callback-scope: utils reduce borrows its initial binding in loop context" {
    try check("import { reduce } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const initial = 10\n return reduce(in, (sum, item) => sum + initial, initial) }", null);
}

test "zx-callback-scope: duplicate parameters are rejected" {
    try check("import { reduce } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { return reduce(in, (item, item) => item, 0) }", .name);
}

test "zx-callback-scope: callback cannot be stored as a value" {
    try check("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { const callback = (item) => item\n return in }", .unsupported);
}

test "zx-callback-scope: outer scope is restored after map" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const offset = 4\n const values = map(in, (item) => item + 1)\n return offset }", null);
}

test "zx-callback-scope: static enum names do not capture values" {
    try check("import { map } from \"std:utils\"\n\nexport enum Mode { On, Off } export type Input = u64[]\n export type Output = Mode[]\n export default function (in: Input): Output { return map(in, (item) => Mode.On) }", null);
}

test "zx-callback-scope: sibling callback cannot read a previous callback parameter" {
    try check("import { map } from \"std:utils\"\n\nexport type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return map(map(in, (item) => item + 1), (next) => item) }", .name);
}

fn analyzeWithAllocator(allocator: std.mem.Allocator) !void {
    var parsed = try compiler.parse(allocator, "import { map, reduce } from \"std:utils\"\n\nexport type Input = u64[][]\n export type Output = u64[]\n export default function (in: Input): Output { return map(in, (row) => reduce(row, (sum, item) => sum + item, 0)) }", "allocation.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try helpers.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
}

test "zx-callback-scope: nested analysis frees allocations on failure" {
    var vtable = std.testing.allocator.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    const allocator: std.mem.Allocator = .{ .ptr = std.testing.allocator.ptr, .vtable = &vtable };

    try std.testing.checkAllAllocationFailures(allocator, analyzeWithAllocator, .{});
}
