pub const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d = struct {
    ctime_high: []const i32,
    ctime_low: []const u64,
    inodes: []const u64,
    mtime_high: []const i32,
    mtime_low: []const u64,
    paths: []const []const u8,
    read_high: []const i32,
    read_low: []const u64,
    sizes: []const u64,
};

pub const zx_type_9f60db13c3f42a0bbc892f0fa881b410bca8ae5223d74e52b03f4952105c9771 = struct {
    context: []const u8,
    files: *const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d,
    fingerprint: []const u8,
};

pub const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048 = struct {
    actual_checksum: []const u8,
    context: []const u8,
    current: *const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d,
    now_high: i32,
    now_low: u64,
    previous: *const zx_type_9f60db13c3f42a0bbc892f0fa881b410bca8ae5223d74e52b03f4952105c9771,
    stored_checksum: []const u8,
};

pub const zx_type_7970eff8567619a6c79205cd484d311286d1e449e28577c894b0b138f180bd99 = struct {
    current: *const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d,
    index: u64,
    now_high: i32,
    now_low: u64,
    previous: *const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d,
};

pub const zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31 = struct {
    index: u64,
    valid: bool,
};

pub const zx_type_ae8b14a8816c2f01df32c462c8e91c71e7ba365f24c8463ba5f9cc515e198720 = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
};

pub const zx_type_7e4a67c0a5eba2a3f58daba56c3130bf663d709de5ae586ec887356167865ae6 = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    bool,
};

pub const zx_type_9af988543a09228a944832d99abe4c574c07d09f6ea68b18108d4f7e4ba36f85 = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    bool,
    bool,
};

pub const zx_type_8b9709ee89439fff15cd9cdc1bdf08f6272e9649c1a297912ac9d4b059c9c451 = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    bool,
    bool,
    bool,
};

pub const value_41c76dfb2d7de70873a1c62b1a5977a8f8a328883c1a1a9fbf8b387a4cfb87c0 = struct {
    items: []const []const u8,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_bafd04b3069dfa6f63956592316df66b6af6e3db5b4c945d99f367975ccd475e = struct {
    items: []const u64,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_1eb706f8804136232f48dd3314e9ac995deeb5888643d8b319af4adb44b6a33c = struct {
    items: []const i32,
    storage: enum {
        plain,
        owned,
        shared,
        exclusive,
    },
};

pub const value_d41ec943c0b4593c4b9e2f7152492d459cb6faf6e435f402ef59399247e7e926 = struct {
    current: *const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d,
    index: u64,
    now_high: i32,
    now_low: u64,
    previous: *const zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d,
    zx_origin: ?*const zx_type_7970eff8567619a6c79205cd484d311286d1e449e28577c894b0b138f180bd99 = null,
};

pub const view_value_d41ec943c0b4593c4b9e2f7152492d459cb6faf6e435f402ef59399247e7e926 = value_d41ec943c0b4593c4b9e2f7152492d459cb6faf6e435f402ef59399247e7e926;

pub const value_42a6f804553c3a9ea828a44ea259a07da2d4c1fa2cbc18df6bae0a463b2fb686 = struct {
    index: u64,
    valid: bool,
    zx_origin: ?*const zx_type_94de584a9ecda0c264e410c89d52e3ee9eb060da903c58db34359720bda85c31 = null,
};

pub const view_value_42a6f804553c3a9ea828a44ea259a07da2d4c1fa2cbc18df6bae0a463b2fb686 = value_42a6f804553c3a9ea828a44ea259a07da2d4c1fa2cbc18df6bae0a463b2fb686;

pub const value_2a5f6f7840c392a2823607ece229bbcc3534a9aba36b5e92b040909e14d73528 = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    ?*const zx_type_ae8b14a8816c2f01df32c462c8e91c71e7ba365f24c8463ba5f9cc515e198720,
};

pub const view_value_2a5f6f7840c392a2823607ece229bbcc3534a9aba36b5e92b040909e14d73528 = value_2a5f6f7840c392a2823607ece229bbcc3534a9aba36b5e92b040909e14d73528;

pub const value_86a830a4ea57b11bcac868b7666ab266045d230c203b825d69d3b8c9cf176adb = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    bool,
    ?*const zx_type_7e4a67c0a5eba2a3f58daba56c3130bf663d709de5ae586ec887356167865ae6,
};

