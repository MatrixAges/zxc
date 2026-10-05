const std = @import("std");
const frontend = @import("compiler");
const helpers = @import("../helpers.zig");

fn check(body: []const u8, succeeds: bool) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = bool\n export type Output = u64\n export default function (in: Input): Output {{ {s} }}", .{body});

    defer std.testing.allocator.free(source);

    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    if (succeeds) {
        if (analyzed.value == .diagnostic) std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});
        try std.testing.expect(analyzed.value == .ir);
        try std.testing.expect(try frontend.validateIr(std.testing.allocator, analyzed.value.ir) == null);
    } else {
        try std.testing.expect(analyzed.value == .diagnostic);
        try std.testing.expectEqualStrings("ownership", @tagName(analyzed.value.diagnostic.code));
    }
}

test "ownership: assignment transfers an owned list" {
    try check("const first = [1, 2]\n const second = first\n return second[0]\n", true);
    try check("const first = [1, 2]\n const second = first\n return first[0]\n", false);
}

test "ownership: consuming operation invalidates the previous owner" {
    try check("const items = [1, 2]\n const [next, _] = items.push(3)\n return next.length\n", true);
    try check("const items = [1, 2]\n const [next, _] = items.push(3)\n return items.length\n", false);
}

test "ownership: branch consumption is merged onto continuing paths" {
    try check("const items = [1]\n if (in) { const [next, _] = items.pop() } return items.length\n", false);
    try check("const items = [1]\n if (in) { const [next, _] = items.pop()\n return 0 } return items.length\n", true);
}

test "ownership: independent branches may consume the same input owner" {
    try check("const items = [1]\n if (in) { const [next, _] = items.pop()\n return next.length } else { const [next, _] = items.push(2)\n return next.length }", true);
}

test "ownership: duplicate container fields cannot create owned aliases" {
    try check("const items = [1]\n const pair = { left: items, right: items }\n return 0\n", false);
}

test "ownership: moving a nested field preserves independent siblings" {
    try check("const object = { values: [1], count: 2 }\n const values = object.values\n return object.count\n", true);
}

test "ownership: moved fields and their incomplete parent cannot be reused" {
    try check("const object = { values: [1], count: 2 }\n const values = object.values\n return object.values[0]\n", false);
    try check("const object = { values: [1], count: 2 }\n const values = object.values\n const copy = object\n return copy.count\n", false);
}

test "ownership: an escaping nested view freezes the original owner" {
    try check("const rows = [[1]]\n const view = rows.filter((row) => true)\n const [next, _] = rows.reverse()\n return view.length\n", false);
}

test "ownership: a fresh scalar map output does not alias its source" {
    try check("const values = [1]\n const mapped = values.map((item) => item + 1)\n const [next, _] = values.reverse()\n return mapped[0] + next[0]\n", true);
}

test "ownership: clone cannot create an independent owner" {
    try helpers.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values = [1]\n return values.clone() }", .unsupported);
}

test "ownership: separately constructed scalar lists have independent owners" {
    try check("const values = [1]\n const separate = [values[0]]\n const [next, _] = separate.push(2)\n return values[0] + next.length\n", true);
}

test "ownership: null optional preserves fallback ownership" {
    try check("const absent: u64[]? = null\n const values = absent ?? [1]\n const [next, _] = values.push(2)\n return next.length\n", true);
}
