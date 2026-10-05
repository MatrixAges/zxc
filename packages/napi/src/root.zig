pub const api = @import("api.zig");
pub const read = @import("read.zig").read;
pub const write = @import("write.zig").write;
pub const check = @import("value.zig").check;

pub fn fail(env: api.Env, err: anyerror) api.Value {
    var pending = false;

    if (api.napi_is_exception_pending(env, &pending) == .ok and !pending) {
        _ = api.napi_throw_error(env, null, @errorName(err));
    }

    return null;
}
