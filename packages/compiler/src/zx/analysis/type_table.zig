const std = @import("std");
const ir = @import("zx").ir;

pub fn copy(allocator: std.mem.Allocator, values: ir.TypeTable) std.mem.Allocator.Error!ir.TypeTable {
    const result = try storage(allocator, values);

    return result.view();
}

pub fn storage(allocator: std.mem.Allocator, values: ir.TypeTable) std.mem.Allocator.Error!ir.TypeStorage {
    var result: ir.TypeStorage = .{};

    inline for (@typeInfo(ir.TypeStorage).@"struct".field_names) |name| {
        const column = @field(values, name);

        const owned = if (comptime std.mem.eql(u8, name, "labels") or std.mem.eql(u8, name, "field_names") or std.mem.eql(u8, name, "names"))
            try names(allocator, column)
        else
            try allocator.dupe(std.meta.Elem(@TypeOf(column)), column);

        @field(result, name) = @FieldType(ir.TypeStorage, name).fromOwnedSlice(owned);
    }

    return result;
}

/// Copies only the columns of a table whose strings outlive the copy, such as a shared project table that one
/// module's analysis extends; the rows the analysis appends are owned by the copy as usual.
pub fn columns(allocator: std.mem.Allocator, values: ir.TypeTable) std.mem.Allocator.Error!ir.TypeStorage {
    var result: ir.TypeStorage = .{};

    inline for (@typeInfo(ir.TypeStorage).@"struct".field_names) |name| {
        const column = @field(values, name);

        @field(result, name) = @FieldType(ir.TypeStorage, name).fromOwnedSlice(try allocator.dupe(std.meta.Elem(@TypeOf(column)), column));
    }

    return result;
}

fn names(allocator: std.mem.Allocator, values: []const []const u8) std.mem.Allocator.Error![][]const u8 {
    const result = try allocator.alloc([]const u8, values.len);

    for (values, result) |value, *owned| owned.* = try allocator.dupe(u8, value);

    return result;
}
