const std = @import("std");
const f = @import("fixture.zig");

test "unused local task remains valid for scope exit cleanup" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async (in + 1)\nreturn in" });
}

test "early return before await remains a valid cleanup path" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async (in + 1)\nif (in == 0) { return 0 }\nreturn await work" });
}

test "mutually exclusive branches may each await the same local task" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async (in + 1)\nif (in == 0) { return await work } else { return await work }" });
}

test "tasks created in independent branch scopes do not share ownership" {
    try f.accepted(std.testing.allocator, .{ .body = "if (in == 0) { const work = async (in + 1)\nreturn await work } else { const work = async (in + 2)\nreturn await work }" });
}

test "await participates in signed integer operand inference" {
    try f.accepted(std.testing.allocator, .{ .input = "i32", .output = "i32", .body = "const work = async in\nreturn 1 + await work" });
}

test "direct await async participates in float operand inference" {
    try f.accepted(std.testing.allocator, .{ .input = "f64", .output = "f64", .body = "return 1 + await async in" });
}

test "nested inline task awaits remain local to their workers" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async (await async (in + 1))\nreturn await work" });
}

test "try await success refines the captured scalar result" {
    try f.accepted(std.testing.allocator, .{ .body = "const work = async native.apply(in)\nconst [err, res] = try await work\nif (err != null) { return 0 }\nreturn res" });
}

test "try await nullable result keeps its original optional inside success" {
    try f.accepted(std.testing.allocator, .{ .output = "u64?", .declaration = "export declare function apply(input: u64): u64? throws { NativeFailure } concurrent\n", .body = "const work = async native.apply(in)\nconst [err, res] = try await work\nif (err == null) { return res } else { return null }" });
}

test "task calls can traverse a Store free concurrent native helper" {
    try f.accepted(std.testing.allocator, .{ .imports = "import helper from \"./helper\"", .sources = &.{.{ .path = "helper.zx", .source = f.helper }}, .body = "return await async helper(in)" });
}

test "captured owned list remains readable after await" {
    try f.accepted(std.testing.allocator, .{ .body = "const values = [in, in]\nconst work = async values[0]\nconst result = await work\nreturn result + values[1]" });
}

test "task list result remains a borrowed application output" {
    try f.accepted(std.testing.allocator, .{ .output = "u64[]", .body = "return await async [in, in]" });
}

test "parallel accepts only void branches as an effect statement" {
    try f.accepted(std.testing.allocator, .{ .body = "parallel({ first: () => native.effect(in), second: () => native.effect(in) })\nreturn in" });
}

test "try parallel success refines the named result object" {
    try f.accepted(std.testing.allocator, .{ .body = "const [err, res] = try parallel({ first: () => native.apply(in), second: () => native.other(in) })\nif (err != null) { return 0 }\nreturn res.first + res.second" });
}

test "void task can be awaited directly before later statements" {
    try f.accepted(std.testing.allocator, .{ .body = "await async native.effect(in)\nreturn in" });
}
