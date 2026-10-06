const std = @import("std");
const f = @import("fixture.zig");

test "Gateway service generation rejects a native reference signature" {
    try f.gateway(std.testing.allocator, "Node", true);
}

test "Gateway service generation rejects nested optional reference list fields" {
    try f.gateway(std.testing.allocator, "{ nodes: [u64, Node?[]] }", true);
}

test "Gateway scalar service generation permits unused native reference declarations" {
    try f.gateway(std.testing.allocator, "u64", false);
}

test "Gateway rejects optional reference output even with scalar input and null result" {
    try f.gatewayOutput(std.testing.allocator, "Node?", "null");
}

test "Gateway rejects reference list fields only present in its output" {
    try f.gatewayOutput(std.testing.allocator, "{ nodes: Node?[] }", "{ nodes: [null] }");
}
