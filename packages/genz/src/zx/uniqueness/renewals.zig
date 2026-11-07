const std = @import("std");
const generated = @import("genz_options").generated_analysis;
const Source = if (generated) std.meta.Child(@import("generated_uniqueness_function_plan").Output) else void;
pub const Record = if (generated) std.meta.Child(std.meta.Child(@FieldType(Source, "renewals"))) else struct { owner: u32, path: []const u32, value: bool = false };
pub const Records = []const Record;

pub fn copy(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!Records {
    if (source.len == 0) return &.{};

    const rows = try allocator.alloc(Record, source.len);

    for (source, rows) |row, *target| target.* = .{
        .owner = row.owner,
        .path = try allocator.dupe(u32, row.path),
        .value = row.value,
    };

    return rows;
}
