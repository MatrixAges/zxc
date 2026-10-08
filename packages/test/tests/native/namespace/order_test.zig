const std = @import("std");
const f = @import("fixture.zig");

test "invalid namespace short circuits unknown native parameter types" {
    try f.check(std.testing.allocator, .{ .namespace = &.{""}, .declaration = "export declare function apply(input: Missing): u64\n", .expected = .module });
}

test "invalid namespace short circuits unknown native output types" {
    try f.check(std.testing.allocator, .{ .namespace = &.{""}, .declaration = "export declare function apply(input: u64): Missing\n", .expected = .module });
}

test "invalid namespace short circuits explicit void parameter rejection" {
    try f.check(std.testing.allocator, .{ .namespace = &.{""}, .declaration = "export declare function apply(input: void): u64\n", .expected = .module });
}

test "valid namespace exposes unknown signature types" {
    try f.check(std.testing.allocator, .{ .namespace = &.{"valid"}, .declaration = "export declare function apply(input: Missing): u64\n", .expected = .name });
}

test "valid namespace exposes explicit void parameter rejection" {
    try f.check(std.testing.allocator, .{ .namespace = &.{"valid"}, .declaration = "export declare function apply(input: void): u64\n", .expected = .type_mismatch });
}

test "native declaration syntax precedes namespace validation" {
    try f.check(std.testing.allocator, .{ .namespace = &.{""}, .declaration = "export declare function apply(input: u64): u64;", .expected = .syntax });
}

test "native declaration naming precedes namespace validation" {
    try f.check(std.testing.allocator, .{ .namespace = &.{""}, .declaration = "export declare function BadName(input: u64): u64\n", .expected = .naming });
}

test "native exported alias resolution precedes namespace validation" {
    try f.check(std.testing.allocator, .{ .namespace = &.{""}, .declaration = "export type Bad = Missing\n\nexport declare function apply(input: u64): u64\n", .expected = .name });
}