pub const view_value_86a830a4ea57b11bcac868b7666ab266045d230c203b825d69d3b8c9cf176adb = value_86a830a4ea57b11bcac868b7666ab266045d230c203b825d69d3b8c9cf176adb;

pub const value_0c9f173b868fb948da6fdafe91fe23e0b0a239f12821555059f343327a319761 = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    bool,
    bool,
    ?*const zx_type_9af988543a09228a944832d99abe4c574c07d09f6ea68b18108d4f7e4ba36f85,
};

pub const view_value_0c9f173b868fb948da6fdafe91fe23e0b0a239f12821555059f343327a319761 = value_0c9f173b868fb948da6fdafe91fe23e0b0a239f12821555059f343327a319761;

pub const value_ce41962398103cadb606ef0206ffb799fdb481caf04817150a140686db6fc59f = struct {
    *const zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048,
    bool,
    bool,
    bool,
    ?*const zx_type_8b9709ee89439fff15cd9cdc1bdf08f6272e9649c1a297912ac9d4b059c9c451,
};

pub const view_value_ce41962398103cadb606ef0206ffb799fdb481caf04817150a140686db6fc59f = value_ce41962398103cadb606ef0206ffb799fdb481caf04817150a140686db6fc59f;

pub const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

pub inline fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{
    OutOfMemory,
}![]T {
    if ((frontier and ((items).len != 0))) {
        {
            const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

            if ((((current).committed == (items).len) and (count <= (current).capacity))) {
                (current).committed = count;

                return (@constCast((items).ptr))[0..count];
            }
        }
    }

    return (try zxAllocate(T, allocator, items, count, false, 0));
}

pub inline fn zxReserveBounded(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, minimum: usize) error{
    OutOfMemory,
}![]T {
    if (((items).len == 0)) {
        return (try zxAllocate(T, allocator, items, count, true, minimum));
    }

    return (try zxReserve(T, allocator, items, count, true));
}

pub fn zxAllocate(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime exact: bool, minimum: usize) error{
    OutOfMemory,
}![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));
    const capacity: usize = (if ((exact or (@max(count, minimum) == 0))) @max(count, minimum) else ((@import("std")).math).ceilPowerOfTwoAssert(usize, @max(@max(count, minimum), 8)));

    const bytes = (try (allocator).alignedAlloc(u8, (comptime ((((@import("std")).mem).Alignment).of(T)).max((((@import("std")).mem).Alignment).of(ZxHeader))), (((@import("std")).math).add(usize, offset, (((@import("std")).math).mul(usize, capacity, @sizeOf(T)) catch {
        return error.OutOfMemory;
    })) catch {
        return error.OutOfMemory;
    })));

    const data: [*]T = @ptrCast(@alignCast(((bytes).ptr + offset)));
    const fresh: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, ((bytes).ptr + offset)) - @sizeOf(ZxHeader))));

    (fresh).* = .{
        .capacity = capacity,
        .committed = count,
    };

    @memcpy((data)[0..(items).len], items);

    return (data)[0..count];
}

pub fn zxRetract(comptime T: type, items: []const T, length: usize) void {
    const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

    (current).committed = length;
}

pub fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8, comptime exact: bool) error{
    OutOfMemory,
}!void {
    const V = @TypeOf((target).*);
    const info = @typeInfo(V);

    if ((info == .optional)) {
        if ((target).*) |*inner| {
            (try zxRenew(allocator, inner, path, exact));
        }
    } else {
        if ((info == .pointer)) {
            if ((((info).pointer).size == .slice)) {
                (target).* = (try zxReserve(((info).pointer).child, allocator, (target).*, ((target).*).len, false));
            } else {
                const fresh = (try (allocator).create(((info).pointer).child));
                (fresh).* = ((target).*).*;
                (try zxRenew(allocator, fresh, path, exact));
                (target).* = fresh;
            }
        } else {
            if (((path).len == 0)) {
                if ((!(((target).*).storage == .exclusive))) {
                    ((target).*).items = (try zxAllocate(((@typeInfo(@TypeOf(((target).*).items))).pointer).child, allocator, ((target).*).items, (((target).*).items).len, exact, 0));
                    ((target).*).storage = .exclusive;
                }
            } else {
                if (@hasField(V, ((path)[0])[1])) {
                    @field((target).*, ((path)[0])[1]) = null;
                }

                (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..], exact));
            }
        }
    }
}

pub const native = struct {};
pub const layouts = struct {};
