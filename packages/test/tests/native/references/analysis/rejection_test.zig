const std = @import("std");
const f = @import("fixture.zig");

test "ordinary ZX cannot declare opaque host references" {
    try f.rejected(std.testing.allocator, .{ .input = "opaque" }, .{ .code = .name, .message = "unknown or unsupported type", .span_text = "opaque" });
}

test "native reference cannot be constructed from a numeric literal" {
    try f.rejected(std.testing.allocator, .{ .body = "return 0" }, .{ .code = .type_mismatch, .message = "a numeric literal requires a numeric type", .span_text = "0" });
}

test "native reference cannot be directly read as a host object field" {
    try f.rejected(std.testing.allocator, .{ .output = "u64", .body = "return in.value" }, .{ .code = .type_mismatch, .message = "field access requires an object", .span_text = "value" });
}

test "native reference cannot directly index the host object" {
    try f.rejected(std.testing.allocator, .{ .body = "return in[0]" }, .{ .code = .type_mismatch, .message = "indexing requires a list, tuple or string", .span_text = "in[0]" });
}

test "native reference address equality is not a ZX operation" {
    try f.rejected(std.testing.allocator, .{ .output = "bool", .body = "return in == in" }, .{ .code = .type_mismatch, .message = "operator is not supported for these operand types", .span_text = "in == in" });
}

test "native reference ordering is not a ZX operation" {
    try f.rejected(std.testing.allocator, .{ .output = "bool", .body = "return in < in" }, .{ .code = .type_mismatch, .message = "operator is not supported for these operand types", .span_text = "in < in" });
}

test "task cannot capture a native reference leaf" {
    try f.rejected(std.testing.allocator, .{ .body = "const work = async in\n\n  return in" }, .{ .code = .capability, .message = "tasks cannot capture host references", .span_text = "async in" });
}

test "task cannot capture a nested optional native reference" {
    try f.rejected(std.testing.allocator, .{ .input = "{ node: Node? }", .output = "u64", .body = "const work = async in.node\n\n  return 0" }, .{ .code = .capability, .message = "tasks cannot capture host references", .span_text = "async in.node" });
}

test "parallel callback cannot capture a native reference list" {
    try f.rejected(std.testing.allocator, .{ .input = "Node[]", .output = "u64", .body = "const work = parallel({ read: () => in.length })\n\n  return 0" }, .{ .code = .capability, .message = "tasks cannot capture host references" });
}

test "Store cannot retain a native reference in an object" {
    try f.rejected(std.testing.allocator, .{ .extra = "export type State = { node: Node }\n\n", .context = .{ .stores = &.{.{ .handle = "$state", .path = "state", .type_name = "State" }} } }, .{ .code = .capability, .message = "Store cannot retain host references" });
}

test "Store cannot retain native references through nested optional list tuple fields" {
    try f.rejected(std.testing.allocator, .{ .extra = "export type State = { nodes: [u64, Node?[]] }\n\n", .context = .{ .stores = &.{.{ .handle = "$state", .path = "state", .type_name = "State" }} } }, .{ .code = .capability, .message = "Store cannot retain host references" });
}

test "ordinary type aliases cannot introduce native opaque types" {
    try f.rejected(std.testing.allocator, .{ .extra = "export type Local = opaque\n\n" }, .{ .code = .name, .message = "unknown or unsupported type", .span_text = "opaque" });
}

test "optional native references cannot compare their host addresses" {
    try f.rejected(std.testing.allocator, .{ .input = "Node?", .output = "bool", .body = "return in == in" }, .{ .code = .type_mismatch, .message = "optional aggregates can only be compared with null", .span_text = "in == in" });
}

test "task cannot return a native optional reference from a pure helper without captures" {
    try f.rejected(std.testing.allocator, .{
        .input = "u64",
        .output = "u64",
        .imports = "\nimport empty from \"./empty\"\n",
        .body = "const work = async empty()\n\n  return in",
        .sources = &.{.{ .path = "empty.zx", .source = "import type { Node } from \"zig:host\"\n\nexport type Input = void\n\nexport type Output = Node?\n\nexport default function (in: Input): Output {\n  return null\n}\n" }},
    }, .{ .code = .capability, .message = "tasks cannot return host references", .span_text = "async empty()" });
}
