const std = @import("std");
const Lock = @import("pkgs").Lock;
const data = @import("data.zig");
const cases = @import("cases.zig");
const allocator = std.testing.allocator;

test "lock parsed fields survive overwritten source at every allocation boundary" {
    try std.testing.checkAllAllocationFailures(allocator, checkOwned, .{});
}

test "lock serializes and reparses all nested package source and dependency data" {
    const first = try Lock.parse(allocator, data.source);
    defer first.deinit();
    const encoded = try std.json.Stringify.valueAlloc(allocator, first.value, .{});
    defer allocator.free(encoded);
    const second = try Lock.parse(allocator, encoded);
    defer second.deinit();

    try std.testing.expectEqualDeep(first.value, second.value);
}

test "lock unknown field rejection releases every parsed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, cases.check, .{cases.Case.unknown_package});
}

test "lock invalid archive digest rejection releases every parsed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, cases.check, .{cases.Case.short_digest});
}

test "lock version mismatch rejection releases every parsed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, cases.check, .{cases.Case.range});
}

test "lock cycle rejection releases every parsed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, cases.check, .{cases.Case.cycle});
}

test "lock truncated JSON rejection releases every parsed allocation" {
    try std.testing.checkAllAllocationFailures(allocator, cases.check, .{cases.Case.truncated});
}

fn checkOwned(gpa: std.mem.Allocator) !void {
    const source = try gpa.dupe(u8, data.source);
    defer gpa.free(source);
    const parsed = try Lock.parse(gpa, source);
    defer parsed.deinit();
    @memset(source, '_');

    try std.testing.expectEqual(@as(u32, 1), parsed.value.format_version);
    try std.testing.expectEqual(@as(usize, 2), parsed.value.packages.len);
    const root = parsed.value.packages[0];
    const dependency = parsed.value.packages[1];
    try std.testing.expectEqualStrings("root", root.name);
    try std.testing.expectEqualStrings("1.0.0", root.version);
    try std.testing.expectEqualStrings(".", root.source.workspace);
    try std.testing.expectEqualStrings("dep", root.dependencies[0].name);
    try std.testing.expectEqualStrings("^1.0.0", root.dependencies[0].requirement);
    try std.testing.expect(!root.dependencies[0].development);
    try std.testing.expectEqual(@as(usize, 1), root.dependencies[0].target);
    try std.testing.expectEqualStrings("dep", dependency.name);
    try std.testing.expectEqualStrings("1.2.3", dependency.version);
    try std.testing.expectEqualStrings("dep.tgz", dependency.source.archive.archive);
    try std.testing.expectEqualStrings(data.digest, dependency.source.archive.sha256);
    try std.testing.expectEqual(@as(usize, 0), dependency.dependencies.len);
}
