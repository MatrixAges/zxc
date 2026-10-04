const std = @import("std");
const Lock = @import("pkgs").Lock;
const Fixture = @import("fixture.zig");
const allocator = std.testing.allocator;

fn checkChain(count: usize, reversed: bool, shortcut_first: ?bool, expected: ?anyerror) !void {
    var fixture = try Fixture.chain(count, reversed, shortcut_first);
    defer fixture.deinit();

    if (expected) |err| try std.testing.expectError(err, fixture.validate(allocator)) else try fixture.validate(allocator);
}

test "lock graph accepts forward path with 256 nodes" {
    try checkChain(256, false, null, null);
}

test "lock graph accepts reverse traversal path with 256 nodes" {
    try checkChain(256, true, null, null);
}

test "lock graph rejects forward path with 257 nodes" {
    try checkChain(257, false, null, error.PackageDependencyDepthExceeded);
}

test "lock graph rejects cached reverse path with 257 nodes" {
    try checkChain(257, true, null, error.PackageDependencyDepthExceeded);
}

test "lock graph accepts boundary path after visiting its shared tail" {
    try checkChain(256, false, true, null);
}

test "lock graph rejects long path after visiting its shared tail" {
    try checkChain(257, false, true, error.PackageDependencyDepthExceeded);
}

test "lock graph rejects long path before visiting its shortcut" {
    try checkChain(257, false, false, error.PackageDependencyDepthExceeded);
}

test "lock graph accepts diamond sharing one target" {
    var fixture = try Fixture.init(&.{ &.{ 1, 2 }, &.{3}, &.{3}, &.{} });
    defer fixture.deinit();

    try fixture.validate(allocator);
}

test "lock graph rejects self dependency" {
    var fixture = try Fixture.init(&.{&.{0}});
    defer fixture.deinit();

    try std.testing.expectError(error.CyclicPackageDependencies, fixture.validate(allocator));
}

test "lock graph rejects two package cycle" {
    var fixture = try Fixture.init(&.{ &.{1}, &.{0} });
    defer fixture.deinit();

    try std.testing.expectError(error.CyclicPackageDependencies, fixture.validate(allocator));
}

test "lock graph rejects cycle in workspace disconnected from root" {
    var fixture = try Fixture.init(&.{ &.{}, &.{2}, &.{1} });
    defer fixture.deinit();

    try std.testing.expectError(error.CyclicPackageDependencies, fixture.validate(allocator));
}

test "lock graph rejects out of range dependency index" {
    var fixture = try Fixture.init(&.{&.{1}});
    defer fixture.deinit();

    try std.testing.expectError(error.InvalidLockTarget, fixture.validate(allocator));
}

test "lock graph rejects duplicate dependency names" {
    var fixture = try Fixture.init(&.{ &.{ 1, 1 }, &.{} });
    defer fixture.deinit();

    try std.testing.expectError(error.DuplicateLockDependency, fixture.validate(allocator));
}

test "lock graph rejects unreachable archive package" {
    var fixture = try Fixture.init(&.{ &.{}, &.{} });
    defer fixture.deinit();
    fixture.packages[1].source = .{ .archive = .{ .archive = "source.tgz", .sha256 = "a" ** 64 } };

    try std.testing.expectError(error.UnreachableLockPackage, fixture.validate(allocator));
}

test "lock graph rejects empty package graph" {
    try std.testing.expectError(error.InvalidLockPackageCount, (Lock{ .format_version = 1, .packages = &.{} }).validate(allocator));
}
