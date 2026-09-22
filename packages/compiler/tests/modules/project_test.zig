const std = @import("std");
const frontend = @import("compiler");
const project = frontend.project;

fn valid(sources: []const project.Source, entry: []const u8) !void {
    var result = try project.analyze(std.testing.allocator, sources, .{ .entry = entry, .root_dir = "/project" });

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("{s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try frontend.validateIr(std.testing.allocator, result.value.ir) == null);
}

test "modules: imported pure types share the canonical type registry" {
    try valid(&.{
        .{ .path = "types.zx", .source = "export type Value = { amount: u64; };" },
        .{ .path = "main.zx", .source = "import type { Value } from \"./types.zx\"; export type Input = Value; export type Output = Value; export default function (in: Input): Output { return in; }" },
    }, "main.zx");
}

test "modules: default function imports compose with alias paths" {
    try valid(&.{
        .{ .path = "add.zx", .source = "export type Input = u64; export type Output = u64; export default function (in: Input): Output { return in + 1; }" },
        .{ .path = "nested/main.zx", .source = "import addOne from \"@/add.zx\"; export type Input = u64; export type Output = u64; export default function (in: Input): Output { return addOne(in); }" },
    }, "nested/main.zx");
}

test "modules: imported enums are static names" {
    try valid(&.{
        .{ .path = "types.zx", .source = "export enum Mode { On, Off }" },
        .{ .path = "main.zx", .source = "import { Mode } from \"./types.zx\"; export type Input = bool; export type Output = Mode; export default function (in: Input): Output { return in ? Mode.On : Mode.Off; }" },
    }, "main.zx");
}

test "modules: unused cyclic imports are rejected" {
    var result = try project.analyze(std.testing.allocator, &.{
        .{ .path = "a.zx", .source = "import type { B } from \"./b.zx\"; export type A = u64;" },
        .{ .path = "b.zx", .source = "import type { A } from \"./a.zx\"; export type B = u64;" },
    }, .{ .entry = "a.zx" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqualStrings("module", @tagName(result.value.diagnostic.code));
}

test "modules: dependency diagnostics identify their source" {
    var result = try project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import type { Bad } from \"./bad.zx\"; export type Value = Bad;" },
        .{ .path = "bad.zx", .source = "export type Bad = Missing;" },
    }, .{ .entry = "main.zx" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(@as(?usize, 1), result.value.diagnostic.source_index);
}

test "modules: unregistered native capabilities are rejected" {
    var result = try project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = "import readFile from \"zig:fs.readFile\"; export type Input = void; export type Output = void; export default function (in: Input): Output { return; }" }}, .{ .entry = "main.zx" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqualStrings("capability", @tagName(result.value.diagnostic.code));
}

test "modules: void Input permits a call without arguments" {
    try valid(&.{
        .{ .path = "value.zx", .source = "export type Input = void; export type Output = u64; export default function (in: Input): Output { return 9; }" },
        .{ .path = "main.zx", .source = "import value from \"./value.zx\"; export type Input = void; export type Output = u64; export default function (in: Input): Output { return value(); }" },
    }, "main.zx");
}

fn projectAllocationFailures(allocator: std.mem.Allocator) !void {
    var result = try project.analyze(allocator, &.{
        .{ .path = "value.zx", .source = "export type Input = u64; export type Output = u64; export default function (in: Input): Output { return in + 1; }" },
        .{ .path = "main.zx", .source = "import value from \"./value.zx\"; export type Input = u64; export type Output = u64; export default function (in: Input): Output { return value(in); }" },
    }, .{ .entry = "main.zx" });

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
}

test "modules: allocation failures release parsed dependency arenas" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, projectAllocationFailures, .{});
}
