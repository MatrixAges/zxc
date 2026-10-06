const std = @import("std");
pub const Columns = @import("zxc_abi").native.@"zig:field_columns".Columns;
pub const View = struct { names: [][]const u8, types: []u32 };

fn view(columns: Columns) *const View {
    return @ptrCast(@alignCast(columns));
}

pub fn length(columns: Columns) u64 {
    return view(columns).names.len;
}

pub fn less(columns: Columns, left: u64, right: u64) bool {
    const fields = view(columns);

    return std.mem.lessThan(u8, fields.names[@intCast(left)], fields.names[@intCast(right)]);
}

pub fn swap(columns: Columns, left: u64, right: u64) void {
    const fields = view(columns);
    const a: usize = @intCast(left);
    const b: usize = @intCast(right);

    std.mem.swap([]const u8, &fields.names[a], &fields.names[b]);
    std.mem.swap(u32, &fields.types[a], &fields.types[b]);
}
