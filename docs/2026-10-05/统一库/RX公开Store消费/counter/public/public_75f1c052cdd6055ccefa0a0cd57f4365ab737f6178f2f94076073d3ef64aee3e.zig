const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = u64;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_2: u64 = (try (@import("zxc_module_c044739b97bc8e4ea09d77ffa272bb259170cd89137ceb594040ffae525c1171")).call(allocator, (value_1).value));

    return value_2;
}
