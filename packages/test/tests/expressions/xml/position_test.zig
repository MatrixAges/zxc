const std = @import("std");
const h = @import("check.zig");
const rx = @import("rx");

test "XML expression mapped position plain" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position decimal_first" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={missing}/>", .marker = "&#109;issing", .valid = false, .eof = false });
}

test "XML expression mapped position decimal_first allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .source = "<Call in={missing}/>", .marker = "&#109;issing", .valid = false, .eof = false }});
}

test "XML expression mapped position hex_last" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={missing}/>", .marker = "missin&#x67;", .valid = false, .eof = false });
}

test "XML expression mapped position quoted_entity_prefix" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={\"文\" + missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position crlf" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={1 +  missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position cr" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={1 +  missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position lf" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={1 +  missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position entity_newline" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={1 +\n missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position utf8_prefix" {
    try h.run(std.testing.allocator, h.Case{ .source = "<!--文--><Call in={missing}/>", .marker = "missing", .valid = false, .eof = false });
}

test "XML expression mapped position eof" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={1 + }/>", .marker = "'/>", .valid = false, .eof = true });
}

test "XML expression mapped position numeric_ir" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={1 + 2}/>", .marker = "&#49; + &#x32;", .valid = true, .eof = false });
}

test "XML expression mapped position numeric_ir allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .source = "<Call in={1 + 2}/>", .marker = "&#49; + &#x32;", .valid = true, .eof = false }});
}

test "XML expression mapped position string_ir" {
    try h.run(std.testing.allocator, h.Case{ .source = "<Call in={\"🙂\"}/>", .marker = "&quot;&#x1F642;&quot;", .valid = true, .eof = false });
}

test "XML multibyte entity maps interior start and end boundaries" {
    const source = "<Call in={a🙂b}/>";
    var xml = try rx.parseXml(std.testing.allocator, source);

    defer xml.deinit();

    try std.testing.expect(xml.value == .node);

    const attribute = xml.value.node.attributes[0];
    const entity = std.mem.indexOf(u8, source, "&#x1F642;").?;
    const after = entity + "&#x1F642;".len;

    try std.testing.expectEqualStrings("a🙂b", attribute.value);

    for ([_]usize{ 1, 2, 3, 4 }) |offset| {
        try std.testing.expectEqual(entity, rx.attributeLocation(attribute, offset).?.offset);
    }

    for ([_]usize{ 2, 3, 4, 5 }) |offset| {
        try std.testing.expectEqual(after, rx.attributeEndLocation(attribute, offset).?.offset);
    }

    try std.testing.expectEqual(after, rx.attributeLocation(attribute, 5).?.offset);
    try std.testing.expectEqual(after + 1, rx.attributeLocation(attribute, 6).?.offset);
    try std.testing.expect(rx.attributeLocation(attribute, 7) == null);
    try std.testing.expect(rx.attributeEndLocation(attribute, 7) == null);
}
