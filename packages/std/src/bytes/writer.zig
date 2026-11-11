const std = @import("std");
const Error = std.mem.Allocator.Error;

/// Borrows the host's allocating writer for one synchronous encoding call.
fn writer(out: *const anyopaque) *std.Io.Writer {
    const buffer: *std.Io.Writer.Allocating = @ptrCast(@alignCast(@constCast(out)));

    return &buffer.writer;
}

pub fn write(out: *const anyopaque, value: []const u8) Error!void {
    writer(out).writeAll(value) catch return error.OutOfMemory;
}

pub fn writeMasked(out: *const anyopaque, value: []const u8, mask: u8) Error!void {
    const target = writer(out).writableSlice(value.len) catch return error.OutOfMemory;

    for (target, value) |*byte, source| byte.* = source & mask;
}

pub fn writeByte(out: *const anyopaque, value: u8) Error!void {
    writer(out).writeByte(value) catch return error.OutOfMemory;
}

pub fn writeU32Le(out: *const anyopaque, value: u32) Error!void {
    writer(out).writeInt(u32, value, .little) catch return error.OutOfMemory;
}

pub fn writeU64Le(out: *const anyopaque, value: u64) Error!void {
    writer(out).writeInt(u64, value, .little) catch return error.OutOfMemory;
}

pub fn writeU32sLe(out: *const anyopaque, values: []const u32) Error!void {
    writer(out).writeSliceEndian(u32, values, .little) catch return error.OutOfMemory;
}

pub fn writeU64sLe(out: *const anyopaque, values: []const u64) Error!void {
    writer(out).writeSliceEndian(u64, values, .little) catch return error.OutOfMemory;
}
