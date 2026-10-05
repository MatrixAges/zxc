pub const Env = ?*opaque {};
pub const Value = ?*opaque {};
pub const Info = ?*opaque {};
pub const Status = enum(c_int) { ok = 0, pending_exception = 10, _ };
pub const Kind = enum(c_int) { undefined, null, boolean, number, string, symbol, object, function, external, bigint };
pub const Callback = *const fn (Env, Info) callconv(.c) Value;
pub const Finalize = *const fn (Env, ?*anyopaque, ?*anyopaque) callconv(.c) void;

pub const Property = extern struct {
    utf8name: ?[*:0]const u8 = null,
    name: Value = null,
    method: ?Callback = null,
    getter: ?Callback = null,
    setter: ?Callback = null,
    value: Value = null,
    attributes: c_int = 7,
    data: ?*anyopaque = null,
};

pub extern fn napi_typeof(Env, Value, *Kind) Status;
pub extern fn napi_get_undefined(Env, *Value) Status;
pub extern fn napi_get_null(Env, *Value) Status;
pub extern fn napi_get_boolean(Env, bool, *Value) Status;
pub extern fn napi_get_value_bool(Env, Value, *bool) Status;
pub extern fn napi_get_value_double(Env, Value, *f64) Status;
pub extern fn napi_create_double(Env, f64, *Value) Status;
pub extern fn napi_get_value_bigint_int64(Env, Value, *i64, *bool) Status;
pub extern fn napi_get_value_bigint_uint64(Env, Value, *u64, *bool) Status;
pub extern fn napi_create_bigint_int64(Env, i64, *Value) Status;
pub extern fn napi_create_bigint_uint64(Env, u64, *Value) Status;
pub extern fn napi_get_value_string_utf8(Env, Value, ?[*]u8, usize, *usize) Status;
pub extern fn napi_create_string_utf8(Env, [*]const u8, usize, *Value) Status;
pub extern fn napi_is_array(Env, Value, *bool) Status;
pub extern fn napi_get_array_length(Env, Value, *u32) Status;
pub extern fn napi_get_element(Env, Value, u32, *Value) Status;
pub extern fn napi_set_element(Env, Value, u32, Value) Status;
pub extern fn napi_create_array_with_length(Env, usize, *Value) Status;
pub extern fn napi_create_object(Env, *Value) Status;
pub extern fn napi_get_named_property(Env, Value, [*:0]const u8, *Value) Status;
pub extern fn napi_define_properties(Env, Value, usize, [*]const Property) Status;
pub extern fn napi_is_typedarray(Env, Value, *bool) Status;
pub extern fn napi_get_typedarray_info(Env, Value, *c_int, *usize, *?[*]u8, *Value, *usize) Status;
pub extern fn napi_create_buffer_copy(Env, usize, [*]const u8, ?*?*anyopaque, *Value) Status;
pub extern fn napi_create_function(Env, [*]const u8, usize, Callback, ?*anyopaque, *Value) Status;
pub extern fn napi_get_cb_info(Env, Info, *usize, ?[*]Value, ?*Value, *?*anyopaque) Status;
pub extern fn napi_add_finalizer(Env, Value, ?*anyopaque, Finalize, ?*anyopaque, ?*?*anyopaque) Status;
pub extern fn napi_is_exception_pending(Env, *bool) Status;
pub extern fn napi_throw_error(Env, ?[*:0]const u8, [*:0]const u8) Status;
