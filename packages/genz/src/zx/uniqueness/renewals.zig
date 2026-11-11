const std = @import("std");
const generated = @import("genz_options").generated_analysis;
pub const Record = struct { owner: u32, path: []const u32, value: bool = false };

pub const Records = if (generated) struct {
    keys: []const u64 = &.{},
    paths: []const []const u32 = &.{},
} else []const Record;

pub const empty: Records = if (generated) .{} else &.{};

pub fn count(records: Records) usize {
    return if (generated) records.keys.len else records.len;
}

pub fn at(records: Records, index: usize) Record {
    if (!generated) return records[index];

    const slot_bits = @bitSizeOf(u32);
    const group = records.keys[index] >> slot_bits;

    return .{ .owner = @intCast(group >> @bitSizeOf(u1)), .path = records.paths[index], .value = @as(u1, @truncate(group)) != 0 };
}

pub fn copy(allocator: std.mem.Allocator, source: Records) std.mem.Allocator.Error!Records {
    if (generated) {
        if (source.keys.len == 0) return empty;

        const keys = try allocator.dupe(u64, source.keys);

        errdefer allocator.free(keys);

        const paths = try allocator.alloc([]const u32, source.paths.len);
        var copied: usize = 0;

        errdefer {
            for (paths[0..copied]) |path| allocator.free(path);

            allocator.free(paths);
        }

        for (source.paths, paths) |path, *target| {
            target.* = try allocator.dupe(u32, path);
            copied += 1;
        }

        return .{ .keys = keys, .paths = paths };
    }

    if (source.len == 0) return &.{};

    const rows = try allocator.alloc(Record, source.len);
    var copied: usize = 0;

    errdefer {
        for (rows[0..copied]) |row| allocator.free(row.path);

        allocator.free(rows);
    }

    for (source, rows) |row, *target| {
        target.* = .{ .owner = row.owner, .path = try allocator.dupe(u32, row.path), .value = row.value };
        copied += 1;
    }

    return rows;
}
