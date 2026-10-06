const std = @import("std");
const f = @import("fixture.zig");
const prefix = "export type Node = opaque\n\n";

test "native reference result cannot be created by a zero argument accessor" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(): Node\n" }, .{ .code = .ownership, .message = "native reference results require a host reference input", .native = true });
}

test "native reference result cannot be created from ordinary scalar data" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(value: u64): Node\n" }, .{ .code = .ownership, .message = "native reference results require a host reference input", .native = true });
}

test "native optional reference result still requires a host reference input" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(value: u64): Node?\n" }, .{ .code = .ownership, .message = "native reference results require a host reference input", .native = true });
}

test "native nested reference result still requires a host reference input" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(value: u64): { nodes: Node?[] }\n" }, .{ .code = .ownership, .message = "native reference results require a host reference input", .native = true });
}

test "native reference inputs cannot declare concurrent access" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(node: Node): u64 concurrent\n" }, .{ .code = .capability, .message = "host reference accessors cannot declare concurrency", .native = true });
}

test "native nested reference inputs cannot declare concurrent access" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(input: { nodes: Node?[] }): u64 concurrent\n" }, .{ .code = .capability, .message = "host reference accessors cannot declare concurrency", .native = true });
}

test "native nested reference outputs cannot declare concurrent access" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(node: Node): [u64, Node?] concurrent\n" }, .{ .code = .capability, .message = "host reference accessors cannot declare concurrency", .native = true });
}

test "native nested reference input permits a reference result" {
    try f.accepted(std.testing.allocator, .{ .input = "{ nodes: Node[] }", .declaration = prefix ++ "export declare function identity(input: { nodes: Node[] }): Node\n" });
}

test "native opaque recognition does not extend to optional opaque syntax" {
    try f.rejected(std.testing.allocator, .{ .declaration = "export type Node = opaque?\n\nexport declare function identity(node: Node): Node\n" }, .{ .code = .name, .message = "unknown or unsupported type", .native = true });
}

test "native opaque recognition requires a named type declaration" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(node: opaque): u64\n" }, .{ .code = .name, .message = "unknown or unsupported type", .native = true });
}

test "multiple scalar arguments cannot establish a native reference result source" {
    try f.rejected(std.testing.allocator, .{ .declaration = prefix ++ "export declare function identity(index: u64, value: u64): Node\n" }, .{ .code = .ownership, .message = "native reference results require a host reference input", .native = true });
}

test "native optional reference input permits an optional reference result" {
    try f.accepted(std.testing.allocator, .{ .input = "Node?", .output = "Node?", .declaration = prefix ++ "export declare function identity(node: Node?): Node?\n" });
}
