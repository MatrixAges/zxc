const std = @import("std");
const compiler = @import("compiler");
const main_source = "import left from \"./left.zx\"; import right from \"./right.zx\"; export type Input = u8; export type Output = u64; export default function (in: Input): Output { return match left(in) { right(in) => 11, _ => 22 }; }";
const enum_source = "export enum State { First, Second }";
const left_source = "import { State } from \"./left_types.zx\"; export type Input = u8; export type Output = State; export default function (in: Input): Output { return State.First; }";

fn check(shared: bool) !void {
    const right_source = if (shared)
        "import { State } from \"./left_types.zx\"; export type Input = u8; export type Output = State; export default function (in: Input): Output { return State.First; }"
    else
        "import { State } from \"./right_types.zx\"; export type Input = u8; export type Output = State; export default function (in: Input): Output { return State.First; }";

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = main_source },
        .{ .path = "left.zx", .source = left_source },
        .{ .path = "right.zx", .source = right_source },
        .{ .path = "left_types.zx", .source = enum_source },
        .{ .path = "right_types.zx", .source = enum_source },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    if (shared) {
        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
    } else {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.type_mismatch, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);

        const start = std.mem.indexOf(u8, main_source, "right(in)").?;

        try std.testing.expectEqual(start, result.value.diagnostic.span.start);
        try std.testing.expectEqual(start + "right(in)".len, result.value.diagnostic.span.end);
    }
}

test "match rejects separately declared same name enums across modules" {
    try check(false);
}

test "match accepts helpers sharing the same enum declaration" {
    try check(true);
}
