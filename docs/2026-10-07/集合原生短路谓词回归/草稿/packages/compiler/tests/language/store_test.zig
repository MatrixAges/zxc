const std = @import("std");
const frontend = @import("compiler");
const zx = @import("zx");
const helpers = @import("../helpers.zig");

fn check(body: []const u8, context: frontend.Context, expected: ?@FieldType(zx.Diagnostic, "code")) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "export type State = {{ count: u64\n items: u64[] }}\n export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output {{ {s} }}", .{body});

    defer std.testing.allocator.free(source);

    var parsed = try helpers.parseValid(source);

    defer parsed.deinit();

    var analyzed = try frontend.analyzeWithContext(std.testing.allocator, parsed.value.parsed, context);

    defer analyzed.deinit();

    if (expected) |code| {
        try std.testing.expect(analyzed.value == .diagnostic);
        try std.testing.expectEqual(code, analyzed.value.diagnostic.code);
    } else {
        if (analyzed.value == .diagnostic) std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});
        try std.testing.expect(analyzed.value == .ir);
        try std.testing.expect(try frontend.validateIr(std.testing.allocator, analyzed.value.ir) == null);
    }
}

const writable = frontend.Context{ .stores = &.{.{ .handle = "$state", .path = "store.orders.state", .type_name = "State" }} };

test "store: only Call-injected handles are visible" {
    try check("return $state.value.count\n", .{}, .capability);
    try check("return $state.value.count\n", writable, null);
}

test "store: read-only and write-only permissions are separate" {
    try check("$state.value = { count: 1, items: in }\n return 0\n", .{ .stores = &.{.{ .handle = "$state", .path = "store.orders.state", .type_name = "State", .writable = false }} }, .capability);
    try check("return $state.value.count\n", .{ .stores = &.{.{ .handle = "$state", .path = "store.orders.state", .type_name = "State", .readable = false }} }, .capability);
}

test "store: nested field writes cannot bypass the whole Object setter" {
    try check("$state.value.count = 2\n return 0\n", writable, .capability);
}

test "store: callbacks cannot capture injected handles" {
    try check("const values = in.map((item) => $state.value.count)\n return values.length\n", writable, .capability);
}

test "store: getter lists permit persistent updates without changing the stored value" {
    try check("const [next, _] = $state.value.items.reverse()\n return next.length + $state.value.items.length\n", writable, null);
}

test "store: getter data cannot be deep copied" {
    try check("const items = $state.value.items.clone()\n return items.length\n", writable, .unsupported);
}

test "store: scalar getter values can initialize a separate owner" {
    try check("const items: u64[] = [$state.value.count]\n const [next, _] = items.reverse()\n return next.length + $state.value.items.length\n", writable, null);
}

test "store: publishing a local value permits persistent derivations" {
    try check("const state = { count: 1, items: [2] }\n $state.value = state\n return state.count\n", writable, null);
    try check("const state = { count: 1, items: [2] }\n $state.value = state\n const [next, _] = state.items.reverse()\n return next.length + state.items.length + $state.value.items.length\n", writable, null);
}

test "store: injected handles cannot be rebound as ordinary const values" {
    try check("const $state = 1\n return 0\n", writable, .name);
}
