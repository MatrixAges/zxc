const std = @import("std");
const rx = @import("rx");

test "XML entities and line endings preserve distinct text and attribute rules" {
    var result = try rx.parseXml(std.testing.allocator, "<Root a='&amp;&lt;&gt;&quot;&apos;&#65;&#x1F642;\r\n\t&#10;'>a\r\nb\rc<![CDATA[x\r\ny]]></Root>");

    defer result.deinit();

    try std.testing.expect(result.value == .node);

    const node = result.value.node;

    try std.testing.expectEqualStrings("&<>\"'A🙂  \n", node.attributes[0].value);
    try std.testing.expectEqual(@as(usize, 2), node.text.len);
    try std.testing.expectEqualStrings("a\nb\nc", node.text[0].value);
    try std.testing.expectEqualStrings("x\ny", node.text[1].value);
}

test "XML owns names values and text after caller buffer changes" {
    const source = try std.testing.allocator.dupe(u8, "<Root a='value'><Child/>text</Root>");

    defer std.testing.allocator.free(source);

    var result = try rx.parseXml(std.testing.allocator, source);

    defer result.deinit();
    @memset(source, '?');

    try std.testing.expect(result.value == .node);

    const node = result.value.node;

    try std.testing.expectEqualStrings("Root", node.name);
    try std.testing.expectEqualStrings("a", node.attributes[0].name);
    try std.testing.expectEqualStrings("value", node.attributes[0].value);
    try std.testing.expectEqualStrings("Child", node.children[0].name);
    try std.testing.expectEqualStrings("text", node.text[0].value);
}

test "XML rejects malformed markup and invalid characters" {
    const sources = [_][]const u8{
        "",                "<A>",                       "<A></B>",                                     "<A/><B/>",                                "<A a='1' a='2'/>",
        "<A a=unquoted/>", "<A a='1'b='2'/>",           "<A a='<'/>",                                  "<A>&unknown;</A>",                        "<A>&amp</A>",
        "<A>&#0;</A>",     "<A>&#xD800;</A>",           "<A>&#x110000;</A>",                           "<A>&#-1;</A>",                            "<A>&#x;</A>",
        "<A>]]></A>",      "<A><!--a--b--></A>",        "<A><![CDATA[unclosed</A>",                    "<A>\x00</A>",                             "<A>\xff</A>",
        "<?xml?><A/>",     "<?xml version='1.1'?><A/>", "<?xml version='1.0' encoding='UTF-16'?><A/>", "<?xml version='1.0' version='1.0'?><A/>",
    };

    for (sources) |source| {
        var result = try rx.parseXml(std.testing.allocator, source);

        defer result.deinit();
        errdefer std.debug.print("XML source: {s}\n", .{source});

        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.syntax, result.value.diagnostic.code);
    }
}

test "XML reports byte offsets and one based CRLF positions" {
    var result = try rx.parseXml(std.testing.allocator, "<Root>\r\n  <Child a='值'/>\r\n</Root>");

    defer result.deinit();

    try std.testing.expect(result.value == .node);

    const child = result.value.node.children[0];

    try std.testing.expectEqualDeep(rx.ast.Location{ .offset = 10, .line = 2, .column = 3 }, child.location);
    try std.testing.expectEqualDeep(rx.ast.Location{ .offset = 17, .line = 2, .column = 10 }, child.attributes[0].location);
    try std.testing.expectEqualDeep(rx.ast.Location{ .offset = 20, .line = 2, .column = 13 }, child.attributes[0].value_location);
}
