const std = @import("std");
const rx = @import("rx");

pub fn reject(source: []const u8, code: @FieldType(rx.Diagnostic, "code"), attribute: ?[]const u8) !void {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "state.store.rx", parsed.value.node);

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
