const std = @import("std");

pub fn containsSlice(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .pointer => |pointer| pointer.size == .slice,
        .optional => |optional| containsSlice(optional.child),
        else => false,
    };
}

pub fn copy(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!@TypeOf(value) {
    return copyValue(allocator, value, false);
}

pub fn copyBorrowingText(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!@TypeOf(value) {
    return copyValue(allocator, value, true);
}

fn copyValue(allocator: std.mem.Allocator, value: anytype, comptime borrow_text: bool) std.mem.Allocator.Error!@TypeOf(value) {
    const T = @TypeOf(value);

    if (comptime borrow_text and T == []const u8) return value;

    return switch (@typeInfo(T)) {
        .optional => if (value) |item| try copyValue(allocator, item, borrow_text) else null,
        .pointer => |pointer| result: {
            const output = try allocator.alloc(pointer.child, value.len);
            var initialized: usize = 0;

            errdefer {
                for (output[0..initialized]) |item| releaseValue(allocator, item, borrow_text);

                allocator.free(output);
            }

            for (value, output) |item, *target| {
                target.* = try copyValue(allocator, item, borrow_text);
                initialized += 1;
            }

            break :result output;
        },
        else => value,
    };
}

pub fn release(allocator: std.mem.Allocator, value: anytype) void {
    releaseValue(allocator, value, false);
}

pub fn releaseBorrowingText(allocator: std.mem.Allocator, value: anytype) void {
    releaseValue(allocator, value, true);
}

fn releaseValue(allocator: std.mem.Allocator, value: anytype, comptime borrow_text: bool) void {
    if (comptime borrow_text and @TypeOf(value) == []const u8) return;

    switch (@typeInfo(@TypeOf(value))) {
        .optional => if (value) |item| releaseValue(allocator, item, borrow_text),
        .pointer => {
            for (value) |item| releaseValue(allocator, item, borrow_text);

            allocator.free(value);
        },
        else => {},
    }
}
