const std = @import("std");
const compiler = @import("compiler");

fn valid(allocator: std.mem.Allocator) !void {
    const source = try allocator.dupe(u8, "<Module>\n\n <Task>\n  <Call value='a > b &amp; c' />\n  <!-- keep -->\n  <Return value={$in} />\n </Task>\n <Task><![CDATA[raw <text>\n\n]]></Task>\n</Module>\n");

    const first = compiler.format(allocator, source, "module.rx") catch |err| {
        allocator.free(source);

        return err;
    };

    allocator.free(source);
    defer first.deinit(allocator);

    try std.testing.expect(first == .source);
    try std.testing.expect(std.mem.indexOf(u8, first.source, "a > b &amp; c") != null);
    try std.testing.expect(std.mem.indexOf(u8, first.source, "<![CDATA[raw <text>\n\n]]>") != null);

    const second = try compiler.format(allocator, first.source, "module.rx");

    defer second.deinit(allocator);

    try std.testing.expect(second == .source);
    try std.testing.expectEqualStrings(first.source, second.source);
}

fn invalid(allocator: std.mem.Allocator) !void {
    const source = try allocator.dupe(u8, "<Module>\n <Call>\n</Module>");

    const result = compiler.format(allocator, source, "module.rx") catch |err| {
        allocator.free(source);

        return err;
    };

    allocator.free(source);
    defer result.deinit(allocator);

    try std.testing.expect(result == .diagnostic);
    try std.testing.expectEqual(.syntax, result.diagnostic.code);
    try std.testing.expectEqualStrings("XML closing tag does not match opening tag", result.diagnostic.message);
}

test "RX formatter owns valid output and releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, valid, .{});
}

test "RX formatter owns XML diagnostics and releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, invalid, .{});
}
