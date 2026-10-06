const std = @import("std");
const f = @import("fixture.zig");

test "NAPI input conversion rejects a native reference leaf" {
    try f.rejectNapi(std.testing.allocator, "Node", true);
}

test "NAPI input conversion rejects an optional native reference" {
    try f.rejectNapi(std.testing.allocator, "Node?", true);
}

test "NAPI input conversion rejects a list of native references" {
    try f.rejectNapi(std.testing.allocator, "Node[]", true);
}

test "NAPI output conversion rejects a native reference leaf" {
    try f.rejectNapi(std.testing.allocator, "Node", false);
}

test "NAPI output conversion rejects optional references nested in object lists" {
    try f.rejectNapi(std.testing.allocator, "{ nodes: Node?[] }", false);
}

test "NAPI output conversion rejects a native reference tuple field" {
    try f.rejectNapi(std.testing.allocator, "[u64, Node?]", false);
}

test "NAPI scalar conversion permits unused native reference declarations" {
    const allocator = std.testing.allocator;
    var result = try f.analyze(allocator, "Node");

    defer result.deinit();

    const scalar: f.compiler.ir.TypeId = @fromBackingInt(@backingInt(f.compiler.ir.Scalar.u64));
    const source = try f.compiler.zig.host.node.napi.render(allocator, result.value.ir.types, scalar, scalar);

    defer allocator.free(source);

    try std.testing.expect(source.len != 0);
}
