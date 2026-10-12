const std = @import("std");
/// Scratch backing for generated parser runs; a real heap so releasing the scratch arena returns its memory.
pub const scratch_backing = std.heap.smp_allocator;

/// Deep-copies a generated parser output into `allocator`, keeping text that already points into `source`.
pub fn copy(allocator: std.mem.Allocator, source: []const u8, value: anytype) std.mem.Allocator.Error!@TypeOf(value) {
    return clone(@TypeOf(value), allocator, source, value);
}

/// The bytes `copy` allocates for `value`, with room to align each allocation, so the copy fits one block.
pub fn size(source: []const u8, value: anytype) usize {
    return measure(@TypeOf(value), source, value);
}

fn measure(comptime T: type, source: []const u8, value: T) usize {
    if (comptime !hasPointers(T)) return 0;

    switch (@typeInfo(T)) {
        .pointer => |info| switch (info.size) {
            .one => return @sizeOf(info.child) + @alignOf(info.child) - 1 + measure(info.child, source, value.*),
            .slice => {
                if (info.child == u8 and borrowed(source, value)) return 0;
                if (value.len == 0) return 0;

                var total = value.len * @sizeOf(info.child) + @alignOf(info.child) - 1;

                if (comptime hasPointers(info.child)) for (value) |item| {
                    total += measure(info.child, source, item);
                };

                return total;
            },
            else => @compileError("unsupported generated parser pointer: " ++ @typeName(T)),
        },
        .optional => |info| return if (value) |item| measure(info.child, source, item) else 0,
        .@"struct" => |info| {
            var total: usize = 0;

            inline for (info.field_names) |name| total += measure(@FieldType(T, name), source, @field(value, name));

            return total;
        },
        .array => |info| {
            var total: usize = 0;

            for (value) |item| total += measure(info.child, source, item);

            return total;
        },
        else => @compileError("unsupported generated parser value: " ++ @typeName(T)),
    }
}

fn clone(comptime T: type, allocator: std.mem.Allocator, source: []const u8, value: T) std.mem.Allocator.Error!T {
    if (comptime !hasPointers(T)) return value;

    switch (@typeInfo(T)) {
        .pointer => |info| switch (info.size) {
            .one => {
                const target = try allocator.create(info.child);

                target.* = try clone(info.child, allocator, source, value.*);

                return target;
            },
            .slice => {
                if (info.child == u8 and borrowed(source, value)) return value;
                if (comptime !hasPointers(info.child)) return allocator.dupe(info.child, value);

                const target = try allocator.alloc(info.child, value.len);

                for (value, target) |item, *slot| slot.* = try clone(info.child, allocator, source, item);

                return target;
            },
            else => @compileError("unsupported generated parser pointer: " ++ @typeName(T)),
        },
        .optional => |info| return if (value) |item| try clone(info.child, allocator, source, item) else null,
        .@"struct" => |info| {
            var target: T = undefined;

            inline for (info.field_names) |name| @field(target, name) = try clone(@FieldType(T, name), allocator, source, @field(value, name));

            return target;
        },
        .array => |info| {
            var target: T = undefined;

            for (value, &target) |item, *slot| slot.* = try clone(info.child, allocator, source, item);

            return target;
        },
        else => @compileError("unsupported generated parser value: " ++ @typeName(T)),
    }
}

fn borrowed(source: []const u8, text: []const u8) bool {
    if (text.len == 0) return true;

    const start = @intFromPtr(source.ptr);
    const first = @intFromPtr(text.ptr);

    return first >= start and first + text.len <= start + source.len;
}

fn hasPointers(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .pointer => true,
        .optional => |info| hasPointers(info.child),
        .array => |info| hasPointers(info.child),
        .@"struct" => |info| inline for (info.field_names) |name| {
            if (hasPointers(@FieldType(T, name))) break true;
        } else false,
        else => false,
    };
}
