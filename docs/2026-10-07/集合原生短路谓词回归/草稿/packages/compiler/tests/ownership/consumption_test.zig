const std = @import("std");
const frontend = @import("compiler");
const helpers = @import("../helpers.zig");

fn check(body: []const u8) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = bool\n export type Output = u64\n export default function (in: Input): Output {{ {s} }}", .{body});

    defer std.testing.allocator.free(source);

    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});
    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expect(try frontend.validateIr(std.testing.allocator, analyzed.value.ir) == null);
}

test "ownership: assignment preserves both list references" {
    try check("const first = [1, 2]\n const second = first\n return second[0]\n");
    try check("const first = [1, 2]\n const second = first\n return first[0] + second[0]\n");
}

test "ownership: persistent update preserves the previous list" {
    try check("const items = [1, 2]\n const [next, _] = items.push(3)\n return next.length\n");
    try check("const items = [1, 2]\n const [next, _] = items.push(3)\n return items.length + next.length\n");
}

test "ownership: branch updates preserve the original list on continuing paths" {
    try check("const items = [1]\n if (in) { const [next, _] = items.pop() } return items.length\n");
    try check("const items = [1]\n if (in) { const [next, _] = items.pop()\n return 0 } return items.length\n");
}

test "ownership: independent branches may derive values from the same list" {
    try check("const items = [1]\n if (in) { const [next, _] = items.pop()\n return next.length } else { const [next, _] = items.push(2)\n return next.length }");
}

test "ownership: duplicate container fields share immutable values" {
    try check("const items = [1]\n const pair = { left: items, right: items }\n return pair.left[0] + pair.right[0]\n");
}

test "ownership: reading a nested field preserves independent siblings" {
    try check("const object = { values: [1], count: 2 }\n const values = object.values\n return object.count\n");
}

test "ownership: nested fields and their parent remain readable" {
    try check("const object = { values: [1], count: 2 }\n const values = object.values\n return object.values[0] + values[0]\n");
    try check("const object = { values: [1], count: 2 }\n const values = object.values\n const copy = object\n return copy.count + values[0]\n");
}

test "ownership: an escaping nested view permits persistent updates" {
    try check("const rows = [[1]]\n const view = rows.filter((row) => true)\n const [next, _] = rows.reverse()\n return view[0][0] + next[0][0] + rows[0][0]\n");
}

test "ownership: a fresh scalar map output does not alias its source" {
    try check("const values = [1]\n const mapped = values.map((item) => item + 1)\n const [next, _] = values.reverse()\n return mapped[0] + next[0]\n");
}

test "ownership: clone cannot create an independent owner" {
    try helpers.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n return values.clone() }", .unsupported);
}

test "ownership: separately constructed scalar lists have independent owners" {
    try check("const values = [1]\n const separate = [values[0]]\n const [next, _] = separate.push(2)\n return values[0] + next.length\n");
}

test "ownership: null optional preserves fallback ownership" {
    try check("const absent: u64[]? = null\n const values = absent ?? [1]\n const [next, _] = values.push(2)\n return next.length\n");
}
