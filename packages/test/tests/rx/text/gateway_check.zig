const std = @import("std");
const rx = @import("rx");

pub fn reject(source: []const u8, code: @FieldType(rx.Diagnostic, "code"), attribute: ?[]const u8) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "api.gateway.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;

    try std.testing.expectEqual(code, issue.code);

    if (attribute) |name| {
        try std.testing.expectEqualStrings(name, issue.attribute orelse return error.MissingAttribute);
    } else {
        try std.testing.expectEqual(@as(?[]const u8, null), issue.attribute);
    }
}

pub fn accept(source: []const u8, protocol: ?rx.gateway.Protocol, method: ?rx.gateway.Method) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "api.gateway.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .data);

    const data = result.value.data.gateway;

    try std.testing.expectEqual(protocol, data.attributes.protocol);
    try std.testing.expectEqual(method, data.children[0].route.attributes.method);
    try std.testing.expectEqualStrings("/orders", data.children[0].route.attributes.path);
    try std.testing.expectEqualStrings("orders/create", data.children[0].route.attributes.service);
}
