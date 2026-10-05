const std = @import("std");
const api = @import("api.zig");
const value_api = @import("value.zig");
const check = value_api.check;

pub fn read(comptime T: type, comptime shape: anytype, allocator: std.mem.Allocator, env: api.Env, value: api.Value) anyerror!T {
    return switch (@typeInfo(T)) {
        .void => {},
        .bool => result: {
            var result: bool = false;

            try check(api.napi_get_value_bool(env, value, &result));

            break :result result;
        },
        .int, .float => value_api.number(T, env, value),
        .@"enum" => std.meta.stringToEnum(T, try value_api.string(allocator, env, value)) orelse error.InvalidEnumMember,
        .optional => |info| if (switch (try value_api.kind(env, value)) {
            .null, .undefined => true,
            else => false,
        }) null else try read(info.child, shape.child, allocator, env, value),
        .pointer => |info| switch (info.size) {
            .one => result: {
                const result = try allocator.create(info.child);
                result.* = try read(info.child, shape, allocator, env, value);

                break :result result;
            },
            .slice => if (shape.kind == .string) value_api.string(allocator, env, value) else list(T, shape.child, allocator, env, value),
            else => @compileError("unsupported Node input pointer"),
        },
        .@"struct" => |info| result: {
            if (info.is_tuple) {
                if (try value_api.length(env, value) != info.fields.len) return error.InvalidTupleLength;
            } else if (try value_api.kind(env, value) != .object) return error.ExpectedObject;

            var result: T = undefined;

            inline for (info.fields, 0..) |field, index| {
                var item: api.Value = null;

                try check(if (info.is_tuple) api.napi_get_element(env, value, index, &item) else api.napi_get_named_property(env, value, field.name ++ "\x00", &item));

                @field(result, field.name) = try read(field.type, @field(shape.fields, field.name), allocator, env, item);
            }

            break :result result;
        },
        else => @compileError("unsupported Node input type"),
    };
}

fn list(comptime T: type, comptime child_shape: anytype, allocator: std.mem.Allocator, env: api.Env, value: api.Value) !T {
    const Child = @typeInfo(T).pointer.child;

    if (Child == u8) {
        var is_typed = false;

        try check(api.napi_is_typedarray(env, value, &is_typed));

        if (is_typed) {
            var kind: c_int = 0;
            var count: usize = 0;
            var bytes: ?[*]u8 = null;
            var buffer: api.Value = null;
            var offset: usize = 0;

            try check(api.napi_get_typedarray_info(env, value, &kind, &count, &bytes, &buffer, &offset));

            if (kind != 1 and kind != 2) return error.ExpectedByteArray;

            return if (count == 0) &.{} else allocator.dupe(u8, bytes.?[0..count]);
        }
    }

    const count = try value_api.length(env, value);
    const result = try allocator.alloc(Child, count);

    for (result, 0..) |*item, index| {
        var input: api.Value = null;

        try check(api.napi_get_element(env, value, @intCast(index), &input));

        item.* = try read(Child, child_shape, allocator, env, input);
    }

    return result;
}
