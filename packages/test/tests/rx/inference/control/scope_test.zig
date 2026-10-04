const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");

fn check(source: []const u8, code: ?[]const u8, offset: usize) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.project.infer(std.testing.allocator, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = parsed.value.node }},
        .sources = &.{.{ .path = "helper.zx", .source = @embedFile("../project/fixtures/number.zx") }},
    });

    defer result.deinit();

    if (code) |expected| {
        try std.testing.expect(result.value == .diagnostic);

        const issue = result.value.diagnostic;

        try std.testing.expectEqualStrings(expected, issue.code);
        try std.testing.expectEqualStrings("main.rx", issue.path);
        try std.testing.expectEqual(offset, issue.location.offset);
        try std.testing.expectEqual(@as(usize, 1), issue.location.line);
        try std.testing.expectEqual(offset + 1, issue.location.column);
    } else {
        try std.testing.expect(result.value == .contract);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.contract.program) == null);
    }
}

test "RX Task binding cannot escape scope" {
    try check("<Module><Call fn=\"./helper.zx\" in=\"$in.value\" out=\"ctx.base\"/><Task name=\"t\"><Call fn=\"./helper.zx\" in=\"ctx.base\" out=\"ctx.inner\"/></Task><Return value=\"ctx.inner\"/></Module>", "name", 153);
}

test "RX Case binding cannot escape scope" {
    try check("<Module><Call fn=\"./helper.zx\" in=\"$in.value\" out=\"ctx.base\"/><Switch on=\"$in.enabled\"><Case value=\"true\"><Call fn=\"./helper.zx\" in=\"ctx.base\" out=\"ctx.inner\"/></Case></Switch><Return value=\"ctx.inner\"/></Module>", "name", 191);
}

test "RX Task binding cannot shadow outer path" {
    try check("<Module><Call fn=\"./helper.zx\" in=\"$in.value\" out=\"ctx.base\"/><Task name=\"t\"><Call fn=\"./helper.zx\" in=\"ctx.base\" out=\"ctx.base\"/></Task><Return value=\"ctx.base\"/></Module>", "name", 119);
}

test "RX Switch label rejects dynamic binding" {
    try check("<Module><Call fn=\"./helper.zx\" in=\"$in.value\" out=\"ctx.base\"/><Switch on=\"ctx.base\"><Case value=\"ctx.base\"><Return value=\"1\"/></Case><Default><Return value=\"2\"/></Default></Switch></Module>", "type_mismatch", 97);
}

test "RX Switch rejects decoded duplicate labels" {
    try check("<Module><Switch on='\"x\"'><Case value='\"x\"'><Return value=\"1\"/></Case><Case value='&quot;x&quot;'><Return value=\"2\"/></Case><Default><Return value=\"3\"/></Default></Switch></Module>", "context", 82);
}

test "RX sibling Cases allow same binding and exhaustive bool" {
    try check("<Module><Call fn=\"./helper.zx\" in=\"$in.value\" out=\"ctx.base\"/><Switch on=\"$in.enabled\"><Case value=\"true\"><Call fn=\"./helper.zx\" in=\"ctx.base\" out=\"ctx.inner\"/><Return value=\"ctx.inner\"/></Case><Case value=\"false\"><Call fn=\"./helper.zx\" in=\"ctx.base\" out=\"ctx.inner\"/><Return value=\"ctx.inner\"/></Case></Switch></Module>", null, 0);
}
