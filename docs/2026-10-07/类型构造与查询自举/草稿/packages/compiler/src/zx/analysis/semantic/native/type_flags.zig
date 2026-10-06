const std = @import("std");
const View = @import("type_flags_view");
pub const Flags = *const anyopaque;

fn view(flags: Flags) *const View {
    return @ptrCast(@alignCast(flags));
}

pub fn allocate(flags: Flags, count: u64) std.mem.Allocator.Error!void {
    const data = view(flags);

    std.debug.assert(data.state.values.len == 0);

    data.state.values = try data.allocator.alloc(bool, @intCast(count));

    @memset(data.state.values, false);
}

pub fn get(flags: Flags, index: u64) bool {
    return view(flags).state.values[@intCast(index)];
}

pub fn set(flags: Flags, index: u64, value: bool) void {
    view(flags).state.values[@intCast(index)] = value;
}

pub fn release(flags: Flags) void {
    const data = view(flags);

    data.deinit();

    data.state.values = &.{};
}
