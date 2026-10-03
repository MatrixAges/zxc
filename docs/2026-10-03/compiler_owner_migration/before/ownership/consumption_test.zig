const std = @import("std");
const frontend = @import("compiler");
const helpers = @import("../helpers.zig");

fn check(body: []const u8, succeeds: bool) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = bool; export type Output = u64; export default function (in: Input): Output {{ {s} }}", .{body});

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
    try check("const first = [1, 2]; const second = first; return second[0];", true);
    try check("const first = [1, 2]; const second = first; return first[0];", false);
}

test "ownership: consuming operation invalidates the previous owner" {
    try check("const items = [1, 2]; const [next, _] = items.push(3); return next.length;", true);
    try check("const items = [1, 2]; const [next, _] = items.push(3); return items.length;", false);
}

test "ownership: branch consumption is merged onto continuing paths" {
    try check("const items = [1]; if (in) { const [next, _] = items.pop(); } return items.length;", false);
    try check("const items = [1]; if (in) { const [next, _] = items.pop(); return 0; } return items.length;", true);
}

test "ownership: independent branches may consume the same input owner" {
    try check("const items = [1]; if (in) { const [next, _] = items.pop(); return next.length; } else { const [next, _] = items.push(2); return next.length; }", true);
}

test "ownership: duplicate container fields cannot create owned aliases" {
    try check("const items = [1]; const pair = { left: items, right: items }; return 0;", false);
}

test "ownership: moving a nested container consumes its root owner" {
    try check("const object = { values: [1], count: 2 }; const values = object.values; return object.count;", false);
}

test "ownership: an escaping nested view freezes the original owner" {
    try check("const rows = [[1]]; const view = rows.filter((row) => true); const [next, _] = rows.reverse(); return view.length;", false);
}

test "ownership: a fresh scalar map output does not alias its source" {
    try check("const values = [1]; const mapped = values.map((item) => item + 1); const [next, _] = values.reverse(); return mapped[0] + next[0];", true);
}

test "ownership: clone creates an independent owner" {
    try check("const values = [1]; const copied = values.clone(); const [next, _] = copied.push(2); return values[0] + next.length;", true);
}

test "ownership: null optional preserves fallback ownership" {
    try check("const absent: u64[]? = null; const values = absent ?? [1]; const [next, _] = values.push(2); return next.length;", true);
}
