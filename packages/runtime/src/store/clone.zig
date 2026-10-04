const std = @import("std");

pub fn clone(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!@TypeOf(value) {
    const T = @TypeOf(value);

    return switch (@typeInfo(T)) {
        .void, .bool, .int, .float, .@"enum" => value,
        .optional => if (value) |child| try clone(allocator, child) else null,
        .pointer => |pointer| block: {
            if (!pointer.is_const or pointer.sentinel_ptr != null) @compileError("Store values require immutable pointers and ordinary slices");

            switch (pointer.size) {
                .one => {
                    const copied = try allocator.create(pointer.child);
                    copied.* = try clone(allocator, value.*);

                    break :block copied;
                },
                .slice => {
                    const copied = try allocator.alloc(pointer.child, value.len);

                    for (value, copied) |child, *item| item.* = try clone(allocator, child);

                    break :block copied;
                },
                else => @compileError("Store values do not support raw or C pointers"),
            }
        },
        .@"struct" => |structure| block: {
            var copied: T = undefined;

            inline for (structure.fields) |field| {
                if (!field.is_comptime) @field(copied, field.name) = try clone(allocator, @field(value, field.name));
            }

            break :block copied;
        },
        .array => |array| block: {
            if (array.sentinel_ptr != null) @compileError("Store values do not support sentinel arrays");

            var copied: T = undefined;

            for (value, &copied) |child, *item| item.* = try clone(allocator, child);

            break :block copied;
        },
        else => @compileError("Store values must use immutable ZX value types"),
    };
}
