const std = @import("std");
const compiler = @import("compiler");
const Mode = enum { owned, borrowed_first, borrowed_fallback };
const make = "export type Input = u64\n export type Output = u64[]\n export default function (in: Input): Output { return [in, in + 1] }";
const borrow = "export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { return in }";

fn check(mode: Mode) !void {
    const first = if (mode == .borrowed_first) "borrow(in.items)" else "make(in.value)";
    const fallback = if (mode == .borrowed_fallback) "borrow(in.items)" else "make(in.value)";

    const source = try std.fmt.allocPrint(
        std.testing.allocator,
        "import make from \"./make\"\n import borrow from \"./borrow\"\n " ++
            "export type Input = {{ choice: bool\n value: u64\n items: u64[] }}\n export type Output = u64[]\n " ++
            "export default function (in: Input): Output {{ const values = match in.choice {{ true => {s}, _ => {s} }}\n " ++
            "const [next, _] = values.reverse()\n return next }}",
        .{ first, fallback },
    );

    defer std.testing.allocator.free(source);

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "make.zx", .source = make },
        .{ .path = "borrow.zx", .source = borrow },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(.owned, result.value.ir.output_ownership);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
}

test "match reverses newly allocated arm results into a new list" {
    try check(.owned);
}

test "match reverses a borrowed first arm result into a new list" {
    try check(.borrowed_first);
}

test "match reverses a borrowed fallback result into a new list" {
    try check(.borrowed_fallback);
}
