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

pub fn copy(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!Records {
    if (generated) {
        if (source.keys.len == 0) return empty;

        const paths = try allocator.alloc([]const u32, source.paths.len);

        for (source.paths, paths) |path, *target| target.* = try allocator.dupe(u32, path);

        return .{ .keys = try allocator.dupe(u64, source.keys), .paths = paths };
    }

    if (source.len == 0) return &.{};

    const rows = try allocator.alloc(Record, source.len);

    for (source, rows) |row, *target| target.* = .{
        .owner = row.owner,
        .path = try allocator.dupe(u32, row.path),
        .value = row.value,
    };

    return rows;
}
