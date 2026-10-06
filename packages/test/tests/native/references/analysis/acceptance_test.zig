const std = @import("std");
const f = @import("fixture.zig");

test "native opaque leaf has a unique module owner and can return through an accessor" {
    try f.accepted(std.testing.allocator, .{});
}

test "native opaque leaf can be copied through local names without owning the host object" {
    try f.accepted(std.testing.allocator, .{ .body = "const node = in\n  const copy = node\n\n  return copy" });
}

test "optional native reference can preserve an existing optional input" {
    try f.accepted(std.testing.allocator, .{ .input = "Node?", .output = "Node?", .body = "return in" });
}

test "optional native reference can represent no host object" {
    try f.accepted(std.testing.allocator, .{ .output = "Node?", .body = "return null" });
}

test "local object can carry a native reference leaf and ordinary data" {
    try f.accepted(std.testing.allocator, .{ .output = "{ node: Node, count: u64 }", .body = "return { node: in, count: host.count(in) }" });
}

test "local tuple can carry repeated native reference leaves" {
    try f.accepted(std.testing.allocator, .{ .output = "[Node, Node?]", .body = "return [in, in]" });
}

test "local list buffer can carry native reference values" {
    try f.accepted(std.testing.allocator, .{ .output = "Node[]", .body = "return [in, host.identity(in)]" });
}

test "list indexing reads a reference element without indexing the opaque host object" {
    try f.accepted(std.testing.allocator, .{ .input = "Node[]", .body = "return in[0]" });
}

test "object field access reads a reference field without exposing opaque host fields" {
    try f.accepted(std.testing.allocator, .{ .input = "{ node: Node }", .body = "return in.node" });
}

test "optional native reference supports null selection without address comparison" {
    try f.accepted(std.testing.allocator, .{ .input = "{ node: Node, maybe: Node? }", .body = "return in.maybe ?? in.node" });
}

test "optional native reference can be compared with null for equality" {
    try f.accepted(std.testing.allocator, .{ .input = "Node?", .output = "bool", .body = "return in == null" });
}

test "optional native reference can be compared with null for inequality" {
    try f.accepted(std.testing.allocator, .{ .input = "Node?", .output = "bool", .body = "return in != null" });
}

test "multiple native arguments preserve the reference result source" {
    try f.accepted(std.testing.allocator, .{ .declaration = "export type Node = opaque\n\nexport declare function identity(index: u64, node: Node): Node\n", .body = "return host.identity(0, in)" });
}
