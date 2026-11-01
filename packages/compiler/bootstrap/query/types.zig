pub const zx_type_12 = struct { []const u8, []const []const u8, };

pub const zx_type_13 = struct {
    declarations: []const u8,
    definitions: []const u8,
    predicate: []const u8,
};

pub const zx_type_14 = struct {
    declarations: []const []const u8,
    definitions: []const u8,
    precondition: []const u8,
    violations: []const []const u8,
};

pub const zx_type_15 = struct {
    correctness: []const u8,
    feasibility: []const u8,
};

pub const zx_type_16 = struct { []const []const u8, };
pub const zx_type_17 = struct { []const []const u8, []const u8, };
pub const zx_type_18 = struct { *const zx_type_14, };
pub const zx_type_19 = struct { *const zx_type_14, []const u8, };
pub const zx_type_20 = struct { *const zx_type_14, []const u8, []const u8, };
pub const zx_type_21 = struct { *const zx_type_14, []const u8, []const u8, []const u8, };
pub const zx_type_22 = struct { *const zx_type_14, []const u8, []const u8, []const u8, []const u8, };

pub const value_8b5b328e2ecd917b5684364df048798754caedcb815c3b58a7a6a8d462ff5bb7 = struct {
    declarations: []const u8,
    definitions: []const u8,
    predicate: []const u8,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_cb929cbbf54709d9a77fce4d10fbf4e30b3c63200b125165520e116bb77c733a = struct {
    correctness: []const u8,
    feasibility: []const u8,
    zx_origin: ?*const zx_type_15 = null,
};

pub const value_e689be7af13e73b032857cc0d4b338ccb05519b3bbacc91d76fd1ddd57cb1062 = struct { []const []const u8, ?*const zx_type_16, };
pub const value_25405492ebcb9b2b18cc7ec605fc6a4d2516e12b1a768e6481625bc26424ef63 = struct { []const []const u8, []const u8, ?*const zx_type_17, };
pub const value_83a719b0d888f707950364e129fb6e358ff72962d5b02c3e753a6eba1cf77823 = struct { *const zx_type_14, ?*const zx_type_18, };
pub const value_51ae13203a07f9c0261bb2191980ed821c1ba6e9ed876ff19c863f0d6bca5e51 = struct { *const zx_type_14, []const u8, ?*const zx_type_19, };
pub const value_dfa2cc09f5a1df5928dadcc4b67c230e3d24725b09c05ff72109acaba01bd76c = struct { *const zx_type_14, []const u8, []const u8, ?*const zx_type_20, };
pub const value_76078eab89b4b2e77e08fa7c3b5d40388c36ed25bfc07b533248ecad4f835fdb = struct { *const zx_type_14, []const u8, []const u8, []const u8, ?*const zx_type_21, };
pub const value_be61c2dc8f4d7e963fde50249579a82702aea023e44e5b0e0b4991d7f801d790 = struct { *const zx_type_14, []const u8, []const u8, []const u8, []const u8, ?*const zx_type_22, };

pub const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

pub fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{ OutOfMemory, }![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));

    if ((frontier and ((items).len != 0))) {
        {
            const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

            if ((((current).committed == (items).len) and (count <= (current).capacity))) {
                (current).committed = count;

                return (@constCast((items).ptr))[0..count];
            }
        }
    }

    const capacity: usize = (if ((count == 0)) 0 else ((@import("std")).math).ceilPowerOfTwoAssert(usize, @max(count, 8)));
    const bytes = (try (allocator).alignedAlloc(u8, (comptime ((((@import("std")).mem).Alignment).of(T)).max((((@import("std")).mem).Alignment).of(ZxHeader))), (offset + (capacity * @sizeOf(T)))));
    const data: [*]T = @ptrCast(@alignCast(((bytes).ptr + offset)));
    const fresh: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, ((bytes).ptr + offset)) - @sizeOf(ZxHeader))));

    (fresh).* = .{ .capacity = capacity, .committed = count, };

    @memcpy((data)[0..(items).len], items);

    return (data)[0..count];
}

pub fn zxRetract(comptime T: type, items: []const T, length: usize) void {
    const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

    (current).committed = length;
}

pub fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8) error{ OutOfMemory, }!void {
    const V = @TypeOf((target).*);
    const info = @typeInfo(V);

    if ((info == .optional)) {
        if ((target).*) |*inner| {
            (try zxRenew(allocator, inner, path));
        }
    } else {
        if ((info == .pointer)) {
            if ((((info).pointer).size == .slice)) {
                (target).* = (try zxReserve(((info).pointer).child, allocator, (target).*, ((target).*).len, false));
            } else {
                const fresh = (try (allocator).create(((info).pointer).child));
                (fresh).* = ((target).*).*;
                (try zxRenew(allocator, fresh, path));
                (target).* = fresh;
            }
        } else {
            if (@hasField(V, ((path)[0])[1])) {
                @field((target).*, ((path)[0])[1]) = null;
            }

            (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..]));
        }
    }
}

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_bb2616f07617bc3cfb5b205b5c422bfb63bdee4b767f4f8a25a3a54be06c5efd" = struct {
        pub const join = struct {
            pub const Input = *const zx_type_12;
            pub const Output = []const u8;
            pub const InputValue = zx_type_12;
            pub const OutputValue = []const u8;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_bb2616f07617bc3cfb5b205b5c422bfb63bdee4b767f4f8a25a3a54be06c5efd" = struct {
    };
};

pub const native = struct {
    pub const @"zig:string" = (native_by_identity).@"zig:zxc_native_bb2616f07617bc3cfb5b205b5c422bfb63bdee4b767f4f8a25a3a54be06c5efd";
};

pub const layouts = struct {
    pub const @"zig:string" = (layouts_by_identity).@"zig:zxc_native_bb2616f07617bc3cfb5b205b5c422bfb63bdee4b767f4f8a25a3a54be06c5efd";
};

