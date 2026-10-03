const std = @import("std");
const rx = @import("rx");
const leaf = "<Module><Return value='$in'/></Module>";

test "RX text resolves normalized module imports" {
    const sources = [_]rx.TextSource{
        .{ .path = "app/start.rx", .source = "<Module><Import from='../shared/leaf'/><Return value='$in'/></Module>" },
        .{ .path = "shared/leaf.rx", .source = leaf },
    };

    var result = try rx.parseModules(std.testing.allocator, &sources);

    defer result.deinit();

    try std.testing.expect(result.value == .data);
    try std.testing.expectEqual(@as(usize, 2), result.value.data.len);
}

test "RX text cycle diagnostic retains source and attribute position" {
    const sources = [_]rx.TextSource{
        .{ .path = "a.rx", .source = "<Module><Import from='b'/></Module>" },
        .{ .path = "b.rx", .source = "<Module>\n  <Import from='a'/>\n</Module>" },
    };

    var result = try rx.parseModules(std.testing.allocator, &sources);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const diagnostic = result.value.diagnostic;

    try std.testing.expectEqual(@as(usize, 1), diagnostic.source_index);
    try std.testing.expectEqualStrings("from", diagnostic.issue.attribute.?);
    try std.testing.expectEqualDeep(rx.ast.Location{ .offset = 25, .line = 2, .column = 17 }, diagnostic.issue.location);
}

test "RX text allocation failures release earlier parsed documents" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{false});
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{true});
}

fn checkAllocation(allocator: std.mem.Allocator, malformed: bool) !void {
    const sources = [_]rx.TextSource{
        .{ .path = "a.rx", .source = leaf },
        .{ .path = "b.rx", .source = if (malformed) "<Module>" else leaf },
    };

    var result = try rx.parseModules(allocator, &sources);

    defer result.deinit();

    if (malformed) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(@as(usize, 1), result.value.diagnostic.source_index);
        try std.testing.expectEqual(.syntax, result.value.diagnostic.issue.code);
    } else {
        try std.testing.expect(result.value == .data);
    }
}
