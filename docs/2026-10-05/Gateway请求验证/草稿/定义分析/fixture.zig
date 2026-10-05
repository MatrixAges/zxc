const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
pub const allocator = std.testing.allocator;

pub fn analyze(gpa: std.mem.Allocator, source: []const u8, owner: []const u8) !analysis.gateway.Result {
    var parsed = try rx.parseXml(gpa, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    return analysis.gateway.analyze(gpa, .{ .owner = owner, .node = parsed.value.node });
}

pub fn reject(source: []const u8, code: []const u8) !void {
    var result = try analyze(allocator, source, "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqualStrings(code, result.value.diagnostic.code);
    try std.testing.expectEqualStrings("main.gateway.rx", result.value.diagnostic.path);
}
