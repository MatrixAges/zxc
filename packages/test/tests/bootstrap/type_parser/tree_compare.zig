const std = @import("std");
const zx = @import("zx");
const program = @import("program");

pub fn same(expected: *const zx.ast.Type, actual: program.Output, index: u64) !void {
    try std.testing.expect(index < actual.tree.nodes.len);

    const node = actual.tree.nodes[index];

    switch (expected.*) {
        .named => |name| {
            try std.testing.expectEqual(.Named, node.kind);
            try sameName(name, node.name);
        },
        .optional, .list => |child| {
            const kind: @TypeOf(node.kind) = if (expected.* == .optional) .Optional else .List;

            try std.testing.expectEqual(kind, node.kind);
            try std.testing.expect(node.child < index);
            try same(child, actual, node.child);
        },
        .application => |application| {
            try std.testing.expectEqual(.Application, node.kind);
            try sameName(application.name, node.name);
            try std.testing.expect(node.child < index);
            try same(application.argument, actual, node.child);
        },
        .tuple => |items| {
            try std.testing.expectEqual(.Tuple, node.kind);
            try std.testing.expectEqual(items.len, node.count);

            var head = node.head;
            var position = items.len;

            while (position > 0) {
                position -= 1;

                try std.testing.expect(head > 0 and head <= actual.tree.items.len);

                const edge = actual.tree.items[head - 1];

                try std.testing.expect(edge.previous < head);
                try std.testing.expect(edge.value < index);
                try same(items[position], actual, edge.value);

                head = edge.previous;
            }

            try std.testing.expectEqual(@as(u64, 0), head);
        },
        .object => |fields| {
            try std.testing.expectEqual(.Object, node.kind);
            try std.testing.expectEqual(fields.len, node.count);

            var head = node.head;
            var position = fields.len;

            while (position > 0) {
                position -= 1;

                try std.testing.expect(head > 0 and head <= actual.tree.fields.len);

                const edge = actual.tree.fields[head - 1];

                try std.testing.expect(edge.previous < head);
                try std.testing.expect(edge.value < index);
                try sameName(fields[position].name, edge.name);
                try same(fields[position].value, actual, edge.value);

                head = edge.previous;
            }

            try std.testing.expectEqual(@as(u64, 0), head);
        },
        .enumeration => return error.UnexpectedEnumerationType,
    }
}

fn sameName(expected: zx.ast.Name, actual: anytype) !void {
    try std.testing.expectEqual(expected.span.start, actual.start);
    try std.testing.expectEqual(expected.span.end, actual.end);
}
