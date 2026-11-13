const std = @import("std");

pub fn write(allocator: std.mem.Allocator, payload: anytype, header_size: usize) std.mem.Allocator.Error!std.Io.Writer.Allocating {
    var out: std.Io.Writer.Allocating = .init(allocator);

    errdefer out.deinit();

    try writeInto(&out, payload, header_size);

    return out;
}

pub fn writeInto(out: *std.Io.Writer.Allocating, payload: anytype, header_size: usize) std.mem.Allocator.Error!void {
    out.clearRetainingCapacity();

    const header = out.writer.writableSlice(header_size) catch return error.OutOfMemory;

    @memset(header, 0);
    std.json.Stringify.value(payload, .{}, &out.writer) catch return error.OutOfMemory;
}
