const std = @import("std");

pub fn containsSlice(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .pointer => |pointer| pointer.size == .slice,
        .optional => |optional| containsSlice(optional.child),
        else => false,
    };
}

pub fn copy(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!@TypeOf(value) {
    const T = @TypeOf(value);

    return switch (@typeInfo(T)) {
        .optional => if (value) |item| try copy(allocator, item) else null,
        .pointer => |pointer| result: {
            const output = try allocator.alloc(pointer.child, value.len);
            var initialized: usize = 0;

            errdefer {
                for (output[0..initialized]) |item| release(allocator, item);

                allocator.free(output);
            }

            for (value, output) |item, *target| {
                target.* = try copy(allocator, item);
                initialized += 1;
            }

            break :result output;
        },
        else => value,
    };
}

pub fn release(allocator: std.mem.Allocator, value: anytype) void {
    switch (@typeInfo(@TypeOf(value))) {
        .optional => if (value) |item| release(allocator, item),
        .pointer => {
            for (value) |item| release(allocator, item);

            allocator.free(value);
        },
        else => {},
    }
}
