const api = @import("api.zig");
const check = @import("value.zig").check;

pub fn write(comptime shape: anytype, env: api.Env, value: anytype) anyerror!api.Value {
    const T = @TypeOf(value);
    var result: api.Value = null;

    switch (@typeInfo(T)) {
        .void => try check(api.napi_get_undefined(env, &result)),
        .bool => try check(api.napi_get_boolean(env, value, &result)),
        .int => |info| try check(if (info.bits == 64)
            if (info.signedness == .signed) api.napi_create_bigint_int64(env, value, &result) else api.napi_create_bigint_uint64(env, value, &result)
        else
            api.napi_create_double(env, @floatFromInt(value), &result)),
        .float => try check(api.napi_create_double(env, value, &result)),
        .@"enum" => {
            const name = @tagName(value);

            try check(api.napi_create_string_utf8(env, name.ptr, name.len, &result));
        },
        .optional => if (value) |child| return write(shape.child, env, child) else try check(api.napi_get_null(env, &result)),
        .pointer => |info| switch (info.size) {
            .one => return write(shape, env, value.*),
            .slice => if (shape.kind == .string) {
                try check(api.napi_create_string_utf8(env, value.ptr, value.len, &result));
            } else if (info.child == u8) {
                try check(api.napi_create_buffer_copy(env, value.len, value.ptr, null, &result));
            } else {
                try check(api.napi_create_array_with_length(env, value.len, &result));
                for (value, 0..) |item, index| try check(api.napi_set_element(env, result, @intCast(index), try write(shape.child, env, item)));
            },
            else => @compileError("unsupported Node output pointer"),
        },
        .@"struct" => |info| {
            try check(if (info.is_tuple) api.napi_create_array_with_length(env, info.fields.len, &result) else api.napi_create_object(env, &result));

            inline for (info.fields, 0..) |field, index| {
                const item = try write(@field(shape.fields, field.name), env, @field(value, field.name));

                if (info.is_tuple) {
                    try check(api.napi_set_element(env, result, index, item));
                } else {
                    const property = api.Property{ .utf8name = field.name ++ "\x00", .value = item };

                    try check(api.napi_define_properties(env, result, 1, @ptrCast(&property)));
                }
            }
        },
        else => @compileError("unsupported Node output type"),
    }

    return result;
}
