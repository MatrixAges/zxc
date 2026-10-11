//! Lists a directory with the metadata of each entry where the system returns both in one call, as macOS does through
//! `getattrlistbulk`: there a `stat` per file costs more than the listing itself, and calls from several threads at
//! once queue on a kernel lock. Elsewhere it lists names alone and leaves the metadata to a later `stat`.
const std = @import("std");
const builtin = @import("builtin");
const Files = @import("resident/files.zig");
pub const Entry = struct { name: []const u8, kind: std.Io.File.Kind, metadata: ?Files.Metadata };
pub const Reader = if (builtin.os.tag.isDarwin()) Bulk else Plain;

const Plain = struct {
    iterator: std.Io.Dir.Iterator,
    pub fn init(directory: std.Io.Dir) Plain {
        return .{ .iterator = directory.iterateAssumeFirstIteration() };
    }
    pub fn next(self: *Plain, io: std.Io) !?Entry {
        const entry = try self.iterator.next(io) orelse return null;

        return .{ .name = entry.name, .kind = entry.kind, .metadata = null };
    }
};

const Bulk = struct {
    directory: std.Io.Dir,
    buffer: [32 * 1024]u8 align(8) = undefined,
    offset: usize = 0,
    /// Records of the last call not yet returned; the listing ends with a call that returns none.
    left: usize = 0,
    ended: bool = false,
    const AttributeList = extern struct { bitmapcount: u16 = 5, reserved: u16 = 0, commonattr: u32, volattr: u32 = 0, dirattr: u32 = 0, fileattr: u32, forkattr: u32 = 0 };
    const name = 0x1;
    const object_type = 0x8;
    const modified = 0x400;
    const changed = 0x800;
    const file_id = 0x2000000;
    const returned = 0x80000000;
    const data_length = 0x200;
    const metadata_attributes = object_type | modified | changed | file_id;
    const requested = AttributeList{ .commonattr = returned | name | metadata_attributes, .fileattr = data_length };

    extern "c" fn getattrlistbulk(fd: std.posix.fd_t, list: *const AttributeList, buffer: [*]u8, size: usize, options: u64) c_int;

    pub fn init(directory: std.Io.Dir) Bulk {
        return .{ .directory = directory };
    }
    pub fn next(self: *Bulk, _: std.Io) !?Entry {
        while (self.left == 0) {
            if (self.ended) return null;

            const count = getattrlistbulk(self.directory.handle, &requested, &self.buffer, self.buffer.len, 0);

            if (count < 0) switch (std.posix.errno(count)) {
                .INTR => continue,
                else => |err| return std.posix.unexpectedErrno(err),
            };

            self.left = @intCast(count);
            self.offset = 0;
            self.ended = count == 0;
        }

        self.left -= 1;
        const record = self.buffer[self.offset..];
        self.offset += read(u32, record, 0);

        // The record opens with its length and the attribute sets it holds, then each attribute it holds in order.
        const common = read(u32, record, 4);
        const file = read(u32, record, 16);
        const name_start = 24 + @as(usize, @intCast(read(i32, record, 24)));
        const entry_name = record[name_start..][0 .. read(u32, record, 28) - 1];

        const kind: std.Io.File.Kind = if (common & object_type == 0) .unknown else switch (read(u32, record, 32)) {
            1 => .file,
            2 => .directory,
            5 => .sym_link,
            else => .unknown,
        };

        if (common & metadata_attributes != metadata_attributes or file & data_length == 0) return .{ .name = entry_name, .kind = kind, .metadata = null };

        return .{ .name = entry_name, .kind = kind, .metadata = .{
            .inode = read(u64, record, 68),
            .size = @intCast(read(i64, record, 76)),
            .mtime = time(record, 36),
            .ctime = time(record, 52),
        } };
    }
    fn time(record: []const u8, at: usize) i96 {
        return @as(i96, read(i64, record, at)) * std.time.ns_per_s + read(i64, record, at + 8);
    }
    fn read(comptime Value: type, record: []const u8, at: usize) Value {
        return std.mem.readInt(Value, record[at..][0..@sizeOf(Value)], builtin.cpu.arch.endian());
    }
};
