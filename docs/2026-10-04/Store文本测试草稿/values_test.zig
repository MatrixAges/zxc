const std = @import("std");
const rx = @import("rx");

const fragments =
    \\<Store name="scheduler" version="1">
    \\  <Object name="state"><Field name="cursor" type="u64" value="0"/></Object>
    \\  <Object name="state"><Field name="label" type="string" value=""/></Object>
    \\  <Object name="other"><Field name="cursor" type="string" value="A&amp;B"/></Object>
    \\</Store>
;

test "Store text preserves disjoint fragments and fields in different objects" {
    var parsed = try rx.parseXml(std.testing.allocator, fragments);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "state.store.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .data);

    const data = result.value.data.store;

    try std.testing.expectEqualStrings("scheduler", data.attributes.name);
    try std.testing.expectEqual(@as(u32, 1), data.attributes.version);
    try std.testing.expectEqual(@as(usize, 3), data.children.len);
    try std.testing.expectEqualStrings("state", data.children[0].attributes.name);
    try std.testing.expectEqualStrings("state", data.children[1].attributes.name);
    try std.testing.expectEqualStrings("other", data.children[2].attributes.name);
    try std.testing.expectEqualStrings("cursor", data.children[0].children[0].attributes.name);
    try std.testing.expectEqualStrings("u64", data.children[0].children[0].attributes.type);
    try std.testing.expectEqualStrings("0", data.children[0].children[0].attributes.value);
    try std.testing.expectEqualStrings("label", data.children[1].children[0].attributes.name);
    try std.testing.expectEqualStrings("", data.children[1].children[0].attributes.value);
    try std.testing.expectEqualStrings("A&B", data.children[2].children[0].attributes.value);
}

test "Store text accepts zero version" {
    try checkVersion("0", 0);
}

test "Store text accepts maximum u32 version" {
    try checkVersion("4294967295", std.math.maxInt(u32));
}

fn checkVersion(version: []const u8, expected: u32) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "<Store name='state' version='{s}'><Object name='state'><Field name='x' type='string' value=''/></Object></Store>", .{version});

    defer std.testing.allocator.free(source);

    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "state.store.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .data);
    try std.testing.expectEqual(expected, result.value.data.store.attributes.version);
}

test "Store text successful fragments release every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{false});
}

test "Store text duplicate fragments release every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{true});
}

fn checkAllocation(allocator: std.mem.Allocator, invalid: bool) !void {
    const source = if (invalid)
        "<Store name='state' version='1'><Object name='state'><Field name='x' type='u64' value='0'/></Object><Object name='state'><Field name='x' type='string' value=''/></Object></Store>"
    else
        fragments;
    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(allocator, "state.store.rx", parsed.value.node);

    defer result.deinit();

    if (invalid) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.context, result.value.diagnostic.code);
        try std.testing.expectEqualStrings("name", result.value.diagnostic.attribute.?);
        try std.testing.expectEqualStrings("Field", result.value.diagnostic.element);
    } else {
        try std.testing.expect(result.value == .data);
        try std.testing.expectEqual(@as(usize, 3), result.value.data.store.children.len);
    }
}

test "Store text duplicate decoded name reports second original value position" {
    var parsed = try rx.parseXml(std.testing.allocator, "<Store name='s' version='1'>\r\n<Object name='state'><Field name='x' type='u64' value='0'/></Object>\r\n<Object name='state'><Field name='&#120;' type='string' value=''/></Object>\r\n</Store>");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "state.store.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;

    try std.testing.expectEqual(.context, issue.code);
    try std.testing.expectEqualStrings("Field", issue.element);
    try std.testing.expectEqualStrings("name", issue.attribute.?);
    try std.testing.expectEqualDeep(rx.ast.Location{ .offset = 134, .line = 3, .column = 35 }, issue.location);
}
