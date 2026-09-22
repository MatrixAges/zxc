const std = @import("std");
const Error = error{ OutOfMemory, NativeTypeMismatch };

fn Parameter(comptime callee: anytype, comptime index: usize, comptime Fallback: type) type {
    const parameters = @typeInfo(@TypeOf(callee)).@"fn".params;

    if (index >= parameters.len) @compileError("native signature has fewer arguments than its registered ZX interface");

    return parameters[index].type orelse Fallback;
}

pub fn argument(comptime callee: anytype, comptime index: usize, allocator: std.mem.Allocator, value: anytype) Error!Parameter(callee, index, @TypeOf(value)) {
    return convert(Parameter(callee, index, @TypeOf(value)), allocator, value);
}

pub fn convert(comptime Target: type, allocator: std.mem.Allocator, value: anytype) Error!Target {
    const Source = @TypeOf(value);

    if (Target == Source) return value;

    return switch (@typeInfo(Target)) {
        .@"struct" => blk: {
            if (@typeInfo(Source) != .@"struct" or std.meta.fields(Target).len != std.meta.fields(Source).len) @compileError("native object shape does not match its ZX signature");

            var result: Target = undefined;

            inline for (std.meta.fields(Target)) |field| {
                if (!@hasField(Source, field.name)) @compileError("native object field is missing");

                @field(result, field.name) = try convert(field.type, allocator, @field(value, field.name));
            }

            break :blk result;
        },
        .@"enum" => std.meta.stringToEnum(Target, @tagName(value)) orelse error.NativeTypeMismatch,
        .optional => |optional| blk: {
            if (@typeInfo(Source) != .optional) @compileError("native optional shape does not match its ZX signature");

            break :blk if (value) |item| try convert(optional.child, allocator, item) else null;
        },
        .pointer => |pointer| blk: {
            if (pointer.size != .slice or @typeInfo(Source) != .pointer or @typeInfo(Source).pointer.size != .slice) @compileError("native pointer shape does not match its ZX signature");
            if (pointer.child == @typeInfo(Source).pointer.child and pointer.is_const) break :blk value;

            const result = try allocator.alloc(pointer.child, value.len);

            for (value, 0..) |item, index| result[index] = try convert(pointer.child, allocator, item);

            break :blk result;
        },
        else => @compileError("native scalar type does not match its registered ZX signature"),
    };
}
