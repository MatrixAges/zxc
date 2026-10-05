const std = @import("std");
const fixture = @import("fixture.zig");
const prefix = "  const [err, res] = try native.apply(in)\n\n";

test "direct capture success branch unwraps the result" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err == null) {\n    return res\n  }\n\n  return 0" });
}

test "direct capture error branch return proves subsequent success" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return 0\n  }\n\n  return res" });
}

test "null on the left proves direct capture success" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (null == err) {\n    return res\n  }\n\n  return 0" });
}

test "negated nonnull test proves direct capture success" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (!(err != null)) {\n    return res\n  }\n\n  return 0" });
}

test "else of an error condition unwraps the result" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return 0\n  } else {\n    return res\n  }" });
}

test "conditional expression success arm unwraps the result" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  return err == null ? res : 0" });
}

test "true conjunction proves its success component" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err == null && in > 0) {\n    return res\n  }\n\n  return 0" });
}

test "false disjunction proves its success component" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err != null || in == 0) {\n    return 0\n  }\n\n  return res" });
}

test "negated disjunction proves direct capture success" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (!(err != null || in == 0)) {\n    return res\n  }\n\n  return 0" });
}

test "explicit result nonnull guard unwraps without an error association" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (res != null) {\n    return res\n  }\n\n  return 0" });
}

test "success unwraps only the outer optional result" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return null\n  }\n\n  return res", .output = "u64?", .declaration = "export declare function apply(input: u64): u64? throws { NativeFailure }\n" });
}

test "error nonnull branch permits its declared error member" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  if (err != null) {\n    return err == error.NativeFailure ? 1 : 0\n  }\n\n  return res" });
}

test "two captures preserve separate success associations" {
    try fixture.accepted(std.testing.allocator, .{ .body = prefix ++ "  const [otherErr, otherRes] = try native.apply(in)\n\n  if (err != null || otherErr != null) {\n    return 0\n  }\n\n  return res + otherRes" });
}
