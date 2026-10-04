const std = @import("std");
const Fixture = @This();
pub const fs = @import("standard").fs;
pub const io = std.testing.io;
pub const allocator = std.testing.allocator;

temporary: std.testing.TmpDir,
arena: std.heap.ArenaAllocator,
root: []const u8,
pub fn init() !Fixture {
    var temporary = std.testing.tmpDir(.{});

    errdefer temporary.cleanup();

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const root = try temporary.dir.realPathFileAlloc(io, ".", arena.allocator());

    return .{ .temporary = temporary, .arena = arena, .root = root };
}

pub fn deinit(self: *Fixture) void {
    self.arena.deinit();
    self.temporary.cleanup();
}

pub fn path(self: *Fixture, name: []const u8) ![]const u8 {
    return std.fs.path.join(self.arena.allocator(), &.{ self.root, name });
}

pub fn write(self: *Fixture, name: []const u8, data: []const u8) !void {
    try self.temporary.dir.writeFile(io, .{ .sub_path = name, .data = data });
}

pub fn expectContent(self: *Fixture, name: []const u8, expected: []const u8) !void {
    const actual = try self.temporary.dir.readFileAlloc(io, name, self.arena.allocator(), .limited(1024 * 1024));

    try std.testing.expectEqualSlices(u8, expected, actual);
}

pub fn expectMissing(self: *Fixture, name: []const u8) !void {
    try std.testing.expectError(error.FileNotFound, self.temporary.dir.statFile(io, name, .{ .follow_symlinks = false }));
}

pub fn freeNames(gpa: std.mem.Allocator, names: []const []const u8) void {
    for (names) |name| gpa.free(name);

    gpa.free(names);
}
