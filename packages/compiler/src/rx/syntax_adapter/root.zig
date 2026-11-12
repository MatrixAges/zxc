const std = @import("std");
const dsl = @import("dsl");
const value = @import("value.zig");

pub fn location(input: anytype) dsl.ast.Location {
    return .{ .offset = @intCast(input.offset), .line = @intCast(input.line), .column = @intCast(input.column) };
}

pub fn convert(comptime layout: anytype, comptime decode: anytype, allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: []const u8, input: anytype) !dsl.ast.Node {
    const tree = input.tree;
    const slots = try temporary.alloc(u64, tree.nodes.len + tree.text.len);
    const node_slots = slots[0..tree.nodes.len];
    const text_slots = slots[tree.nodes.len..];
    const Parameter = @typeInfo(@TypeOf(layout)).@"fn".param_types[1].?;
    const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;

    const layout_input: Input = .{
        .nodes = tree.nodes,
        .text = tree.text,
        .root = input.control.result,
        .node_slots = @ptrCast(&node_slots),
        .text_slots = @ptrCast(&text_slots),
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    layout(empty.allocator(), if (@typeInfo(Parameter) == .pointer) &layout_input else layout_input) catch unreachable;

    const decoded = try value.materialize(decode, allocator, source, tree.parts, input.control.decoded_length);
    const nodes = try allocator.alloc(dsl.ast.Node, tree.nodes.len);
    const attributes = try allocator.alloc(dsl.ast.Attribute, tree.attributes.len);
    const text = try allocator.alloc(dsl.ast.Text, tree.text.len);

    for (tree.attributes, attributes) |item, *output| {
        const raw = value.raw(source, item.value);

        output.* = .{
            .kind = if (item.expression) .expression else .string,
            .name = source[@intCast(item.name.start)..@intCast(item.name.end)],
            .value = value.select(raw, decoded, item.value),
            .location = location(item.location),
            .value_location = location(item.value_location),
            .raw_value = raw,
        };
    }

    for (tree.text, text_slots) |item, slot| {
        text[@intCast(slot)] = .{
            .value = value.select(value.raw(source, item.value), decoded, item.value),
            .location = location(item.location),
        };
    }

    var child_start: usize = 1;
    var text_start: usize = 0;

    for (tree.nodes, node_slots) |node, slot| {
        const attribute_start: usize = @intCast(node.attribute_start);
        const attribute_count: usize = @intCast(node.attribute_count);
        const child_count: usize = @intCast(node.child_count);
        const text_count: usize = @intCast(node.text_count);

        nodes[@intCast(slot)] = .{
            .name = source[@intCast(node.name.start)..@intCast(node.name.end)],
            .location = location(node.location),
            .attributes = attributes[attribute_start..][0..attribute_count],
            .children = nodes[child_start..][0..child_count],
            .text = text[text_start..][0..text_count],
        };

        child_start += child_count;
        text_start += text_count;
    }

    return nodes[0];
}
