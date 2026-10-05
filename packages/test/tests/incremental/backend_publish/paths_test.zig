const std = @import("std");
const allocation_testing = @import("allocation_testing");
const api = @import("observed");
const Fixture = @import("fixture.zig");
const io = std.testing.io;
const allocator = std.testing.allocator;

test "backend parent symlink cannot bypass input overlap check" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    try fixture.temporary.dir.symLink(io, ".", "alias", .{ .is_directory = true });

    const path = try std.fs.path.join(allocator, &.{ fixture.root, "alias/input" });

    defer allocator.free(path);

    fixture.options.output = path;

    try std.testing.expectError(error.OutputOverlapsInput, fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
    try expectFile(&fixture, "input", "source");
}

test "backend replaces final symlink without modifying its input target" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    try fixture.temporary.dir.symLink(io, "input", "alias", .{});

    const path = try std.fs.path.join(allocator, &.{ fixture.root, "alias" });

    defer allocator.free(path);

    fixture.options.output = path;

    try std.testing.expect(try fixture.publish());
    try expectFile(&fixture, "input", "source");
    try expectFile(&fixture, "alias", "new-bin");

    const stat = try fixture.temporary.dir.statFile(io, "alias", .{ .follow_symlinks = false });

    try std.testing.expectEqual(.file, stat.kind);
}

test "backend aliases cannot give binary and assembly the same physical output" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    try fixture.temporary.dir.symLink(io, ".", "alias", .{ .is_directory = true });

    const path = try std.fs.path.join(allocator, &.{ fixture.root, "alias/output" });

    defer allocator.free(path);

    fixture.options.assembly = path;

    try std.testing.expectError(error.ConflictingOutputPaths, fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend creates absent nested parents for both artifacts" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    const binary = try std.fs.path.join(allocator, &.{ fixture.root, "new/deep/app" });

    defer allocator.free(binary);

    const assembly = try std.fs.path.join(allocator, &.{ fixture.root, "new/deep/app.s" });

    defer allocator.free(assembly);

    fixture.options.output = binary;
    fixture.options.assembly = assembly;

    try std.testing.expect(try fixture.publish());
    try expectFile(&fixture, "new/deep/app", "new-bin");
    try expectFile(&fixture, "new/deep/app.s", "new-asm");
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend existing parent path cleanup handles every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(allocator, checkResources, .{"future"});
}

test "backend absent parent path cleanup handles every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(allocator, checkResources, .{"new/deep/future"});
}

fn checkResources(gpa: std.mem.Allocator, relative: []const u8) !void {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    const path = try std.fs.path.join(allocator, &.{ fixture.root, relative });

    defer allocator.free(path);

    const checked = try api.Output.check(io, gpa, &fixture.inputs, path);

    defer gpa.free(checked);

    try std.testing.expectEqualStrings(path, checked);
}

fn expectFile(fixture: *Fixture, path: []const u8, expected: []const u8) !void {
    const actual = try fixture.temporary.dir.readFileAlloc(io, path, allocator, .limited(1024));

    defer allocator.free(actual);

    try std.testing.expectEqualStrings(expected, actual);
}
