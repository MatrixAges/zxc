const std = @import("std");
const f = @import("fixture.zig");
const prefix = "const work = async (in + 1)\n";
const unsafe = "task calls require Store-free functions and an explicit native concurrency contract";

test "await rejects a scalar operand" {
    try f.rejected(std.testing.allocator, .{ .body = "return await in" }, .{ .code = .type_mismatch, .message = "await requires a task" });
}

test "task handles cannot be copied into another binding" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const copy = work\nreturn in" }, .{ .code = .ownership, .message = "a task binding must create its own task; task handles cannot be copied" });
}

test "a local task cannot be awaited twice on one path" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const first = await work\nreturn await work" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "a task awaited in one branch cannot be awaited after the merge" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "if (in == 0) { const first = await work }\nreturn await work" }, .{ .code = .ownership, .message = "the previous owner was consumed; use the new binding returned by the operation" });
}

test "task handles cannot be placed in a homogeneous list" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const values = [work, work]\nreturn in" }, .{ .code = .ownership, .message = "tasks cannot be placed in containers" });
}

test "task and scalar cannot share an inferred list element type" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const values = [work, in]\nreturn in" }, .{ .code = .type_mismatch, .message = "expression type does not match its context" });
}

test "task handles cannot be placed in an object" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const value = { work }\nreturn in" }, .{ .code = .ownership, .message = "tasks cannot be placed in objects" });
}

test "null branch cannot infer an optional task type" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const value = in == 0 ? work : null\nreturn in" }, .{ .code = .type_mismatch, .message = "null requires an optional type context" });
}

test "async cannot return another task" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async (async in)\nreturn in" }, .{ .code = .ownership, .message = "a task cannot return another task" });
}

test "a task cannot capture an outer task handle even to await it" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "const other = async (await work)\nreturn await other" }, .{ .code = .ownership, .message = "tasks cannot capture other task handles" });
}

test "try cannot wrap task creation into an optional capture result" {
    try f.rejected(std.testing.allocator, .{ .body = "const [err, res] = try async in\nreturn in" }, .{ .code = .ownership, .message = "tasks cannot be placed in containers" });
}

test "native finite errors do not imply safe task concurrency" {
    try f.rejected(std.testing.allocator, .{ .body = "return await async native.apply(in)", .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure }\n" }, .{ .code = .capability, .message = unsafe });
}

test "native io parameter does not imply safe task concurrency" {
    try f.rejected(std.testing.allocator, .{ .body = "return await async native.apply(in)", .declaration = "export declare function apply(io, input: u64): u64 throws { NativeFailure }\n" }, .{ .code = .capability, .message = unsafe });
}

test "concurrent native task still requires finite errors" {
    try f.rejected(std.testing.allocator, .{ .body = "return await async native.apply(in)", .declaration = "export declare function apply(input: u64): u64 throws concurrent\n" }, .{ .code = .type_mismatch, .message = "a task requires a finite error contract" });
}

test "task safety checks unsafe natives through an ordinary helper" {
    try f.rejected(std.testing.allocator, .{ .body = "return await async helper(in)", .imports = "import helper from \"./helper\"", .sources = &.{.{ .path = "helper.zx", .source = f.helper }}, .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure }\n" }, .{ .code = .capability, .message = unsafe });
}

test "a task cannot consume an owned list captured from its parent" {
    try f.accepted(std.testing.allocator, .{ .body = "const values = [in, in]\nconst work = async values.reverse()\nreturn in" });
}

test "parent cannot consume a captured list while a task is pending" {
    try f.accepted(std.testing.allocator, .{ .body = "const values = [in, in]\nconst work = async values[0]\nconst [changed, _] = values.reverse()\nreturn in" });
}

test "parent cannot regain consumption ownership after awaiting a capture" {
    try f.accepted(std.testing.allocator, .{ .body = "const values = [in, in]\nconst work = async values[0]\nconst result = await work\nconst [changed, _] = values.reverse()\nreturn result" });
}

test "parallel rejects a nonobject argument" {
    try f.rejected(std.testing.allocator, .{ .body = "return parallel(in)" }, .{ .code = .type_mismatch, .message = "parallel requires an object of zero-argument callbacks" });
}

test "parallel rejects branches that are not callbacks" {
    try f.rejected(std.testing.allocator, .{ .body = "const value = parallel({ first: in })\nreturn in" }, .{ .code = .type_mismatch, .message = "parallel branches must be zero-argument callbacks" });
}

test "parallel rejects callbacks with parameters" {
    try f.rejected(std.testing.allocator, .{ .body = "const value = parallel({ first: value => value })\nreturn in" }, .{ .code = .type_mismatch, .message = "parallel branches must be zero-argument callbacks" });
}

test "parallel rejects duplicate branch names" {
    try f.rejected(std.testing.allocator, .{ .body = "const value = parallel({ first: () => in, first: () => in + 1 })\nreturn in" }, .{ .code = .name, .message = "duplicate parallel branch name" });
}

test "parallel does not permit unsafe native branches" {
    try f.rejected(std.testing.allocator, .{ .body = "const value = parallel({ first: () => native.apply(in) })\nreturn in", .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure }\n" }, .{ .code = .capability, .message = unsafe });
}

test "nonvoid await statement cannot silently discard its result" {
    try f.rejected(std.testing.allocator, .{ .body = prefix ++ "await work\nreturn in" }, .{ .code = .type_mismatch, .message = "expression type does not match its context" });
}
