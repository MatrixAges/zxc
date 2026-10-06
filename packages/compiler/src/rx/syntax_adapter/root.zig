const std = @import("std");
const dsl = @import("dsl");
const value = @import("value.zig");

pub fn location(input: anytype) dsl.ast.Location {
    return .{ .offset = @intCast(input.offset), .line = @intCast(input.line), .column = @intCast(input.column) };
}

pub fn convert(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: []const u8, input: anytype) !dsl.ast.Node {
    const nodes = try temporary.alloc(dsl.ast.Node, input.tree.nodes.len);

    for (input.tree.nodes, nodes) |node, *output| {
        const attributes = try allocator.alloc(dsl.ast.Attribute, @intCast(node.attribute_count));
        var head = node.attributes;
        var remaining = attributes.len;

        while (remaining != 0) {
            remaining -= 1;
            const item = input.tree.attributes[@intCast(head - 1)];
            const raw = source[@intCast(item.value.span.start)..@intCast(item.value.span.end)];

            attributes[remaining] = .{
                .kind = if (item.expression) .expression else .string,
                .name = source[@intCast(item.name.start)..@intCast(item.name.end)],
                .value = try value.convert(allocator, source, input.tree.parts, item.value),
                .location = location(item.location),
                .value_location = location(item.value_location),
                .raw_value = raw,
            };

            head = item.previous;
        }

        const text = try allocator.alloc(dsl.ast.Text, @intCast(node.text_count));

        head = node.text;
        remaining = text.len;

        while (remaining != 0) {
            remaining -= 1;

            const item = input.tree.text[@intCast(head - 1)];
            text[remaining] = .{ .value = try value.convert(allocator, source, input.tree.parts, item.value), .location = location(item.location) };
            head = item.previous;
        }

        const children = try allocator.alloc(dsl.ast.Node, @intCast(node.child_count));

        head = node.children;
        remaining = children.len;

        while (remaining != 0) {
            remaining -= 1;

            const item = input.tree.children[@intCast(head - 1)];
            children[remaining] = nodes[@intCast(item.value)];
            head = item.previous;
        }

        output.* = .{
            .name = source[@intCast(node.name.start)..@intCast(node.name.end)],
            .location = location(node.location),
            .attributes = attributes,
            .children = children,
            .text = text,
        };
    }

    return nodes[@intCast(input.control.result)];
}
