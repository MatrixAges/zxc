const std = @import("std");
pub const Allocator = std.mem.Allocator;
pub const Arena = std.heap.ArenaAllocator;

pub fn clone(comptime T: type, allocator: Allocator, value: T) Allocator.Error!T {
    return switch (@typeInfo(T)) {
        .pointer => |pointer| blk: {
            if (pointer.size != .slice) @compileError("ZX only permits slices");

            const result = try allocator.alloc(pointer.child, value.len);

            for (value, 0..) |item, index| result[index] = try clone(pointer.child, allocator, item);

            break :blk result;
        },
        .optional => |optional| if (value) |item| try clone(optional.child, allocator, item) else null,
        .@"struct" => blk: {
            var result: T = undefined;

            inline for (std.meta.fields(T)) |field| @field(result, field.name) = try clone(field.type, allocator, @field(value, field.name));

            break :blk result;
        },
        else => value,
    };
}

pub fn list(comptime T: type, allocator: Allocator, values: anytype) Allocator.Error![]const T {
    return allocator.dupe(T, &values);
}

pub fn push(comptime T: type, allocator: Allocator, values: []const T, value: T) (Allocator.Error || error{Overflow})!struct { []const T, void } {
    const result = try allocator.alloc(T, try std.math.add(usize, values.len, 1));

    @memcpy(result[0..values.len], values);

    result[values.len] = value;

    return .{ result, {} };
}

pub fn pop(comptime T: type, values: []const T) struct { []const T, ?T } {
    if (values.len == 0) return .{ values, null };

    return .{ values[0 .. values.len - 1], values[values.len - 1] };
}

pub fn reverse(comptime T: type, values: []const T) struct { []const T, void } {
    std.mem.reverse(T, @constCast(values));

    return .{ values, {} };
}

pub fn sort(comptime T: type, values: []const T) struct { []const T, void } {
    std.mem.sortUnstable(T, @constCast(values), {}, struct {
        fn less(_: void, left: T, right: T) bool {
            if (T == []const u8) return std.mem.lessThan(u8, left, right);

            if (@typeInfo(T) == .float) {
                if (std.math.isNan(left)) return false;
                if (std.math.isNan(right)) return true;
            }

            return left < right;
        }
    }.less);

    return .{ values, {} };
}

pub fn concat(comptime T: type, allocator: Allocator, left: []const T, right: []const T) (Allocator.Error || error{Overflow})!struct { []const T, void } {
    const result = try allocator.alloc(T, try std.math.add(usize, left.len, right.len));

    @memcpy(result[0..left.len], left);
    @memcpy(result[left.len..], right);

    return .{ result, {} };
}

pub fn splice(comptime T: type, allocator: Allocator, values: []const T, start: u64, count: u64, replacement: []const T) error{ OutOfMemory, IndexOutOfBounds, Overflow }!struct { []const T, []const T } {
    if (start > values.len or count > values.len - start) return error.IndexOutOfBounds;

    const begin: usize = @intCast(start);
    const removed: usize = @intCast(count);
    const result = try allocator.alloc(T, try std.math.add(usize, values.len - removed, replacement.len));

    @memcpy(result[0..begin], values[0..begin]);
    @memcpy(result[begin..][0..replacement.len], replacement);
    @memcpy(result[begin + replacement.len ..], values[begin + removed ..]);

    return .{ result, values[begin .. begin + removed] };
}

pub fn at(comptime T: type, values: []const T, index: u64) error{IndexOutOfBounds}!T {
    if (index >= values.len) return error.IndexOutOfBounds;

    return values[@intCast(index)];
}

pub fn append(comptime T: type, allocator: Allocator, values: *std.ArrayList(T), value: T) Allocator.Error!void {
    try values.append(allocator, value);
}

pub fn equal(comptime T: type, left: T, right: T) bool {
    if (T == []const u8) return std.mem.eql(u8, left, right);

    if (@typeInfo(T) == .optional) {
        if (left == null or right == null) return left == null and right == null;

        return equal(@typeInfo(T).optional.child, left.?, right.?);
    }

    return left == right;
}

pub fn text(allocator: Allocator, value: anytype) Allocator.Error![]const u8 {
    const T = @TypeOf(value);

    if (T == []const u8) return value;
    if (@typeInfo(T) == .bool) return if (value) "true" else "false";

    return std.fmt.allocPrint(allocator, "{d}", .{value});
}

pub fn join(allocator: Allocator, parts: anytype) Allocator.Error![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    inline for (parts) |part| try output.appendSlice(allocator, try text(allocator, part));

    return output.toOwnedSlice(allocator);
}

pub const nativeArgument = @import("native.zig").argument;
pub const nativeResult = @import("native.zig").convert;
