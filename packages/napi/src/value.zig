const std = @import("std");
const api = @import("api.zig");

pub fn check(status: api.Status) !void {
    if (status == .pending_exception) return error.PendingException;
    if (status != .ok) return error.InvalidNodeValue;
}

pub fn kind(env: api.Env, value: api.Value) !api.Kind {
    var result: api.Kind = undefined;

    try check(api.napi_typeof(env, value, &result));

    return result;
}

pub fn string(allocator: std.mem.Allocator, env: api.Env, value: api.Value) ![]const u8 {
    var size: usize = 0;

    try check(api.napi_get_value_string_utf8(env, value, null, 0, &size));

    const bytes = try allocator.alloc(u8, try std.math.add(usize, size, 1));

    try check(api.napi_get_value_string_utf8(env, value, bytes.ptr, bytes.len, &size));

    return bytes[0..size];
}

pub fn length(env: api.Env, value: api.Value) !u32 {
    var is_array = false;

    try check(api.napi_is_array(env, value, &is_array));

    if (!is_array) return error.ExpectedArray;

    var result: u32 = 0;

    try check(api.napi_get_array_length(env, value, &result));

    return result;
}

pub fn number(comptime T: type, env: api.Env, value: api.Value) !T {
    const info = @typeInfo(T);

    if (info == .int and info.int.bits == 64) {
        var result: T = undefined;
        var lossless = false;

        try check(if (info.int.signedness == .signed) api.napi_get_value_bigint_int64(env, value, &result, &lossless) else api.napi_get_value_bigint_uint64(env, value, &result, &lossless));
        if (!lossless) return error.IntegerOutOfRange;

        return result;
    }

    var result: f64 = undefined;

    try check(api.napi_get_value_double(env, value, &result));

    if (info == .float) return @floatCast(result);
    if (!std.math.isFinite(result) or @trunc(result) != result or result < std.math.minInt(T) or result > std.math.maxInt(T)) return error.IntegerOutOfRange;

    return @intFromFloat(result);
}
