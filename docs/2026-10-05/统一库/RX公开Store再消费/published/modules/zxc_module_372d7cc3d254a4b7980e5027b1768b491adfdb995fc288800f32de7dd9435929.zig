const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: void, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = in;

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_2: u64 = (try (@import("zxc_module_5b36e241c4067c3e911e0b6eb63afc9193e11f3a3f7c7961379e0b2b58ee87a2")).call(allocator, (value_1).value));

    return value_2;
}
