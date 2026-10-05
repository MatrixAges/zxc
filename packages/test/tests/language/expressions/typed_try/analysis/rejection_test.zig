const std = @import("std");
const fixture = @import("fixture.zig");
const prefix = "  const [err, res] = try native.apply(in)\n\n";

test "capture result requires a success or nonnull proof" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  return res" }, .{});
}

test "capture failure branch cannot treat the result as present" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return res\n  }\n\n  return 0" }, .{});
}

test "true disjunction does not prove capture success" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err == null || in > 0) {\n    return res\n  }\n\n  return 0" }, .{});
}

test "false conjunction does not prove capture success" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err != null && in > 0) {\n    return 0\n  }\n\n  return res" }, .{});
}

test "a nonterminating error branch does not prove later success" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    const ignored = in\n  }\n\n  return res" }, .{});
}

test "saved capture tuple does not regain direct destructure association" {
    try fixture.rejected(std.testing.allocator, .{ .body = "  const pair = try native.apply(in)\n\n  const [err, res] = pair\n\n  if (err != null) {\n    return 0\n  }\n\n  return res" }, .{});
}

test "ordinary tuple null guard does not associate its result" {
    try fixture.rejected(std.testing.allocator, .{ .body = "  const pair: [u64?, u64?] = [null, null]\n\n  const [err, res] = pair\n\n  if (err != null) {\n    return 0\n  }\n\n  return res" }, .{});
}

test "discarded capture error cannot establish success" {
    try fixture.rejected(std.testing.allocator, .{ .body = "  const [_, res] = try native.apply(in)\n\n  return res" }, .{});
}

test "aliased error does not transfer the capture association" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  const alias = err\n\n  if (alias != null) {\n    return 0\n  }\n\n  return res" }, .{});
}

test "guarding another capture cannot prove the first result" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  const [otherErr, _] = try native.apply(in)\n\n  if (otherErr != null) {\n    return 0\n  }\n\n  return res" }, .{});
}

test "successful optional capture still requires its inner null check" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return 0\n  }\n\n  return res", .declaration = "export declare function apply(input: u64): u64? throws { NativeFailure }\n" }, .{});
}

test "unknown native throws cannot be captured" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  return res ?? 0", .declaration = "export declare function apply(input: u64): u64 throws\n" }, .{ .message = "try requires a finite error contract; declare the native function's throws members" });
}

test "void capture result must use the discard pattern" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  return in", .declaration = "export declare function apply(input: u64): void throws { NativeFailure }\n" }, .{ .message = "void tuple results must be discarded with _" });
}

test "capture destructure must account for both slots" {
    try fixture.rejected(std.testing.allocator, .{ .body = "  const [err] = try native.apply(in)\n\n  return in" }, .{ .message = "tuple destructuring must match every result slot; use _ to discard a slot" });
}

test "error literal requires a finite error set context" {
    try fixture.rejected(std.testing.allocator, .{ .body = "  const err = error.NativeFailure\n\n  return in" }, .{ .message = "an error member requires a finite error-set context" });
}

test "misspelled error member is rejected within its finite set" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return err == error.OtherFailure ? 1 : 0\n  }\n\n  return res" }, .{ .code = .name, .message = "error is not a member of this expression's finite error set" });
}

test "empty finite error set cannot provide a named error member" {
    try fixture.rejected(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return err == error.NativeFailure ? 1 : 0\n  }\n\n  return res", .declaration = "export declare function apply(input: u64): u64 throws {}\n" }, .{ .code = .name, .message = "error is not a member of this expression's finite error set" });
}
