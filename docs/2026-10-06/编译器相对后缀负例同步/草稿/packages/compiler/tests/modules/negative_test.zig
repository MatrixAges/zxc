const std = @import("std");
const frontend = @import("compiler");
const zx = @import("zx");

fn reject(main: []const u8, dependency: []const u8, code: @FieldType(zx.Diagnostic, "code")) !void {
    var result = try frontend.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = main },
        .{ .path = "dep.zx", .source = dependency },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(code, result.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
}

test "modules negative: missing dependency" {
    try reject("import type { Value } from \"./absent\"\n export type Result = Value\n", "export type Value = u64\n", .module);
}

test "modules negative: missing exported name" {
    try reject("import type { Missing } from \"./dep\"\n export type Result = Missing\n", "export type Value = u64\n", .module);
}

test "modules negative: value import must be enum" {
    try reject("import { Value } from \"./dep\"\n export type Result = Value\n", "export type Value = u64\n", .module);
}

test "modules negative: default import requires executable" {
    try reject("import compute from \"./dep\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", "export type Value = u64\n", .module);
}

test "modules negative: type import requires pure file" {
    try reject("import type { Input } from \"./dep\"\n export type Value = Input\n", "export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", .module);
}

test "modules negative: duplicate imported binding" {
    try reject("import type { Value } from \"./dep\"\n import type { Value } from \"./dep\"\n export type Result = Value\n", "export type Value = u64\n", .name);
}

test "modules negative: relative extension rejected" {
    try reject("import type { Value } from \"./dep.zx\"\n export type Result = Value\n", "export type Value = u64\n", .module);
}

test "modules negative: bare path rejected" {
    try reject("import type { Value } from \"dep.zx\"\n export type Result = Value\n", "export type Value = u64\n", .module);
}

test "modules negative: RX import rejected" {
    try reject("import type { Value } from \"./dep.rx\"\n export type Result = Value\n", "export type Value = u64\n", .module);
}

test "modules negative: call missing input" {
    try reject("import compute from \"./dep\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return compute() }", "export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", .type_mismatch);
}

test "modules negative: call excess arguments" {
    try reject("import compute from \"./dep\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return compute(in, in) }", "export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", .type_mismatch);
}

test "modules negative: call wrong input" {
    try reject("import compute from \"./dep\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return compute(true) }", "export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", .type_mismatch);
}

test "modules negative: local value shadows function" {
    try reject("import compute from \"./dep\"\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { const compute = 1\n return compute(in) }", "export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }", .type_mismatch);
}
