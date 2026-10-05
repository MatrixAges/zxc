const std = @import("std");
const fixture = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");

test "native declaration without throws remains infallible" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64\n", .fallible = false });
}

test "bare native throws retains an explicitly unknown error set" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws\n", .fallible = true });
}

test "empty finite native throws differs from an unknown error set" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws {}\n", .fallible = true, .errors = &.{} });
}

test "finite native throws retains its declared member" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure }\n", .fallible = true, .errors = &.{"NativeFailure"} });
}

test "finite native throws retains multiple members independent of declaration order" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { ZetaFailure, AlphaFailure }\n", .fallible = true, .errors = &.{ "AlphaFailure", "ZetaFailure" } });
}

test "finite native throws accepts whitespace and trailing comma" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws {\n  NativeFailure,\n}\n", .fallible = true, .errors = &.{"NativeFailure"} });
}

test "finite native throws preserves allocator injection" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(allocator, input: u64): u64 throws { OutOfMemory }\n", .fallible = true, .errors = &.{"OutOfMemory"}, .allocating = true });
}

test "IO injection does not implicitly promise concurrent invocation" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(io, input: u64): u64 throws { IoFailure }\n", .fallible = true, .errors = &.{"IoFailure"}, .io = true });
}

test "explicit concurrent native declaration preserves infallibility" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 concurrent\n", .fallible = false, .concurrent = true });
}

test "explicit concurrent native declaration preserves finite errors and IO" {
    try fixture.accepted(std.testing.allocator, .{ .declaration = "export declare function apply(io, input: u64): u64 throws { IoFailure } concurrent\n", .fallible = true, .errors = &.{"IoFailure"}, .io = true, .concurrent = true });
}

test "finite concurrent native contract releases every failed allocation" {
    const case: fixture.Contract = .{ .declaration = "export declare function apply(allocator, io, input: u64): u64 throws { OutOfMemory, NativeFailure } concurrent\n", .fallible = true, .errors = &.{ "OutOfMemory", "NativeFailure" }, .allocating = true, .io = true, .concurrent = true };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.accepted, .{case});
}
