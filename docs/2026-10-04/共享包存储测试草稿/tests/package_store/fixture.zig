const std = @import("std");
const pkgs = @import("pkgs");
const store = @import("package_store");
const data = @import("archive_data");
const Fixture = @This();
pub const io = std.testing.io;
const allocator = std.testing.allocator;

temporary: std.testing.TmpDir,
root: [:0]u8,
cache: []u8,
digest: [64]u8,

pub fn init(source: []const u8) !Fixture {
    var temporary = std.testing.tmpDir(.{});
    errdefer temporary.cleanup();
    const root = try temporary.dir.realPathFileAlloc(io, ".", allocator);
    errdefer allocator.free(root);
    const cache = try std.fs.path.join(allocator, &.{ root, "cache" });
    errdefer allocator.free(cache);
    try temporary.dir.writeFile(io, .{ .sub_path = "source.tgz", .data = source });
    var digest: [32]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    return .{ .temporary = temporary, .root = root, .cache = cache, .digest = std.fmt.bytesToHex(digest, .lower) };
}

pub fn deinit(self: *Fixture) void {
    allocator.free(self.root);
    allocator.free(self.cache);
    self.temporary.cleanup();
}

pub fn release(self: *const Fixture) pkgs.Index.Release {
    return .{ .version = "1.0.0", .archive = "source.tgz", .sha256 = &self.digest };
}

pub fn prepare(self: *Fixture, gpa: std.mem.Allocator, offline: bool) ![]u8 {
    return store.prepare(io, gpa, self.release(), self.root, self.cache, offline);
}

pub fn contentPath(self: *const Fixture) ![]u8 {
    return std.fmt.allocPrint(allocator, "cache/packages/v1/contents/{s}", .{self.digest});
}

pub fn blobPath(self: *const Fixture) ![]u8 {
    return std.fmt.allocPrint(allocator, "cache/packages/v1/archives/{s}.tar.gz", .{self.digest});
}

pub fn expectNoStaging(self: *Fixture) !void {
    var directory = self.temporary.dir.openDir(io, "cache/packages/v1/contents", .{ .iterate = true }) catch |err| switch (err) {
        error.FileNotFound => return,
        else => return err,
    };
    defer directory.close(io);
    var iterator = directory.iterate();

    while (try iterator.next(io)) |entry| try std.testing.expect(!std.mem.startsWith(u8, entry.name, ".prepare-"));
}

pub fn expectContent(path: []const u8) !void {
    var directory = try std.Io.Dir.cwd().openDir(io, path, .{});
    defer directory.close(io);
    const source = try directory.readFileAlloc(io, "src/main.zx", allocator, .limited(1024));
    defer allocator.free(source);

    try std.testing.expectEqualStrings("export const value = 7\n", source);
}

pub const valid = data.valid;
pub const duplicate = data.duplicate;
