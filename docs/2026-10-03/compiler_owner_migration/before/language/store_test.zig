const std = @import("std");
const frontend = @import("compiler");
const zx = @import("zx");
const helpers = @import("../helpers.zig");

fn check(body: []const u8, context: frontend.Context, expected: ?@FieldType(zx.Diagnostic, "code")) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "export type State = {{ count: u64; items: u64[]; }}; export type Input = u64[]; export type Output = u64; export default function (in: Input): Output {{ {s} }}", .{body});

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
    try check("return $state.value.count;", .{}, .capability);
    try check("return $state.value.count;", writable, null);
}

test "store: read-only and write-only permissions are separate" {
    try check("$state.value = { count: 1, items: in }; return 0;", .{ .stores = &.{.{ .handle = "$state", .path = "store.orders.state", .type_name = "State", .writable = false }} }, .capability);
    try check("return $state.value.count;", .{ .stores = &.{.{ .handle = "$state", .path = "store.orders.state", .type_name = "State", .readable = false }} }, .capability);
}

test "store: nested field writes cannot bypass the whole Object setter" {
    try check("$state.value.count = 2; return 0;", writable, .capability);
}

test "store: callbacks cannot capture injected handles" {
    try check("const values = in.map((item) => $state.value.count); return values.length;", writable, .capability);
}

test "store: getter list data cannot be consumed without owning it" {
    try check("const [next, _] = $state.value.items.reverse(); return next.length;", writable, .ownership);
    try check("const items = $state.value.items.clone(); const [next, _] = items.reverse(); return next.length;", writable, null);
}

test "store: publishing a local owner permits reading but freezes consumption" {
    try check("const state = { count: 1, items: [2] }; $state.value = state; return state.count;", writable, null);
    try check("const state = { count: 1, items: [2] }; $state.value = state; const [next, _] = state.items.reverse(); return 0;", writable, .ownership);
}

test "store: injected handles cannot be rebound as ordinary const values" {
    try check("const $state = 1; return 0;", writable, .name);
}
