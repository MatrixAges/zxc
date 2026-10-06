pub const Buffer = *const anyopaque;
pub const View = @import("reference_view");

pub fn get(buffer: Buffer, id: u32) u32 {
    const view: *const View = @ptrCast(@alignCast(buffer));

    return @backingInt(view.mapping.at(id));
}

pub fn set(buffer: Buffer, index: u64, value: u32) void {
    const view: *const View = @ptrCast(@alignCast(buffer));

    view.target[@intCast(index)] = value;
}
