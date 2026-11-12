const std = @import("std");
const rx = @import("rx");
const target = @import("call/target.zig");

pub const Result = struct { name: []const u8, attribute: rx.ast.Attribute };

pub fn resolve(node: rx.ast.Node) Result {
    if (std.mem.eql(u8, node.name, "Task")) {
        const attribute = target.attribute(node, "name");

        return .{ .name = attribute.value, .attribute = attribute };
    }

    const attribute = target.optionalAttribute(node, "fn") orelse target.attribute(node, "module");
    const name = if (comptime @import("rx_options").generated_graph) generated(attribute.value) else seed(attribute.value);

    return .{ .name = name, .attribute = attribute };
}

fn generated(value: []const u8) []const u8 {
    const rule = @import("generated_rx_result_name_range");
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const range = rule.executeValue(empty.allocator(), value) catch unreachable;

    return value[@intCast(range.start)..@intCast(range.end)];
}

fn seed(value: []const u8) []const u8 {
    const separator = std.mem.lastIndexOfAny(u8, value, "/\\");
    var name = value[if (separator) |index| index + 1 else 0..];

    for ([_][]const u8{ ".zx", ".rx", ".zig" }) |suffix| {
        if (std.mem.endsWith(u8, name, suffix)) {
            name = name[0 .. name.len - suffix.len];

            break;
        }
    }

    return name;
}
