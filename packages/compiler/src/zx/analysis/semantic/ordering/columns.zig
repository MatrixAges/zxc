pub const Columns = @import("zxc_abi").native.@"zig:named_columns".Columns;
pub const View = @import("named_view");

fn view(columns: Columns) *const View {
    return @ptrCast(@alignCast(columns));
}

pub fn length(columns: Columns) u64 {
    return view(columns).names.len;
}

pub fn less(columns: Columns, left: u64, right: u64) bool {
    return view(columns).lessThan(@intCast(left), @intCast(right));
}

pub fn swap(columns: Columns, left: u64, right: u64) void {
    view(columns).swap(@intCast(left), @intCast(right));
}
