const std = @import("std");

const zx_type_12 = struct {
    level: u64,
    prefix: u64,
    source: []const u8,
};

const zx_type_13 = struct {
    index: u64,
    result: bool,
    source: []const u8,
};

const zx_type_14 = struct { *const zx_type_12, };
const zx_type_15 = struct { *const zx_type_12, bool, };

const value_8b5b328e2ecd917b5684364df048798754caedcb815c3b58a7a6a8d462ff5bb7 = struct {
    index: u64,
    result: bool,
    source: []const u8,
    zx_origin: ?*const zx_type_13 = null,
};

const value_63105dc80cf0a07d3295a4ae8e8bf4507c0eb729cbc6a3dedf896198fbdab999 = struct { *const zx_type_12, ?*const zx_type_14, };
const value_cb929cbbf54709d9a77fce4d10fbf4e30b3c63200b125165520e116bb77c733a = struct { *const zx_type_12, bool, ?*const zx_type_15, };

const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{ OutOfMemory, }![]T {
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

fn zxRetract(comptime T: type, items: []const T, length: usize) void {
    const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

    (current).committed = length;
}

fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8) error{ OutOfMemory, }!void {
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

pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_3 = .{ .kind = .object, .fields = .{ .level = zx_shape_0, .prefix = zx_shape_0, .source = zx_shape_2, }, };
const zx_shape_4 = .{ .kind = .scalar, };
pub const input_shape = zx_shape_3;
pub const output_shape = zx_shape_4;
pub const Input = *const zx_type_12;
pub const Output = bool;

pub fn executeIn(allocator: ((std).mem).Allocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: bool = (try function_0(allocator, in));

    return value_1;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    return executeIn((arena).allocator(), in);
}

pub fn executeValue(allocator: ((std).mem).Allocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: bool = (try function_0(allocator, in));

    return value_1;
}

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    if ((((((@as(u64, ((in).source).len) * @as(u64, 2)) + ((in).level * @as(u64, 4))) + (in).prefix) + @as(u64, 1)) > @as(u64, 90))) {
        return true;
    }

    return block_21: {
        const value_2: []const u8 = (in).source;

        break :block_21 block_20: {
            const operand_6 = block_5: {
                const operand_2 = value_2;
                const operand_3 = @as(u64, 0);
                const operand_4 = false;

                break :block_5 zx_type_13{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: value_8b5b328e2ecd917b5684364df048798754caedcb815c3b58a7a6a8d462ff5bb7 = value_8b5b328e2ecd917b5684364df048798754caedcb815c3b58a7a6a8d462ff5bb7{ .index = (operand_6).index, .result = (operand_6).result, .source = (operand_6).source, .zx_origin = (&operand_6), };

            while ((((state_1).index < @as(u64, ((state_1).source).len)) and (!(state_1).result))) {
                state_1 = block_19: {
                    const value_5: u8 = block_18: {
                        const operand_16 = (state_1).source;
                        const operand_17 = (state_1).index;

                        if ((operand_17 >= (operand_16).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_18 (operand_16)[@intCast(operand_17)];
                    };
                    const value_1: u8 = block_15: {
                        break :block_15 value_5;
                    };
                    const value_6: bool = (((block_12: {
                        break :block_12 value_1;
                    } == @as(u8, 123)) or (block_13: {
                        break :block_13 value_1;
                    } == @as(u8, 10))) or (block_14: {
                        break :block_14 value_1;
                    } == @as(u8, 13)));

                    break :block_19 block_11: {
                        const operand_7 = (state_1).source;
                        const operand_8 = ((state_1).index + @as(u64, 1));

                        const operand_9 = block_10: {
                            break :block_10 value_6;
                        };

                        break :block_11 @as(value_8b5b328e2ecd917b5684364df048798754caedcb815c3b58a7a6a8d462ff5bb7, value_8b5b328e2ecd917b5684364df048798754caedcb815c3b58a7a6a8d462ff5bb7{ .index = operand_8, .result = operand_9, .source = operand_7, });
                    };
                };
            }

            break :block_20 (state_1).result;
        };
    };
}

