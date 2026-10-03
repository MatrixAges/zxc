const std = @import("std");
const rx = @import("rx");

test "XML accepts 256 levels and rejects the next opening tag" {
    for ([_]usize{ 255, 256, 257, 1024 }) |depth| {
        const source = try std.testing.allocator.alloc(u8, depth * 7);

        defer std.testing.allocator.free(source);

        for (0..depth) |index| @memcpy(source[index * 3 ..][0..3], "<A>");
        for (0..depth) |index| @memcpy(source[depth * 3 + index * 4 ..][0..4], "</A>");

        var result = try rx.parseXml(std.testing.allocator, source);

        defer result.deinit();

        if (depth <= 256) {
            try std.testing.expect(result.value == .node);

            var node = result.value.node;

            for (1..depth) |_| {
                try std.testing.expectEqual(@as(usize, 1), node.children.len);

                node = node.children[0];
            }

            try std.testing.expectEqual(@as(usize, 0), node.children.len);
        } else {
            try std.testing.expect(result.value == .diagnostic);
            try std.testing.expectEqual(.syntax, result.value.diagnostic.code);
            try std.testing.expectEqual(@as(usize, 768), result.value.diagnostic.location.offset);
        }
    }
}

test "XML wide child list preserves order beyond initial allocation capacity" {
    var source: std.ArrayList(u8) = .empty;

    defer source.deinit(std.testing.allocator);

    try source.appendSlice(std.testing.allocator, "<Root>");

    for (0..1024) |index| {
        const child = try std.fmt.allocPrint(std.testing.allocator, "<N value='{d}'/>", .{index});

        defer std.testing.allocator.free(child);

        try source.appendSlice(std.testing.allocator, child);
    }

    try source.appendSlice(std.testing.allocator, "</Root>");

    var result = try rx.parseXml(std.testing.allocator, source.items);

    defer result.deinit();

    try std.testing.expect(result.value == .node);
    try std.testing.expectEqual(@as(usize, 1024), result.value.node.children.len);

    for (result.value.node.children, 0..) |child, index| {
        try std.testing.expectEqualStrings("N", child.name);
        try std.testing.expectEqual(index, try std.fmt.parseInt(usize, child.attributes[0].value, 10));
    }
}
