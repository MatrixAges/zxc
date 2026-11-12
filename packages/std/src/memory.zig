pub inline fn writeU32(target: *const anyopaque, index: u64, value: u32) error{IndexOutOfBounds}!void {
    return write(u32, target, index, value);
}

pub inline fn writeOptionalU32(target: *const anyopaque, index: u64, value: ?u32) error{IndexOutOfBounds}!void {
    return write(?u32, target, index, value);
}

// The caller exclusively lends a descriptor for a mutable slice for the duration of the call.
inline fn write(comptime T: type, target: *const anyopaque, index: u64, value: T) error{IndexOutOfBounds}!void {
    const buffer: *const []T = @ptrCast(@alignCast(target));

    if (index >= buffer.len) return error.IndexOutOfBounds;

    buffer.*[@intCast(index)] = value;
}
