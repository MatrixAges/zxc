const std = @import("std");
const fixture = @import("fixture.zig");
const allocation_testing = @import("allocation_testing");

test "native error members reject lower camelCase names" {
    try fixture.rejected(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { nativeFailure }\n", .code = .naming, .message = "error names must use PascalCase" });
}

test "native error members reject snake_case names" {
    try fixture.rejected(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { Native_Failure }\n", .code = .naming, .message = "error names must use PascalCase" });
}

test "native error members reject duplicates" {
    try fixture.rejected(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure, NativeFailure }\n", .code = .name, .message = "duplicate native error name" });
}

test "native error members cannot be quoted strings" {
    try fixture.rejected(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { \"NativeFailure\" }\n", .code = .syntax });
}

test "finite native throws requires its closing brace" {
    try fixture.rejected(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure\n", .code = .syntax });
}

test "native concurrent marker cannot be repeated" {
    try fixture.rejected(std.testing.allocator, .{ .declaration = "export declare function apply(input: u64): u64 concurrent concurrent\n", .code = .syntax });
}

test "finite native declaration rejection releases every failed allocation" {
    const case: fixture.Failure = .{ .declaration = "export declare function apply(input: u64): u64 throws { NativeFailure, NativeFailure }\n", .code = .name, .message = "duplicate native error name" };

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, fixture.rejected, .{case});
}
