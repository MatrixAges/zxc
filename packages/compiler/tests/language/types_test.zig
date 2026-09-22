const std = @import("std");
const frontend = @import("compiler");
const helpers = @import("../helpers.zig");

fn check(source: []const u8, succeeds: bool) !void {
    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    if (succeeds) {
        if (analyzed.value == .diagnostic) std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});
        try std.testing.expect(analyzed.value == .ir);
        try std.testing.expect(try frontend.validateIr(std.testing.allocator, analyzed.value.ir) == null);
    } else try std.testing.expect(analyzed.value == .diagnostic);
}

test "types: fixed width integer boundaries are enforced before generation" {
    const Case = struct { type_name: []const u8, accepted: []const u8, rejected: []const u8 };

    for ([_]Case{
        .{ .type_name = "u8", .accepted = "255", .rejected = "256" },
        .{ .type_name = "u16", .accepted = "65535", .rejected = "65536" },
        .{ .type_name = "u32", .accepted = "4294967295", .rejected = "4294967296" },
        .{ .type_name = "u64", .accepted = "18446744073709551615", .rejected = "18446744073709551616" },
        .{ .type_name = "i32", .accepted = "-2147483648", .rejected = "-2147483649" },
        .{ .type_name = "i64", .accepted = "-9223372036854775808", .rejected = "9223372036854775808" },
    }) |case| {
        for ([_][]const u8{ case.accepted, case.rejected }, 0..) |literal, index| {
            const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = void; export type Output = {s}; export default function (in: Input): Output {{ return {s}; }}", .{ case.type_name, literal });

            defer std.testing.allocator.free(source);

            try check(source, index == 0);
        }
    }
}

test "types: missing optional object fields become none" {
    try check("export type Input = void; export type Output = { value: u64?; }; export default function (in: Input): Output { return {}; }", true);
    try check("export type Input = void; export type Output = { value: u64; }; export default function (in: Input): Output { return {}; }", false);
}

test "types: tuple destructuring is explicit and arity checked" {
    try check("export type Input = void; export type Output = u64; export default function (in: Input): Output { const tuple: [u64, bool] = [1, true]; const [value, _] = tuple; return value; }", true);
    try check("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const next = values.push(2); return next.length; }", false);
    try check("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next] = values.pop(); return next.length; }", false);
}

test "types: optional containers and recursively nested aliases are distinct" {
    try check("export type Input = u64?[]; export type Output = u64[]?; export default function (in: Input): Output { return in; }", false);
    try check("export type Loop = { next: Loop?; };", false);
}

test "types: switch labels reject duplicate values and require total return paths" {
    try check("export type Input = i64; export type Output = bool; export default function (in: Input): Output { switch (in) { case 0: return true; case -0: return false; default: return true; } }", false);
    try check("export type Input = bool; export type Output = u64; export default function (in: Input): Output { switch (in) { case true: return 1; case false: return 0; } }", true);
    try check("export type Input = bool; export type Output = u64; export default function (in: Input): Output { switch (in) { case true: return 1; } }", false);
}

test "types: empty lists and null require unambiguous contexts" {
    try check("export type Input = void; export type Output = u64[]; export default function (in: Input): Output { return []; }", true);
    try check("export type Input = void; export type Output = u64; export default function (in: Input): Output { const value = null; return 0; }", false);
    try check("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = []; return 0; }", false);
}

test "types: integer to float literal precision matches native Zig" {
    try check("export type Input = void; export type Output = f32; export default function (in: Input): Output { return 16777217; }", false);
    try check("export type Input = void; export type Output = f64; export default function (in: Input): Output { return 9007199254740993; }", false);
    try check("export type Input = void; export type Output = f64; export default function (in: Input): Output { return 18446744073709551616; }", true);
    try check("export type Input = void; export type Output = f32; export default function (in: Input): Output { return 16777217.0; }", true);
}

test "types: coalesce uses its payload type inside arithmetic" {
    try check("export type Input = u64?; export type Output = u64; export default function (in: Input): Output { return (in ?? 0) + 1; }", true);
}
