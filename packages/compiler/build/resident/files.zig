//! The source files a resident generator read, with the metadata they were read under. A file whose inode, size and
//! modification and status-change times still match keeps its earlier text, the same bytes at the same address, so
//! later comparisons of unchanged sources are pointer checks. As in Zig's own cache, a match only counts once the
//! file's last change is older than the read by more than the clock's resolution could hide; a file changed close
//! to its read is read again. Replaced texts stay alive until `release`, since analyses may point into them.
const std = @import("std");
const Self = @This();

/// How much older than the read a file's last change must be for its metadata to vouch for its contents.
const settled = std.time.ns_per_s;

gpa: std.mem.Allocator,
entries: std.StringHashMapUnmanaged(Entry) = .empty,
replaced: std.ArrayList([]u8) = .empty,

const Entry = struct { inode: std.Io.File.INode, size: u64, mtime: i96, ctime: i96, read: i96, text: []u8 };

pub fn deinit(self: *Self) void {
    self.release();
    self.replaced.deinit(self.gpa);

    var entries = self.entries.iterator();

    while (entries.next()) |entry| {
        self.gpa.free(entry.key_ptr.*);
        self.gpa.free(entry.value_ptr.text);
    }

    self.entries.deinit(self.gpa);
}

/// The contents of `path` in `directory`, keyed by `key`, which names the file across requests.
pub fn read(self: *Self, io: std.Io, directory: std.Io.Dir, path: []const u8, key: []const u8) ![]const u8 {
    if (self.entries.getPtr(key)) |entry| {
        if (vouches(entry.*, try directory.statFile(io, path, .{}))) return entry.text;
    }

    const started = std.Io.Timestamp.now(io, .real).nanoseconds;
    const file = try directory.openFile(io, path, .{});

    defer file.close(io);

    const stat = try file.stat(io);
    const text = try self.gpa.alloc(u8, @intCast(stat.size));

    errdefer self.gpa.free(text);

    if (try file.readPositionalAll(io, text, 0) != text.len) return error.FileChanged;

    const found = try self.entries.getOrPut(self.gpa, key);

    if (found.found_existing) {
        try self.replaced.append(self.gpa, found.value_ptr.text);
    } else {
        found.key_ptr.* = self.gpa.dupe(u8, key) catch |err| {
            self.entries.removeByPtr(found.key_ptr);

            return err;
        };
    }

    found.value_ptr.* = .{ .inode = stat.inode, .size = stat.size, .mtime = stat.mtime.nanoseconds, .ctime = stat.ctime.nanoseconds, .read = started, .text = text };

    return text;
}

/// Frees the texts replaced since the last call.
pub fn release(self: *Self) void {
    for (self.replaced.items) |text| self.gpa.free(text);

    self.replaced.clearRetainingCapacity();
}

fn vouches(entry: Entry, stat: std.Io.File.Stat) bool {
    return entry.inode == stat.inode and entry.size == stat.size and entry.mtime == stat.mtime.nanoseconds and entry.ctime == stat.ctime.nanoseconds and stat.ctime.nanoseconds + settled < entry.read;
}
