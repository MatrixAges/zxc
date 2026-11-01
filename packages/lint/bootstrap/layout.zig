const std = @import("std");

const zx_type_11 = struct {
    block: bool,
    boundary: bool,
    closing: bool,
    comment: bool,
    end: u64,
    gap: u64,
    newline: bool,
    object: bool,
    opening: bool,
    separator: bool,
    start: u64,
    text: []const u8,
};

const zx_type_13 = struct {
    indent_only: bool,
    level: u64,
    prefix: u64,
    suffix: u64,
    tokens: []const *const zx_type_11,
    width: u64,
};

const zx_type_18 = struct {
    depths: []const u64,
    gaps: []const u64,
    input: *const zx_type_13,
    owners: []const ?u64,
    partners: []const ?u64,
    prefixes: []const u64,
    selections: []const bool,
    trailers: []const u64,
    vertical_counts: []const u64,
    widths: []const u64,
};

const zx_type_19 = struct {
    graph: *const zx_type_18,
    wraps: []const bool,
};

const zx_type_20 = struct {
    count: u64,
    index: u64,
    level: u64,
};

const zx_type_21 = struct {
    actual: u64,
    current: []const u8,
    previous: []const u8,
};

const zx_type_22 = struct {
    graph: *const zx_type_18,
    index: u64,
    priority: u64,
};

const zx_type_24 = struct {
    graph: *const zx_type_18,
    index: u64,
    wraps: []const bool,
};

const zx_type_25 = struct { []const bool, void, };

const zx_type_26 = struct {
    done: bool,
    index: u64,
    input: *const zx_type_22,
    width: u64,
};

const zx_type_27 = struct {
    count: u64,
    index: u64,
    widths: []const u64,
};

const zx_type_28 = struct { []const u64, void, };

const zx_type_29 = struct {
    graph: *const zx_type_18,
    remaining: u64,
    widths: []const u64,
};

const zx_type_30 = struct {
    depths: []const u64,
    gaps: []const u64,
    index: u64,
    input: *const zx_type_13,
    owners: []const ?u64,
    partners: []const ?u64,
    prefix: u64,
    prefixes: []const u64,
    selection_depth: u64,
    selections: []const bool,
    stack: []const u64,
    vertical_count: u64,
    vertical_counts: []const u64,
    width: u64,
    widths: []const u64,
};

const zx_type_31 = struct { []const ?u64, void, };
const zx_type_32 = struct { []const u64, ?u64, };

const zx_type_33 = struct {
    breaks: []const *const zx_type_20,
    column: u64,
    continuation: ?u64,
    continuations: []const ?u64,
    index: u64,
    level: u64,
    levels: []const u64,
    pending: bool,
    plan: *const zx_type_19,
    previous_priority: u64,
};

const zx_type_34 = struct { []const *const zx_type_20, void, };
const zx_type_35 = struct { *const zx_type_13, };
const zx_type_36 = struct { *const zx_type_13, *const zx_type_18, };
const zx_type_37 = struct { *const zx_type_13, *const zx_type_18, []const *const zx_type_20, };
const zx_type_38 = struct { *const zx_type_13, *const zx_type_18, *const zx_type_18, };
const zx_type_39 = struct { *const zx_type_13, *const zx_type_18, *const zx_type_18, *const zx_type_19, };
const zx_type_40 = struct { *const zx_type_13, *const zx_type_18, *const zx_type_18, *const zx_type_19, []const *const zx_type_20, };

const value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e = struct {
    depths: []const u64,
    gaps: []const u64,
    input: *const zx_type_13,
    owners: []const ?u64,
    partners: []const ?u64,
    prefixes: []const u64,
    selections: []const bool,
    trailers: []const u64,
    vertical_counts: []const u64,
    widths: []const u64,
    zx_origin: ?*const zx_type_18 = null,
};

const value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd = struct {
    graph: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e,
    wraps: []const bool,
    zx_origin: ?*const zx_type_19 = null,
};

const value_5d3e8828bfb79a0b02434e75bf81807fc9ca4a276b0ce056e537edc7f1f1a013 = struct {
    actual: u64,
    current: []const u8,
    previous: []const u8,
    zx_origin: ?*const zx_type_21 = null,
};

const value_79985eb06631c9582b56297bf35143f667307b8b1a78a0e14308af5cea7dd561 = struct {
    graph: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e,
    index: u64,
    priority: u64,
    zx_origin: ?*const zx_type_22 = null,
};

const value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864 = struct {
    graph: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e,
    index: u64,
    wraps: []const bool,
    zx_origin: ?*const zx_type_24 = null,
};

const value_a1c38879412823f74bee6b3d46d653aa8fdf4a6b742c6f3128689092dc0947d7 = struct { []const bool, void, ?*const zx_type_25, };

const value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = struct {
    done: bool,
    index: u64,
    input: value_79985eb06631c9582b56297bf35143f667307b8b1a78a0e14308af5cea7dd561,
    width: u64,
    zx_origin: ?*const zx_type_26 = null,
};

const value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef = struct {
    count: u64,
    index: u64,
    widths: []const u64,
    zx_origin: ?*const zx_type_27 = null,
};

const value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658 = struct { []const u64, void, ?*const zx_type_28, };

const value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = struct {
    graph: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e,
    remaining: u64,
    widths: []const u64,
    zx_origin: ?*const zx_type_29 = null,
};

const value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = struct {
    depths: []const u64,
    gaps: []const u64,
    index: u64,
    input: *const zx_type_13,
    owners: []const ?u64,
    partners: []const ?u64,
    prefix: u64,
    prefixes: []const u64,
    selection_depth: u64,
    selections: []const bool,
    stack: []const u64,
    vertical_count: u64,
    vertical_counts: []const u64,
    width: u64,
    widths: []const u64,
    zx_origin: ?*const zx_type_30 = null,
};

const value_1eb4afd7f7f0d42a4f5fbed4ac0993b8f0388f7a17fdcaa1c00e1a4f08d936b2 = struct { []const ?u64, void, ?*const zx_type_31, };
const value_06d4e5bb0ca23902f4bd02eaacc137074b7490f6f2531cc32dff07bb7465ff2d = struct { []const u64, ?u64, ?*const zx_type_32, };

const value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = struct {
    breaks: []const *const zx_type_20,
    column: u64,
    continuation: ?u64,
    continuations: []const ?u64,
    index: u64,
    level: u64,
    levels: []const u64,
    pending: bool,
    plan: value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd,
    previous_priority: u64,
    zx_origin: ?*const zx_type_33 = null,
};

const value_9db904219b812256c60975c9cf1bdae456f04f62a8c64021793f76943089758d = struct { []const *const zx_type_20, void, ?*const zx_type_34, };
const value_5c42655d9559008bbea9c4d253cffc7b8430e0758ba7c8599e00ad8111200d4d = struct { *const zx_type_13, ?*const zx_type_35, };
const value_e1017d7de6547c6309c3dd9933bfed88357f662eaa969199b28e2a61b48a11d8 = struct { *const zx_type_13, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, ?*const zx_type_36, };
const value_fcc052b4e7d90d94ddd85e493b279a30480e6d068acb5b5c338d90373c221815 = struct { *const zx_type_13, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, []const *const zx_type_20, ?*const zx_type_37, };
const value_7557456f239e9a08b6b86e0ee7fe153741b92360d48099d3f2a182a288fc9eef = struct { *const zx_type_13, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, ?*const zx_type_38, };
const value_3578088f60c41a96cf3700d34eba3befcd3719d295b0e68482413f6586e0841e = struct { *const zx_type_13, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd, ?*const zx_type_39, };
const value_41f865e379e1ae89c7a28b24ce1b4a6af4c2e1d7f03b7c7128471c520065f385 = struct { *const zx_type_13, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd, []const *const zx_type_20, ?*const zx_type_40, };

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
const zx_shape_2 = .{ .kind = .string, };
const zx_shape_3 = .{ .kind = .object, .fields = .{ .block = zx_shape_0, .boundary = zx_shape_0, .closing = zx_shape_0, .comment = zx_shape_0, .end = zx_shape_1, .gap = zx_shape_1, .newline = zx_shape_0, .object = zx_shape_0, .opening = zx_shape_0, .separator = zx_shape_0, .start = zx_shape_1, .text = zx_shape_2, }, };
const zx_shape_4 = .{ .kind = .list, .child = zx_shape_3, };
const zx_shape_5 = .{ .kind = .object, .fields = .{ .indent_only = zx_shape_0, .level = zx_shape_1, .prefix = zx_shape_1, .suffix = zx_shape_1, .tokens = zx_shape_4, .width = zx_shape_1, }, };
const zx_shape_6 = .{ .kind = .object, .fields = .{ .count = zx_shape_1, .index = zx_shape_1, .level = zx_shape_1, }, };
const zx_shape_7 = .{ .kind = .list, .child = zx_shape_6, };
pub const input_shape = zx_shape_5;
pub const output_shape = zx_shape_7;
pub const Input = *const zx_type_13;
pub const Output = []const *const zx_type_20;

pub fn executeIn(allocator: ((std).mem).Allocator, in: *const zx_type_13) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const zx_type_20 {
    @setRuntimeSafety(true);

    const value_1: *const zx_type_18 = block_24: {
        const operand_20 = in;
        const operand_21 = (try function_5_value(allocator, operand_20));

        break :block_24 (if (((operand_21).zx_origin != null)) (operand_21).zx_origin.? else block_23: {
            const operand_22 = (try (allocator).create(zx_type_18));

            (operand_22).* = zx_type_18{ .depths = (operand_21).depths, .gaps = (operand_21).gaps, .input = (operand_21).input, .owners = (operand_21).owners, .partners = (operand_21).partners, .prefixes = (operand_21).prefixes, .selections = (operand_21).selections, .trailers = (operand_21).trailers, .vertical_counts = (operand_21).vertical_counts, .widths = (operand_21).widths, };

            break :block_23 @as(*const zx_type_18, operand_22);
        });
    };

    const switch_13 = (in).indent_only;

    if ((switch_13 == true)) {
        const value_2: []const *const zx_type_20 = (try function_6(allocator, block_19: {
            const operand_14 = value_1;

            const operand_15 = block_16: {
                break :block_16 (try (allocator).dupe(bool, (&[_]bool{})));
            };

            break :block_19 block_18: {
                const operand_17 = (try (allocator).create(zx_type_19));

                (operand_17).* = @as(zx_type_19, zx_type_19{ .graph = operand_14, .wraps = operand_15, });

                break :block_18 @as(*const zx_type_19, operand_17);
            };
        }));

        return value_2;
    }

    const value_3: *const zx_type_18 = block_12: {
        const operand_8 = value_1;
        const operand_9 = (try function_4_value(allocator, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (operand_8).depths, .gaps = (operand_8).gaps, .input = (operand_8).input, .owners = (operand_8).owners, .partners = (operand_8).partners, .prefixes = (operand_8).prefixes, .selections = (operand_8).selections, .trailers = (operand_8).trailers, .vertical_counts = (operand_8).vertical_counts, .widths = (operand_8).widths, .zx_origin = operand_8, }));

        break :block_12 (if (((operand_9).zx_origin != null)) (operand_9).zx_origin.? else block_11: {
            const operand_10 = (try (allocator).create(zx_type_18));

            (operand_10).* = zx_type_18{ .depths = (operand_9).depths, .gaps = (operand_9).gaps, .input = (operand_9).input, .owners = (operand_9).owners, .partners = (operand_9).partners, .prefixes = (operand_9).prefixes, .selections = (operand_9).selections, .trailers = (operand_9).trailers, .vertical_counts = (operand_9).vertical_counts, .widths = (operand_9).widths, };

            break :block_11 @as(*const zx_type_18, operand_10);
        });
    };

    const value_4: *const zx_type_19 = block_7: {
        const operand_1 = value_3;
        const operand_2 = (try function_1_value(allocator, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (operand_1).depths, .gaps = (operand_1).gaps, .input = (operand_1).input, .owners = (operand_1).owners, .partners = (operand_1).partners, .prefixes = (operand_1).prefixes, .selections = (operand_1).selections, .trailers = (operand_1).trailers, .vertical_counts = (operand_1).vertical_counts, .widths = (operand_1).widths, .zx_origin = operand_1, }));

        break :block_7 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_6: {
            const operand_5 = (try (allocator).create(zx_type_19));

            (operand_5).* = zx_type_19{ .graph = (if ((((operand_2).graph).zx_origin != null)) ((operand_2).graph).zx_origin.? else block_4: {
                const operand_3 = (try (allocator).create(zx_type_18));

                (operand_3).* = zx_type_18{ .depths = ((operand_2).graph).depths, .gaps = ((operand_2).graph).gaps, .input = ((operand_2).graph).input, .owners = ((operand_2).graph).owners, .partners = ((operand_2).graph).partners, .prefixes = ((operand_2).graph).prefixes, .selections = ((operand_2).graph).selections, .trailers = ((operand_2).graph).trailers, .vertical_counts = ((operand_2).graph).vertical_counts, .widths = ((operand_2).graph).widths, };

                break :block_4 @as(*const zx_type_18, operand_3);
            }), .wraps = (operand_2).wraps, };

            break :block_6 @as(*const zx_type_19, operand_5);
        });
    };

    const value_5: []const *const zx_type_20 = (try function_6(allocator, value_4));

    return value_5;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_13) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const zx_type_20 {
    return executeIn((arena).allocator(), in);
}

pub fn executeValue(allocator: ((std).mem).Allocator, in: *const zx_type_13) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const zx_type_20 {
    @setRuntimeSafety(true);

    const value_1: *const zx_type_18 = block_48: {
        const operand_44 = in;
        const operand_45 = (try function_5_value(allocator, operand_44));

        break :block_48 (if (((operand_45).zx_origin != null)) (operand_45).zx_origin.? else block_47: {
            const operand_46 = (try (allocator).create(zx_type_18));

            (operand_46).* = zx_type_18{ .depths = (operand_45).depths, .gaps = (operand_45).gaps, .input = (operand_45).input, .owners = (operand_45).owners, .partners = (operand_45).partners, .prefixes = (operand_45).prefixes, .selections = (operand_45).selections, .trailers = (operand_45).trailers, .vertical_counts = (operand_45).vertical_counts, .widths = (operand_45).widths, };

            break :block_47 @as(*const zx_type_18, operand_46);
        });
    };

    const switch_37 = (in).indent_only;

    if ((switch_37 == true)) {
        const value_2: []const *const zx_type_20 = (try function_6(allocator, block_43: {
            const operand_38 = value_1;

            const operand_39 = block_40: {
                break :block_40 (try (allocator).dupe(bool, (&[_]bool{})));
            };

            break :block_43 block_42: {
                const operand_41 = (try (allocator).create(zx_type_19));

                (operand_41).* = @as(zx_type_19, zx_type_19{ .graph = operand_38, .wraps = operand_39, });

                break :block_42 @as(*const zx_type_19, operand_41);
            };
        }));

        return value_2;
    }

    const value_3: *const zx_type_18 = block_36: {
        const operand_32 = value_1;
        const operand_33 = (try function_4_value(allocator, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (operand_32).depths, .gaps = (operand_32).gaps, .input = (operand_32).input, .owners = (operand_32).owners, .partners = (operand_32).partners, .prefixes = (operand_32).prefixes, .selections = (operand_32).selections, .trailers = (operand_32).trailers, .vertical_counts = (operand_32).vertical_counts, .widths = (operand_32).widths, .zx_origin = operand_32, }));

        break :block_36 (if (((operand_33).zx_origin != null)) (operand_33).zx_origin.? else block_35: {
            const operand_34 = (try (allocator).create(zx_type_18));

            (operand_34).* = zx_type_18{ .depths = (operand_33).depths, .gaps = (operand_33).gaps, .input = (operand_33).input, .owners = (operand_33).owners, .partners = (operand_33).partners, .prefixes = (operand_33).prefixes, .selections = (operand_33).selections, .trailers = (operand_33).trailers, .vertical_counts = (operand_33).vertical_counts, .widths = (operand_33).widths, };

            break :block_35 @as(*const zx_type_18, operand_34);
        });
    };

    const value_4: *const zx_type_19 = block_31: {
        const operand_25 = value_3;
        const operand_26 = (try function_1_value(allocator, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (operand_25).depths, .gaps = (operand_25).gaps, .input = (operand_25).input, .owners = (operand_25).owners, .partners = (operand_25).partners, .prefixes = (operand_25).prefixes, .selections = (operand_25).selections, .trailers = (operand_25).trailers, .vertical_counts = (operand_25).vertical_counts, .widths = (operand_25).widths, .zx_origin = operand_25, }));

        break :block_31 (if (((operand_26).zx_origin != null)) (operand_26).zx_origin.? else block_30: {
            const operand_29 = (try (allocator).create(zx_type_19));

            (operand_29).* = zx_type_19{ .graph = (if ((((operand_26).graph).zx_origin != null)) ((operand_26).graph).zx_origin.? else block_28: {
                const operand_27 = (try (allocator).create(zx_type_18));

                (operand_27).* = zx_type_18{ .depths = ((operand_26).graph).depths, .gaps = ((operand_26).graph).gaps, .input = ((operand_26).graph).input, .owners = ((operand_26).graph).owners, .partners = ((operand_26).graph).partners, .prefixes = ((operand_26).graph).prefixes, .selections = ((operand_26).graph).selections, .trailers = ((operand_26).graph).trailers, .vertical_counts = ((operand_26).graph).vertical_counts, .widths = ((operand_26).graph).widths, };

                break :block_28 @as(*const zx_type_18, operand_27);
            }), .wraps = (operand_26).wraps, };

            break :block_30 @as(*const zx_type_19, operand_29);
        });
    };

    const value_5: []const *const zx_type_20 = (try function_6(allocator, value_4));

    return value_5;
}

fn function_6(allocator: ((std).mem).Allocator, in: *const zx_type_19) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const zx_type_20 {
    @setRuntimeSafety(true);

    const value_1: []const *const zx_type_20 = block_294: {
        break :block_294 (try (allocator).dupe(*const zx_type_20, (&[_]*const zx_type_20{})));
    };

    const value_2: []const u64 = block_293: {
        break :block_293 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_3: []const ?u64 = block_292: {
        break :block_292 (try (allocator).dupe(?u64, (&[_]?u64{})));
    };

    const value_4: ?u64 = @as(?u64, null);

    return (block_291: {
        const operand_13 = block_12: {
            const operand_2 = in;
            const operand_3 = value_1;
            const operand_4 = value_2;
            const operand_5 = value_3;
            const operand_6 = (((in).graph).input).level;
            const operand_7 = value_4;
            const operand_8 = @as(u64, 0);
            const operand_9 = false;
            const operand_10 = (((((in).graph).input).level * @as(u64, 4)) + (((in).graph).input).prefix);
            const operand_11 = @as(u64, 0);

            break :block_12 zx_type_33{ .plan = operand_2, .breaks = operand_3, .levels = operand_4, .continuations = operand_5, .level = operand_6, .continuation = operand_7, .previous_priority = operand_8, .pending = operand_9, .column = operand_10, .index = operand_11, };
        };

        var state_1: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (operand_13).breaks, .column = (operand_13).column, .continuation = (operand_13).continuation, .continuations = (operand_13).continuations, .index = (operand_13).index, .level = (operand_13).level, .levels = (operand_13).levels, .pending = (operand_13).pending, .plan = value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd{ .graph = value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (((operand_13).plan).graph).depths, .gaps = (((operand_13).plan).graph).gaps, .input = (((operand_13).plan).graph).input, .owners = (((operand_13).plan).graph).owners, .partners = (((operand_13).plan).graph).partners, .prefixes = (((operand_13).plan).graph).prefixes, .selections = (((operand_13).plan).graph).selections, .trailers = (((operand_13).plan).graph).trailers, .vertical_counts = (((operand_13).plan).graph).vertical_counts, .widths = (((operand_13).plan).graph).widths, .zx_origin = ((operand_13).plan).graph, }, .wraps = ((operand_13).plan).wraps, .zx_origin = (operand_13).plan, }, .previous_priority = (operand_13).previous_priority, .zx_origin = (&operand_13), };

        while (((state_1).index < @as(u64, (((((state_1).plan).graph).input).tokens).len))) {
            state_1 = block_284: {
                const value_7: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e = ((state_1).plan).graph;

                const value_8: *const zx_type_11 = block_283: {
                    const operand_281 = ((value_7).input).tokens;
                    const operand_282 = (state_1).index;

                    if ((operand_282 >= (operand_281).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_283 (operand_281)[@intCast(operand_282)];
                };
                const value_9: ?u64 = block_280: {
                    const operand_278 = (value_7).owners;
                    const operand_279 = (state_1).index;

                    if ((operand_279 >= (operand_278).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_280 (operand_278)[@intCast(operand_279)];
                };
                const value_10: ?u64 = block_277: {
                    const operand_275 = (value_7).partners;
                    const operand_276 = (state_1).index;

                    if ((operand_276 >= (operand_275).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_277 (operand_275)[@intCast(operand_276)];
                };

                const value_11: bool = ((block_273: {
                    break :block_273 value_10;
                } != null) and (block_274: {
                    break :block_274 value_10;
                }.? < (state_1).index));

                const value_12: bool = ((block_271: {
                    break :block_271 value_10;
                } != null) and (block_272: {
                    break :block_272 value_10;
                }.? > (state_1).index));

                const value_13: bool = (!((value_7).input).indent_only);

                const value_14: bool = (((block_264: {
                    break :block_264 value_13;
                } and (block_265: {
                    break :block_265 value_9;
                } != null)) and ((block_266: {
                    break :block_266 value_9;
                }.? + @as(u64, 1)) == (state_1).index)) and block_270: {
                    const operand_268 = ((state_1).plan).wraps;

                    const operand_269 = block_267: {
                        break :block_267 value_9;
                    }.?;

                    if ((operand_269 >= (operand_268).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_270 (operand_268)[@intCast(operand_269)];
                });

                const value_15: bool = (((state_1).index != @as(u64, 0)) and (block_260: {
                    const operand_258 = (block_257: {
                        const operand_255 = ((value_7).input).tokens;
                        const operand_256 = ((state_1).index - @as(u64, 1));

                        if ((operand_256 >= (operand_255).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_257 (operand_255)[@intCast(operand_256)];
                    }).text;

                    const operand_259 = @as([]const u8, ",");

                    break :block_260 ((std).mem).eql(u8, operand_258, operand_259);
                } or (block_263: {
                    const operand_261 = ((value_7).input).tokens;
                    const operand_262 = ((state_1).index - @as(u64, 1));

                    if ((operand_262 >= (operand_261).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_263 (operand_261)[@intCast(operand_262)];
                }).separator));

                const value_16: bool = (((block_248: {
                    break :block_248 value_13;
                } and block_249: {
                    break :block_249 value_15;
                }) and (block_250: {
                    break :block_250 value_9;
                } != null)) and block_254: {
                    const operand_252 = ((state_1).plan).wraps;

                    const operand_253 = block_251: {
                        break :block_251 value_9;
                    }.?;

                    if ((operand_253 >= (operand_252).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_254 (operand_252)[@intCast(operand_253)];
                });

                const value_17: bool = (((block_241: {
                    break :block_241 value_13;
                } and block_242: {
                    break :block_242 value_11;
                }) and (block_243: {
                    break :block_243 value_10;
                } != null)) and block_247: {
                    const operand_245 = ((state_1).plan).wraps;

                    const operand_246 = block_244: {
                        break :block_244 value_10;
                    }.?;

                    if ((operand_246 >= (operand_245).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_247 (operand_245)[@intCast(operand_246)];
                });

                const value_18: u64 = (if ((((value_7).input).width == @as(u64, 0))) @as(u64, 90) else ((value_7).input).width);

                const value_19: u64 = (if ((block_239: {
                    break :block_239 value_18;
                } > ((value_7).input).suffix)) (block_240: {
                    break :block_240 value_18;
                } - ((value_7).input).suffix) else @as(u64, 0));

                const value_20: bool = ((state_1).previous_priority != @as(u64, 0));

                const value_21: u64 = (if ((block_228: {
                    break :block_228 value_13;
                } and block_229: {
                    break :block_229 value_20;
                })) block_238: {
                    const operand_230 = value_7;
                    var state_borrow_231: zx_type_18 = undefined;
                    state_borrow_231 = zx_type_18{ .depths = (operand_230).depths, .gaps = (operand_230).gaps, .input = (operand_230).input, .owners = (operand_230).owners, .partners = (operand_230).partners, .prefixes = (operand_230).prefixes, .selections = (operand_230).selections, .trailers = (operand_230).trailers, .vertical_counts = (operand_230).vertical_counts, .widths = (operand_230).widths, };
                    const operand_232 = ((operand_230).zx_origin orelse (&state_borrow_231));
                    const operand_233 = (state_1).index;
                    const operand_234 = (state_1).previous_priority;
                    const operand_235 = value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (operand_232).depths, .gaps = (operand_232).gaps, .input = (operand_232).input, .owners = (operand_232).owners, .partners = (operand_232).partners, .prefixes = (operand_232).prefixes, .selections = (operand_232).selections, .trailers = (operand_232).trailers, .vertical_counts = (operand_232).vertical_counts, .widths = (operand_232).widths, .zx_origin = operand_232, };
                    var state_borrow_236: zx_type_18 = undefined;

                    state_borrow_236 = zx_type_18{ .depths = (operand_235).depths, .gaps = (operand_235).gaps, .input = (operand_235).input, .owners = (operand_235).owners, .partners = (operand_235).partners, .prefixes = (operand_235).prefixes, .selections = (operand_235).selections, .trailers = (operand_235).trailers, .vertical_counts = (operand_235).vertical_counts, .widths = (operand_235).widths, };

                    const operand_237 = zx_type_22{ .graph = ((operand_235).zx_origin orelse (&state_borrow_236)), .index = operand_233, .priority = operand_234, };

                    break :block_238 (try function_3(allocator, (&operand_237)));
                } else @as(u64, 0));

                const value_22: bool = (((block_223: {
                    break :block_223 value_13;
                } and block_224: {
                    break :block_224 value_20;
                }) and (!(block_225: {
                    break :block_225 value_8;
                }).newline)) and (((state_1).column + block_226: {
                    break :block_226 value_21;
                }) > block_227: {
                    break :block_227 value_19;
                }));

                const value_23: bool = block_222: {
                    const operand_220 = (block_219: {
                        break :block_219 value_8;
                    }).text;

                    const operand_221 = @as([]const u8, ".");

                    break :block_222 ((std).mem).eql(u8, operand_220, operand_221);
                };

                const value_24: u64 = ((state_1).index + @as(u64, 1));
                const value_25: u64 = ((state_1).index + @as(u64, 2));

                const value_26: u64 = (if ((block_214: {
                    break :block_214 value_24;
                } < @as(u64, (((value_7).input).tokens).len))) @as(u64, ((block_218: {
                    const operand_216 = ((value_7).input).tokens;

                    const operand_217 = block_215: {
                        break :block_215 value_24;
                    };

                    if ((operand_217 >= (operand_216).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_218 (operand_216)[@intCast(operand_217)];
                }).text).len) else @as(u64, 0));

                const value_27: bool = ((block_199: {
                    break :block_199 value_25;
                } < @as(u64, (((value_7).input).tokens).len)) and (block_206: {
                    const operand_204 = (block_203: {
                        const operand_201 = ((value_7).input).tokens;

                        const operand_202 = block_200: {
                            break :block_200 value_25;
                        };

                        if ((operand_202 >= (operand_201).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_203 (operand_201)[@intCast(operand_202)];
                    }).text;

                    const operand_205 = @as([]const u8, "(");

                    break :block_206 ((std).mem).eql(u8, operand_204, operand_205);
                } or block_213: {
                    const operand_211 = (block_210: {
                        const operand_208 = ((value_7).input).tokens;

                        const operand_209 = block_207: {
                            break :block_207 value_25;
                        };

                        if ((operand_209 >= (operand_208).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_210 (operand_208)[@intCast(operand_209)];
                    }).text;

                    const operand_212 = @as([]const u8, "[");

                    break :block_213 ((std).mem).eql(u8, operand_211, operand_212);
                }));

                const value_28: ?u64 = (if (block_194: {
                    break :block_194 value_27;
                }) block_198: {
                    const operand_196 = (value_7).partners;

                    const operand_197 = block_195: {
                        break :block_195 value_25;
                    };

                    if ((operand_197 >= (operand_196).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_198 (operand_196)[@intCast(operand_197)];
                } else @as(?u64, null));

                const value_29: bool = ((block_188: {
                    break :block_188 value_13;
                } and (block_189: {
                    break :block_189 value_28;
                } != null)) and (block_193: {
                    const operand_191 = ((value_7).input).tokens;

                    const operand_192 = block_190: {
                        break :block_190 value_25;
                    };

                    if ((operand_192 >= (operand_191).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_193 (operand_191)[@intCast(operand_192)];
                }).block);

                const value_30: u64 = (if ((block_174: {
                    break :block_174 value_29;
                } and (block_175: {
                    break :block_175 value_28;
                } != null))) ((block_179: {
                    const operand_177 = (value_7).widths;

                    const operand_178 = block_176: {
                        break :block_176 value_28;
                    }.?;

                    if ((operand_178 >= (operand_177).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_179 (operand_177)[@intCast(operand_178)];
                } - block_183: {
                    const operand_181 = (value_7).widths;

                    const operand_182 = block_180: {
                        break :block_180 value_25;
                    };

                    if ((operand_182 >= (operand_181).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_183 (operand_181)[@intCast(operand_182)];
                }) + @as(u64, ((block_187: {
                    const operand_185 = ((value_7).input).tokens;

                    const operand_186 = block_184: {
                        break :block_184 value_28;
                    }.?;

                    if ((operand_186 >= (operand_185).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_187 (operand_185)[@intCast(operand_186)];
                }).text).len)) else @as(u64, 0));

                const value_31: u64 = (((@as(u64, ((block_170: {
                    break :block_170 value_8;
                }).text).len) + block_171: {
                    break :block_171 value_26;
                }) + (if (block_172: {
                    break :block_172 value_27;
                }) @as(u64, 1) else @as(u64, 0))) + block_173: {
                    break :block_173 value_30;
                });

                const value_32: bool = (((block_165: {
                    break :block_165 value_13;
                } and block_166: {
                    break :block_166 value_23;
                }) and (!(block_167: {
                    break :block_167 value_8;
                }).newline)) and (((state_1).column + block_168: {
                    break :block_168 value_31;
                }) > block_169: {
                    break :block_169 value_19;
                }));

                const value_33: bool = ((((((state_1).pending or block_160: {
                    break :block_160 value_14;
                }) or block_161: {
                    break :block_161 value_16;
                }) or block_162: {
                    break :block_162 value_17;
                }) or block_163: {
                    break :block_163 value_22;
                }) or block_164: {
                    break :block_164 value_32;
                });

                const value_34: bool = ((block_158: {
                    break :block_158 value_8;
                }).comment and (!(block_159: {
                    break :block_159 value_8;
                }).newline));

                const value_35: bool = ((block_155: {
                    break :block_155 value_8;
                }).newline or (block_156: {
                    break :block_156 value_33;
                } and (!block_157: {
                    break :block_157 value_34;
                })));

                const value_36: bool = ((block_146: {
                    break :block_146 value_9;
                } != null) and (block_150: {
                    const operand_148 = (block_147: {
                        break :block_147 value_8;
                    }).text;

                    const operand_149 = @as([]const u8, "case");

                    break :block_150 ((std).mem).eql(u8, operand_148, operand_149);
                } or block_154: {
                    const operand_152 = (block_151: {
                        break :block_151 value_8;
                    }).text;

                    const operand_153 = @as([]const u8, "default");

                    break :block_154 ((std).mem).eql(u8, operand_152, operand_153);
                }));

                const value_49: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if ((((state_1).index == @as(u64, 0)) or block_99: {
                    break :block_99 value_35;
                })) block_145: {
                    const value_37: u64 = (if ((block_140: {
                        break :block_140 value_9;
                    } != null)) (block_144: {
                        const operand_142 = (state_1).levels;

                        const operand_143 = block_141: {
                            break :block_141 value_9;
                        }.?;

                        if ((operand_143 >= (operand_142).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_144 (operand_142)[@intCast(operand_143)];
                    } + @as(u64, 1)) else ((value_7).input).level);

                    const value_38: bool = (((block_134: {
                        break :block_134 value_9;
                    } != null) and block_138: {
                        const operand_136 = (value_7).selections;

                        const operand_137 = block_135: {
                            break :block_135 value_9;
                        }.?;

                        if ((operand_137 >= (operand_136).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_138 (operand_136)[@intCast(operand_137)];
                    }) and (!block_139: {
                        break :block_139 value_36;
                    }));

                    const value_39: u64 = (block_132: {
                        break :block_132 value_37;
                    } + (if (block_133: {
                        break :block_133 value_38;
                    }) @as(u64, 1) else @as(u64, 0)));

                    const value_40: u64 = (if ((block_125: {
                        break :block_125 value_11;
                    } and (block_126: {
                        break :block_126 value_10;
                    } != null))) block_130: {
                        const operand_128 = (state_1).levels;

                        const operand_129 = block_127: {
                            break :block_127 value_10;
                        }.?;

                        if ((operand_129 >= (operand_128).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_130 (operand_128)[@intCast(operand_129)];
                    } else block_131: {
                        break :block_131 value_39;
                    });

                    const value_46: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if ((((block_103: {
                        break :block_103 value_20;
                    } or block_104: {
                        break :block_104 value_23;
                    }) and (!block_105: {
                        break :block_105 value_11;
                    })) and (!block_106: {
                        break :block_106 value_36;
                    }))) block_114: {
                        const value_41: u64 = ((state_1).continuation orelse ((state_1).level + @as(u64, 1)));

                        const value_42: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_113: {
                            break :block_113 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (state_1).breaks, .column = (state_1).column, .continuation = @as(?u64, block_112: {
                                break :block_112 value_41;
                            }), .continuations = (state_1).continuations, .index = (state_1).index, .level = (state_1).level, .levels = (state_1).levels, .pending = (state_1).pending, .plan = (state_1).plan, .previous_priority = (state_1).previous_priority, });
                        };
                        const value_43: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_111: {
                            break :block_111 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_42).breaks, .column = (value_42).column, .continuation = (value_42).continuation, .continuations = (value_42).continuations, .index = (value_42).index, .level = (if ((block_107: {
                                break :block_107 value_40;
                            } > block_108: {
                                break :block_108 value_41;
                            })) block_109: {
                                break :block_109 value_40;
                            } else block_110: {
                                break :block_110 value_41;
                            }), .levels = (value_42).levels, .pending = (value_42).pending, .plan = (value_42).plan, .previous_priority = (value_42).previous_priority, });
                        };

                        break :block_114 value_43;
                    } else block_124: {
                        const value_44: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_123: {
                            break :block_123 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (state_1).breaks, .column = (state_1).column, .continuation = (if ((block_117: {
                                break :block_117 value_11;
                            } and (block_118: {
                                break :block_118 value_10;
                            } != null))) block_122: {
                                const operand_120 = (state_1).continuations;
                                const operand_121 = block_119: {
                                    break :block_119 value_10;
                                }.?;

                                if ((operand_121 >= (operand_120).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_122 (operand_120)[@intCast(operand_121)];
                            } else @as(?u64, null)), .continuations = (state_1).continuations, .index = (state_1).index, .level = (state_1).level, .levels = (state_1).levels, .pending = (state_1).pending, .plan = (state_1).plan, .previous_priority = (state_1).previous_priority, });
                        };
                        const value_45: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_116: {
                            break :block_116 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_44).breaks, .column = (value_44).column, .continuation = (value_44).continuation, .continuations = (value_44).continuations, .index = (value_44).index, .level = block_115: {
                                break :block_115 value_40;
                            }, .levels = (value_44).levels, .pending = (value_44).pending, .plan = (value_44).plan, .previous_priority = (value_44).previous_priority, });
                        };

                        break :block_124 value_45;
                    });

                    const value_48: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if (block_100: {
                        break :block_100 value_35;
                    }) block_102: {
                        const value_47: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_101: {
                            break :block_101 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_46).breaks, .column = ((value_46).level * @as(u64, 4)), .continuation = (value_46).continuation, .continuations = (value_46).continuations, .index = (value_46).index, .level = (value_46).level, .levels = (value_46).levels, .pending = (value_46).pending, .plan = (value_46).plan, .previous_priority = (value_46).previous_priority, });
                        };

                        break :block_102 value_47;
                    } else value_46);

                    break :block_145 value_48;
                } else state_1);

                const value_50: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_98: {
                    break :block_98 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_49).breaks, .column = (value_49).column, .continuation = (value_49).continuation, .continuations = (value_49).continuations, .index = (value_49).index, .level = (value_49).level, .levels = (block_97: {
                        const operand_93 = (value_49).levels;
                        const operand_94 = (value_49).level;
                        const operand_95 = (try ((std).math).add(usize, (operand_93).len, 1));
                        const operand_96 = (try zxReserve(u64, allocator, operand_93, operand_95, true));

                        (operand_96)[(operand_93).len] = operand_94;

                        break :block_97 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_96, {}, null, });
                    }).@"0", .pending = (value_49).pending, .plan = (value_49).plan, .previous_priority = (value_49).previous_priority, });
                };
                const value_51: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_92: {
                    break :block_92 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_50).breaks, .column = (value_50).column, .continuation = (value_50).continuation, .continuations = (block_91: {
                        const operand_87 = (value_50).continuations;
                        const operand_88 = (value_50).continuation;
                        const operand_89 = (try ((std).math).add(usize, (operand_87).len, 1));
                        const operand_90 = (try zxReserve(?u64, allocator, operand_87, operand_89, true));

                        (operand_90)[(operand_87).len] = operand_88;

                        break :block_91 @as(value_1eb4afd7f7f0d42a4f5fbed4ac0993b8f0388f7a17fdcaa1c00e1a4f08d936b2, .{ operand_90, {}, null, });
                    }).@"0", .index = (value_50).index, .level = (value_50).level, .levels = (value_50).levels, .pending = (value_50).pending, .plan = (value_50).plan, .previous_priority = (value_50).previous_priority, });
                };
                const value_59: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if (((((block_42: {
                    break :block_42 value_13;
                } and block_43: {
                    break :block_43 value_12;
                }) and (block_44: {
                    break :block_44 value_10;
                } != null)) and (block_45: {
                    break :block_45 value_10;
                }.? > ((value_51).index + @as(u64, 1)))) and (!(block_46: {
                    break :block_46 value_8;
                }).block))) block_86: {
                    const value_52: bool = (block_82: {
                        const operand_80 = (value_7).vertical_counts;

                        const operand_81 = block_79: {
                            break :block_79 value_10;
                        }.?;

                        if ((operand_81 >= (operand_80).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_82 (operand_80)[@intCast(operand_81)];
                    } > block_85: {
                        const operand_83 = (value_7).vertical_counts;
                        const operand_84 = (value_51).index;

                        if ((operand_84 >= (operand_83).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_85 (operand_83)[@intCast(operand_84)];
                    });

                    const value_53: u64 = (if (((block_74: {
                        break :block_74 value_10;
                    }.? + @as(u64, 1)) < @as(u64, ((value_7).trailers).len))) block_78: {
                        const operand_76 = (value_7).trailers;

                        const operand_77 = (block_75: {
                            break :block_75 value_10;
                        }.? + @as(u64, 1));

                        if ((operand_77 >= (operand_76).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_78 (operand_76)[@intCast(operand_77)];
                    } else @as(u64, 0));

                    const value_54: u64 = ((block_66: {
                        const operand_64 = (value_7).widths;

                        const operand_65 = block_63: {
                            break :block_63 value_10;
                        }.?;

                        if ((operand_65 >= (operand_64).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_66 (operand_64)[@intCast(operand_65)];
                    } - block_69: {
                        const operand_67 = (value_7).widths;
                        const operand_68 = (value_51).index;

                        if ((operand_68 >= (operand_67).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_69 (operand_67)[@intCast(operand_68)];
                    }) + @as(u64, ((block_73: {
                        const operand_71 = ((value_7).input).tokens;

                        const operand_72 = block_70: {
                            break :block_70 value_10;
                        }.?;

                        if ((operand_72 >= (operand_71).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_73 (operand_71)[@intCast(operand_72)];
                    }).text).len));

                    const value_58: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if (((block_47: {
                        break :block_47 value_8;
                    }).object or ((!block_48: {
                        break :block_48 value_52;
                    }) and (((((value_51).column + (block_49: {
                        break :block_49 value_8;
                    }).gap) + block_50: {
                        break :block_50 value_54;
                    }) + block_51: {
                        break :block_51 value_53;
                    }) > block_52: {
                        break :block_52 value_19;
                    })))) block_62: {
                        const value_55: []const bool = ((value_51).plan).wraps;
                        const value_56: u64 = (value_51).index;
                        const value_57: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_61: {
                            break :block_61 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_51).breaks, .column = (value_51).column, .continuation = (value_51).continuation, .continuations = (value_51).continuations, .index = (value_51).index, .level = (value_51).level, .levels = (value_51).levels, .pending = (value_51).pending, .plan = block_60: {
                                break :block_60 @as(value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd, value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd{ .graph = ((value_51).plan).graph, .wraps = block_59: {
                                    const operand_54 = block_53: {
                                        break :block_53 value_55;
                                    };
                                    const operand_56 = block_55: {
                                        break :block_55 value_56;
                                    };

                                    if ((operand_56 >= (operand_54).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_57 = true;
                                    const operand_58 = @constCast(operand_54);
                                    (operand_58)[@intCast(operand_56)] = operand_57;
                                    break :block_59 operand_58;
                                }, });
                            }, .previous_priority = (value_51).previous_priority, });
                        };

                        break :block_62 value_57;
                    } else value_51);

                    break :block_86 value_58;
                } else value_51);

                const value_61: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if ((block_28: {
                    break :block_28 value_35;
                } or (((value_59).index == @as(u64, 0)) and (((value_7).input).prefix == @as(u64, 0))))) block_41: {
                    const value_60: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_40: {
                        break :block_40 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (block_39: {
                            const operand_29 = (value_59).breaks;
                            const operand_36 = block_35: {
                                const operand_30 = (value_59).index;
                                const operand_31 = (value_59).level;
                                const operand_32 = ((value_59).level * @as(u64, 4));

                                break :block_35 block_34: {
                                    const operand_33 = (try (allocator).create(zx_type_20));

                                    (operand_33).* = @as(zx_type_20, zx_type_20{ .index = operand_30, .level = operand_31, .count = operand_32, });

                                    break :block_34 @as(*const zx_type_20, operand_33);
                                };
                            };

                            const operand_37 = (try ((std).math).add(usize, (operand_29).len, 1));
                            const operand_38 = (try zxReserve(*const zx_type_20, allocator, operand_29, operand_37, true));

                            (operand_38)[(operand_29).len] = operand_36;

                            break :block_39 @as(value_9db904219b812256c60975c9cf1bdae456f04f62a8c64021793f76943089758d, .{ operand_38, {}, null, });
                        }).@"0", .column = (value_59).column, .continuation = (value_59).continuation, .continuations = (value_59).continuations, .index = (value_59).index, .level = (value_59).level, .levels = (value_59).levels, .pending = (value_59).pending, .plan = (value_59).plan, .previous_priority = (value_59).previous_priority, });
                    };

                    break :block_41 value_60;
                } else value_59);

                const value_62: u64 = (value_61).column;

                const value_63: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_27: {
                    break :block_27 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_61).breaks, .column = (block_23: {
                        break :block_23 value_62;
                    } + (@as(u64, ((block_24: {
                        break :block_24 value_8;
                    }).text).len) + (if (block_25: {
                        break :block_25 value_35;
                    }) @as(u64, 0) else (block_26: {
                        break :block_26 value_8;
                    }).gap))), .continuation = (value_61).continuation, .continuations = (value_61).continuations, .index = (value_61).index, .level = (value_61).level, .levels = (value_61).levels, .pending = (value_61).pending, .plan = (value_61).plan, .previous_priority = (value_61).previous_priority, });
                };
                const value_64: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_22: {
                    break :block_22 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_63).breaks, .column = (value_63).column, .continuation = (value_63).continuation, .continuations = (value_63).continuations, .index = (value_63).index, .level = (value_63).level, .levels = (value_63).levels, .pending = (block_20: {
                        break :block_20 value_33;
                    } and block_21: {
                        break :block_21 value_34;
                    }), .plan = (value_63).plan, .previous_priority = (value_63).previous_priority, });
                };
                const value_66: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = (if ((!(block_16: {
                    break :block_16 value_8;
                }).comment)) block_19: {
                    const value_65: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_18: {
                        break :block_18 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_64).breaks, .column = (value_64).column, .continuation = (value_64).continuation, .continuations = (value_64).continuations, .index = (value_64).index, .level = (value_64).level, .levels = (value_64).levels, .pending = (value_64).pending, .plan = (value_64).plan, .previous_priority = (try function_0(allocator, (block_17: {
                            break :block_17 value_8;
                        }).text)), });
                    };

                    break :block_19 value_65;
                } else value_64);

                const value_67: u64 = (value_66).index;

                const value_68: value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b = block_15: {
                    break :block_15 @as(value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b, value_05e5f25c2eeeadc04de0e96885342c2c17befa38d0e54ee69c82c40ef7d0734b{ .breaks = (value_66).breaks, .column = (value_66).column, .continuation = (value_66).continuation, .continuations = (value_66).continuations, .index = (block_14: {
                        break :block_14 value_67;
                    } + @as(u64, 1)), .level = (value_66).level, .levels = (value_66).levels, .pending = (value_66).pending, .plan = (value_66).plan, .previous_priority = (value_66).previous_priority, });
                };

                break :block_284 value_68;
            };
        }

        break :block_291 block_290: {
            break :block_290 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_289: {
                break :block_289 zx_type_33{ .breaks = (state_1).breaks, .column = (state_1).column, .continuation = (state_1).continuation, .continuations = (state_1).continuations, .index = (state_1).index, .level = (state_1).level, .levels = (state_1).levels, .pending = (state_1).pending, .plan = (if ((((state_1).plan).zx_origin != null)) ((state_1).plan).zx_origin.? else block_288: {
                    const operand_287 = (try (allocator).create(zx_type_19));

                    (operand_287).* = zx_type_19{ .graph = (if (((((state_1).plan).graph).zx_origin != null)) (((state_1).plan).graph).zx_origin.? else block_286: {
                        const operand_285 = (try (allocator).create(zx_type_18));

                        (operand_285).* = zx_type_18{ .depths = (((state_1).plan).graph).depths, .gaps = (((state_1).plan).graph).gaps, .input = (((state_1).plan).graph).input, .owners = (((state_1).plan).graph).owners, .partners = (((state_1).plan).graph).partners, .prefixes = (((state_1).plan).graph).prefixes, .selections = (((state_1).plan).graph).selections, .trailers = (((state_1).plan).graph).trailers, .vertical_counts = (((state_1).plan).graph).vertical_counts, .widths = (((state_1).plan).graph).widths, };

                        break :block_286 @as(*const zx_type_18, operand_285);
                    }), .wraps = ((state_1).plan).wraps, };

                    break :block_288 @as(*const zx_type_19, operand_287);
                }), .previous_priority = (state_1).previous_priority, };
            });
        };
    }).breaks;
}

fn function_1_value(allocator: ((std).mem).Allocator, in: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd {
    @setRuntimeSafety(true);

    const value_1: []const bool = block_83: {
        break :block_83 (try (allocator).dupe(bool, (&[_]bool{})));
    };

    const value_18: value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864 = block_82: {
        const operand_11 = block_10: {
            const operand_6 = in;

            const operand_7 = block_8: {
                break :block_8 value_1;
            };

            const operand_9 = @as(u64, 0);

            break :block_10 @as(value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864, value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864{ .graph = operand_6, .wraps = operand_7, .index = operand_9, });
        };

        var state_5: value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864 = operand_11;
        var state_changed_12 = false;

        while (((state_5).index < @as(u64, ((((state_5).graph).input).tokens).len))) {
            state_5 = block_80: {
                const value_4: zx_type_11 = (block_79: {
                    const operand_77 = (((state_5).graph).input).tokens;
                    const operand_78 = (state_5).index;

                    if ((operand_78 >= (operand_77).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_79 (operand_77)[@intCast(operand_78)];
                }).*;
                const value_5: ?u64 = block_76: {
                    const operand_74 = ((state_5).graph).partners;
                    const operand_75 = (state_5).index;

                    if ((operand_75 >= (operand_74).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_76 (operand_74)[@intCast(operand_75)];
                };

                const value_6: bool = ((block_72: {
                    break :block_72 value_5;
                } != null) and (block_73: {
                    break :block_73 value_5;
                }.? > (state_5).index));

                const value_7: bool = ((block_70: {
                    break :block_70 value_5;
                } != null) and (block_71: {
                    break :block_71 value_5;
                }.? > ((state_5).index + @as(u64, 1))));

                const value_8: u64 = (if ((block_57: {
                    break :block_57 value_6;
                } and (block_58: {
                    break :block_58 value_5;
                } != null))) ((block_62: {
                    const operand_60 = ((state_5).graph).widths;

                    const operand_61 = block_59: {
                        break :block_59 value_5;
                    }.?;

                    if ((operand_61 >= (operand_60).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_62 (operand_60)[@intCast(operand_61)];
                } - block_65: {
                    const operand_63 = ((state_5).graph).widths;
                    const operand_64 = (state_5).index;

                    if ((operand_64 >= (operand_63).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_65 (operand_63)[@intCast(operand_64)];
                }) + @as(u64, ((block_69: {
                    const operand_67 = (((state_5).graph).input).tokens;

                    const operand_68 = block_66: {
                        break :block_66 value_5;
                    }.?;

                    if ((operand_68 >= (operand_67).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_69 (operand_67)[@intCast(operand_68)];
                }).text).len)) else @as(u64, 0));

                const value_9: u64 = (if ((block_56: {
                    const operand_54 = ((state_5).graph).depths;
                    const operand_55 = (state_5).index;

                    if ((operand_55 >= (operand_54).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_56 (operand_54)[@intCast(operand_55)];
                } == @as(u64, 0))) ((((state_5).graph).input).prefix + (((state_5).graph).input).suffix) else @as(u64, 0));

                const value_10: u64 = (if (((block_47: {
                    break :block_47 value_6;
                } and (block_48: {
                    break :block_48 value_5;
                } != null)) and ((block_49: {
                    break :block_49 value_5;
                }.? + @as(u64, 1)) < @as(u64, (((state_5).graph).trailers).len)))) block_53: {
                    const operand_51 = ((state_5).graph).trailers;

                    const operand_52 = (block_50: {
                        break :block_50 value_5;
                    }.? + @as(u64, 1));

                    if ((operand_52 >= (operand_51).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_53 (operand_51)[@intCast(operand_52)];
                } else @as(u64, 0));

                const value_11: u64 = (((((((state_5).graph).input).level * @as(u64, 4)) + (block_42: {
                    const operand_40 = ((state_5).graph).depths;
                    const operand_41 = (state_5).index;

                    if ((operand_41 >= (operand_40).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_42 (operand_40)[@intCast(operand_41)];
                } * @as(u64, 4))) + block_45: {
                    const operand_43 = ((state_5).graph).prefixes;
                    const operand_44 = (state_5).index;

                    if ((operand_44 >= (operand_43).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_45 (operand_43)[@intCast(operand_44)];
                }) + block_46: {
                    break :block_46 value_9;
                });

                const value_12: bool = ((block_31: {
                    break :block_31 value_6;
                } and (block_32: {
                    break :block_32 value_5;
                } != null)) and (block_36: {
                    const operand_34 = ((state_5).graph).vertical_counts;

                    const operand_35 = block_33: {
                        break :block_33 value_5;
                    }.?;

                    if ((operand_35 >= (operand_34).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_36 (operand_34)[@intCast(operand_35)];
                } > block_39: {
                    const operand_37 = ((state_5).graph).vertical_counts;
                    const operand_38 = (state_5).index;

                    if ((operand_38 >= (operand_37).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_39 (operand_37)[@intCast(operand_38)];
                }));

                const value_13: u64 = (if (((((state_5).graph).input).width == @as(u64, 0))) @as(u64, 90) else (((state_5).graph).input).width);

                const value_14: bool = (((block_22: {
                    break :block_22 value_6;
                } and block_23: {
                    break :block_23 value_7;
                }) and (!(block_24: {
                    break :block_24 (&value_4);
                }).block)) and ((block_25: {
                    break :block_25 (&value_4);
                }).object or ((!block_26: {
                    break :block_26 value_12;
                }) and (((block_27: {
                    break :block_27 value_11;
                } + block_28: {
                    break :block_28 value_8;
                }) + block_29: {
                    break :block_29 value_10;
                }) > block_30: {
                    break :block_30 value_13;
                }))));

                const value_15: value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864 = block_21: {
                    break :block_21 @as(value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864, value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864{ .graph = (state_5).graph, .index = (state_5).index, .wraps = (block_20: {
                        const operand_15 = (state_5).wraps;

                        const operand_17 = block_16: {
                            break :block_16 value_14;
                        };

                        const operand_18 = (try ((std).math).add(usize, (operand_15).len, 1));
                        const operand_19 = (try zxReserve(bool, allocator, operand_15, operand_18, true));

                        (operand_19)[(operand_15).len] = operand_17;

                        break :block_20 @as(value_a1c38879412823f74bee6b3d46d653aa8fdf4a6b742c6f3128689092dc0947d7, .{ operand_19, {}, null, });
                    }).@"0", });
                };

                const value_16: u64 = (value_15).index;

                const value_17: value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864 = block_14: {
                    break :block_14 @as(value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864, value_8fad9ff112c543b28e863b0700395eec251d702162a935b63429416cb8ddf864{ .graph = (value_15).graph, .index = (block_13: {
                        break :block_13 value_16;
                    } + @as(u64, 1)), .wraps = (value_15).wraps, });
                };

                break :block_80 value_17;
            };

            state_changed_12 = true;
        }

        break :block_82 (if (state_changed_12) state_5 else operand_11);
    };

    return block_4: {
        const operand_2 = in;
        const operand_3 = (value_18).wraps;

        break :block_4 @as(value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd, value_2791c52c56b9686b755c7a188fb69322d24df43ef7ebe7a7eddf45107b4666dd{ .graph = operand_2, .wraps = operand_3, });
    };
}

fn function_4_value(allocator: ((std).mem).Allocator, in: value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_168: {
        break :block_168 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_7: []const u64 = (block_167: {
        const operand_155 = block_154: {
            const operand_150 = block_151: {
                break :block_151 value_1;
            };

            const operand_152 = @as(u64, 0);
            const operand_153 = @as(u64, (((in).input).tokens).len);

            break :block_154 @as(value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef, value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef{ .widths = operand_150, .index = operand_152, .count = operand_153, });
        };

        var state_149: value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef = operand_155;
        var state_changed_156 = false;

        while (((state_149).index < (state_149).count)) {
            state_149 = block_165: {
                const value_4: value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef = block_164: {
                    break :block_164 @as(value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef, value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef{ .count = (state_149).count, .index = (state_149).index, .widths = (block_163: {
                        const operand_159 = (state_149).widths;
                        const operand_160 = @as(u64, 0);
                        const operand_161 = (try ((std).math).add(usize, (operand_159).len, 1));
                        const operand_162 = (try zxReserve(u64, allocator, operand_159, operand_161, true));

                        (operand_162)[(operand_159).len] = operand_160;

                        break :block_163 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_162, {}, null, });
                    }).@"0", });
                };

                const value_5: u64 = (value_4).index;

                const value_6: value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef = block_158: {
                    break :block_158 @as(value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef, value_3f8d15d5dd3b6b09521a4f0ed17ceca03368bf557e1d4725552b352642a8f9ef{ .count = (value_4).count, .index = (block_157: {
                        break :block_157 value_5;
                    } + @as(u64, 1)), .widths = (value_4).widths, });
                };

                break :block_165 value_6;
            };

            state_changed_156 = true;
        }

        break :block_167 (if (state_changed_156) state_149 else operand_155);
    }).widths;

    const value_38: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = block_148: {
        const operand_11 = block_10: {
            const operand_6 = in;

            const operand_7 = block_8: {
                break :block_8 value_7;
            };

            const operand_9 = @as(u64, (((in).input).tokens).len);

            break :block_10 @as(value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d, value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d{ .graph = operand_6, .widths = operand_7, .remaining = operand_9, });
        };

        var state_5: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = operand_11;
        var state_changed_12 = false;

        while (((state_5).remaining > @as(u64, 0))) {
            state_5 = block_146: {
                const value_10: u64 = (state_5).remaining;

                const value_11: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = block_145: {
                    break :block_145 @as(value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d, value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d{ .graph = (state_5).graph, .remaining = (block_144: {
                        break :block_144 value_10;
                    } - @as(u64, 1)), .widths = (state_5).widths, });
                };

                const value_12: u64 = (value_11).remaining;

                const value_13: zx_type_11 = (block_143: {
                    const operand_141 = (((value_11).graph).input).tokens;

                    const operand_142 = block_140: {
                        break :block_140 value_12;
                    };

                    if ((operand_142 >= (operand_141).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_143 (operand_141)[@intCast(operand_142)];
                }).*;

                const value_14: u64 = (block_139: {
                    break :block_139 value_12;
                } + @as(u64, 1));

                const value_15: u64 = @as(u64, ((((value_11).graph).input).tokens).len);

                const value_16: bool = ((block_130: {
                    const operand_128 = (block_127: {
                        break :block_127 (&value_13);
                    }).text;

                    const operand_129 = @as([]const u8, "}");

                    break :block_130 ((std).mem).eql(u8, operand_128, operand_129);
                } or block_134: {
                    const operand_132 = (block_131: {
                        break :block_131 (&value_13);
                    }).text;

                    const operand_133 = @as([]const u8, ")");

                    break :block_134 ((std).mem).eql(u8, operand_132, operand_133);
                }) or block_138: {
                    const operand_136 = (block_135: {
                        break :block_135 (&value_13);
                    }).text;

                    const operand_137 = @as([]const u8, "]");

                    break :block_138 ((std).mem).eql(u8, operand_136, operand_137);
                });

                const value_17: bool = ((((block_113: {
                    const operand_111 = (block_110: {
                        break :block_110 (&value_13);
                    }).text;

                    const operand_112 = @as([]const u8, "{");

                    break :block_113 ((std).mem).eql(u8, operand_111, operand_112);
                } or block_117: {
                    const operand_115 = (block_114: {
                        break :block_114 (&value_13);
                    }).text;

                    const operand_116 = @as([]const u8, "(");

                    break :block_117 ((std).mem).eql(u8, operand_115, operand_116);
                }) or block_121: {
                    const operand_119 = (block_118: {
                        break :block_118 (&value_13);
                    }).text;

                    const operand_120 = @as([]const u8, "[");

                    break :block_121 ((std).mem).eql(u8, operand_119, operand_120);
                }) or block_125: {
                    const operand_123 = (block_122: {
                        break :block_122 (&value_13);
                    }).text;

                    const operand_124 = @as([]const u8, ",");

                    break :block_125 ((std).mem).eql(u8, operand_123, operand_124);
                }) or ((try function_0(allocator, (block_126: {
                    break :block_126 (&value_13);
                }).text)) != @as(u64, 0)));

                const value_18: u64 = (if ((block_104: {
                    break :block_104 value_14;
                } < block_105: {
                    break :block_105 value_15;
                })) block_109: {
                    const operand_107 = (value_11).widths;

                    const operand_108 = block_106: {
                        break :block_106 value_14;
                    };

                    if ((operand_108 >= (operand_107).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_109 (operand_107)[@intCast(operand_108)];
                } else @as(u64, 0));

                const value_19: u64 = (block_102: {
                    const operand_100 = ((value_11).graph).gaps;

                    const operand_101 = block_99: {
                        break :block_99 value_12;
                    };

                    if ((operand_101 >= (operand_100).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_102 (operand_100)[@intCast(operand_101)];
                } + @as(u64, ((block_103: {
                    break :block_103 (&value_13);
                }).text).len));

                const value_37: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = (if (block_13: {
                    break :block_13 value_16;
                }) block_25: {
                    const value_20: []const u64 = (value_11).widths;

                    const value_21: u64 = block_24: {
                        break :block_24 value_12;
                    };
                    const value_22: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = block_23: {
                        break :block_23 @as(value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d, value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d{ .graph = (value_11).graph, .remaining = (value_11).remaining, .widths = block_22: {
                            const operand_15 = block_14: {
                                break :block_14 value_20;
                            };
                            const operand_17 = block_16: {
                                break :block_16 value_21;
                            };

                            if ((operand_17 >= (operand_15).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_20 = (block_18: {
                                break :block_18 value_19;
                            } + block_19: {
                                break :block_19 value_18;
                            });

                            const operand_21 = @constCast(operand_15);

                            (operand_21)[@intCast(operand_17)] = operand_20;

                            break :block_22 operand_21;
                        }, });
                    };

                    break :block_25 value_22;
                } else block_98: {
                    const value_36: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = (if (block_26: {
                        break :block_26 value_17;
                    }) block_37: {
                        const value_23: []const u64 = (value_11).widths;

                        const value_24: u64 = block_36: {
                            break :block_36 value_12;
                        };
                        const value_25: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = block_35: {
                            break :block_35 @as(value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d, value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d{ .graph = (value_11).graph, .remaining = (value_11).remaining, .widths = block_34: {
                                const operand_28 = block_27: {
                                    break :block_27 value_23;
                                };
                                const operand_30 = block_29: {
                                    break :block_29 value_24;
                                };

                                if ((operand_30 >= (operand_28).len)) {
                                    return error.IndexOutOfBounds;
                                }
                                const operand_32 = block_31: {
                                    break :block_31 value_19;
                                };
                                const operand_33 = @constCast(operand_28);

                                (operand_33)[@intCast(operand_30)] = operand_32;

                                break :block_34 operand_33;
                            }, });
                        };

                        break :block_37 value_25;
                    } else block_97: {
                        const value_35: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = (if ((block_41: {
                            const operand_39 = (block_38: {
                                break :block_38 (&value_13);
                            }).text;

                            const operand_40 = @as([]const u8, ".");

                            break :block_41 ((std).mem).eql(u8, operand_39, operand_40);
                        } and (block_42: {
                            break :block_42 value_14;
                        } < block_43: {
                            break :block_43 value_15;
                        }))) block_70: {
                            const value_26: zx_type_11 = (block_69: {
                                const operand_67 = (((value_11).graph).input).tokens;

                                const operand_68 = block_66: {
                                    break :block_66 value_14;
                                };

                                if ((operand_68 >= (operand_67).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_69 (operand_67)[@intCast(operand_68)];
                            }).*;

                            const value_27: u64 = (if (((block_60: {
                                break :block_60 value_14;
                            } + @as(u64, 1)) < block_61: {
                                break :block_61 value_15;
                            })) block_65: {
                                const operand_63 = (value_11).widths;

                                const operand_64 = (block_62: {
                                    break :block_62 value_14;
                                } + @as(u64, 1));

                                if ((operand_64 >= (operand_63).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_65 (operand_63)[@intCast(operand_64)];
                            } else @as(u64, 0));

                            const value_28: []const u64 = (value_11).widths;

                            const value_29: u64 = block_59: {
                                break :block_59 value_12;
                            };
                            const value_30: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = block_58: {
                                break :block_58 @as(value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d, value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d{ .graph = (value_11).graph, .remaining = (value_11).remaining, .widths = block_57: {
                                    const operand_45 = block_44: {
                                        break :block_44 value_28;
                                    };
                                    const operand_47 = block_46: {
                                        break :block_46 value_29;
                                    };

                                    if ((operand_47 >= (operand_45).len)) {
                                        return error.IndexOutOfBounds;
                                    }
                                    const operand_55 = (((block_48: {
                                        break :block_48 value_19;
                                    } + block_52: {
                                        const operand_50 = ((value_11).graph).gaps;

                                        const operand_51 = block_49: {
                                            break :block_49 value_14;
                                        };

                                        if ((operand_51 >= (operand_50).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_52 (operand_50)[@intCast(operand_51)];
                                    }) + @as(u64, ((block_53: {
                                        break :block_53 (&value_26);
                                    }).text).len)) + block_54: {
                                        break :block_54 value_27;
                                    });

                                    const operand_56 = @constCast(operand_45);

                                    (operand_56)[@intCast(operand_47)] = operand_55;
                                    break :block_57 operand_56;
                                }, });
                            };

                            break :block_70 value_30;
                        } else block_96: {
                            const value_34: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = (if ((block_74: {
                                const operand_72 = (block_71: {
                                    break :block_71 (&value_13);
                                }).text;

                                const operand_73 = @as([]const u8, "from");

                                break :block_74 ((std).mem).eql(u8, operand_72, operand_73);
                            } and (block_75: {
                                break :block_75 value_14;
                            } < block_76: {
                                break :block_76 value_15;
                            }))) block_95: {
                                const value_31: []const u64 = (value_11).widths;

                                const value_32: u64 = block_94: {
                                    break :block_94 value_12;
                                };
                                const value_33: value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d = block_93: {
                                    break :block_93 @as(value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d, value_1ed528c176df5584fe28845231f48ab02b03931d417c4a6f9372cb852b13f55d{ .graph = (value_11).graph, .remaining = (value_11).remaining, .widths = block_92: {
                                        const operand_78 = block_77: {
                                            break :block_77 value_31;
                                        };
                                        const operand_80 = block_79: {
                                            break :block_79 value_32;
                                        };

                                        if ((operand_80 >= (operand_78).len)) {
                                            return error.IndexOutOfBounds;
                                        }
                                        const operand_90 = ((block_81: {
                                            break :block_81 value_19;
                                        } + block_85: {
                                            const operand_83 = ((value_11).graph).gaps;

                                            const operand_84 = block_82: {
                                                break :block_82 value_14;
                                            };

                                            if ((operand_84 >= (operand_83).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_85 (operand_83)[@intCast(operand_84)];
                                        }) + @as(u64, ((block_89: {
                                            const operand_87 = (((value_11).graph).input).tokens;

                                            const operand_88 = block_86: {
                                                break :block_86 value_14;
                                            };

                                            if ((operand_88 >= (operand_87).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_89 (operand_87)[@intCast(operand_88)];
                                        }).text).len));

                                        const operand_91 = @constCast(operand_78);

                                        (operand_91)[@intCast(operand_80)] = operand_90;
                                        break :block_92 operand_91;
                                    }, });
                                };

                                break :block_95 value_33;
                            } else value_11);

                            break :block_96 value_34;
                        });

                        break :block_97 value_35;
                    });

                    break :block_98 value_36;
                });

                break :block_146 value_37;
            };

            state_changed_12 = true;
        }

        break :block_148 (if (state_changed_12) state_5 else operand_11);
    };

    return block_4: {
        const operand_2 = in;
        const operand_3 = (value_38).widths;

        break :block_4 @as(value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (operand_2).depths, .gaps = (operand_2).gaps, .input = (operand_2).input, .owners = (operand_2).owners, .partners = (operand_2).partners, .prefixes = (operand_2).prefixes, .selections = (operand_2).selections, .trailers = operand_3, .vertical_counts = (operand_2).vertical_counts, .widths = (operand_2).widths, });
    };
}

fn function_5_value(allocator: ((std).mem).Allocator, in: *const zx_type_13) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e {
    @setRuntimeSafety(true);

    const value_1: []const ?u64 = block_286: {
        break :block_286 (try (allocator).dupe(?u64, (&[_]?u64{})));
    };

    const value_2: []const ?u64 = block_285: {
        break :block_285 (try (allocator).dupe(?u64, (&[_]?u64{})));
    };

    const value_3: []const u64 = block_284: {
        break :block_284 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_4: []const u64 = block_283: {
        break :block_283 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_5: []const u64 = block_282: {
        break :block_282 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_6: []const u64 = block_281: {
        break :block_281 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_7: []const u64 = block_280: {
        break :block_280 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_8: []const u64 = block_279: {
        break :block_279 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_9: []const bool = block_278: {
        break :block_278 (try (allocator).dupe(bool, (&[_]bool{})));
    };

    const value_64: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_277: {
        const operand_40 = block_39: {
            const operand_15 = in;

            const operand_16 = block_17: {
                break :block_17 value_1;
            };
            const operand_18 = block_19: {
                break :block_19 value_2;
            };
            const operand_20 = block_21: {
                break :block_21 value_3;
            };
            const operand_22 = block_23: {
                break :block_23 value_4;
            };
            const operand_24 = block_25: {
                break :block_25 value_5;
            };

            const operand_26 = @as(u64, 0);
            const operand_27 = @as(u64, 0);
            const operand_28 = @as(u64, 0);
            const operand_29 = @as(u64, 0);

            const operand_30 = block_31: {
                break :block_31 value_6;
            };
            const operand_32 = block_33: {
                break :block_33 value_7;
            };
            const operand_34 = block_35: {
                break :block_35 value_8;
            };
            const operand_36 = block_37: {
                break :block_37 value_9;
            };

            const operand_38 = @as(u64, 0);

            break :block_39 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .input = operand_15, .partners = operand_16, .owners = operand_18, .depths = operand_20, .widths = operand_22, .stack = operand_24, .index = operand_26, .width = operand_27, .prefix = operand_28, .vertical_count = operand_29, .prefixes = operand_30, .vertical_counts = operand_32, .gaps = operand_34, .selections = operand_36, .selection_depth = operand_38, });
        };

        var state_14: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = operand_40;
        var state_changed_41 = false;

        while (((state_14).index < @as(u64, (((state_14).input).tokens).len))) {
            state_14 = block_275: {
                const value_12: zx_type_11 = (block_274: {
                    const operand_272 = ((state_14).input).tokens;
                    const operand_273 = (state_14).index;

                    if ((operand_273 >= (operand_272).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_274 (operand_272)[@intCast(operand_273)];
                }).*;

                const value_13: bool = ((((block_259: {
                    break :block_259 (&value_12);
                }).closing or block_263: {
                    const operand_261 = (block_260: {
                        break :block_260 (&value_12);
                    }).text;

                    const operand_262 = @as([]const u8, "}");

                    break :block_263 ((std).mem).eql(u8, operand_261, operand_262);
                }) or block_267: {
                    const operand_265 = (block_264: {
                        break :block_264 (&value_12);
                    }).text;

                    const operand_266 = @as([]const u8, ")");

                    break :block_267 ((std).mem).eql(u8, operand_265, operand_266);
                }) or block_271: {
                    const operand_269 = (block_268: {
                        break :block_268 (&value_12);
                    }).text;

                    const operand_270 = @as([]const u8, "]");

                    break :block_271 ((std).mem).eql(u8, operand_269, operand_270);
                });

                const value_14: bool = ((((block_246: {
                    break :block_246 (&value_12);
                }).opening or block_250: {
                    const operand_248 = (block_247: {
                        break :block_247 (&value_12);
                    }).text;

                    const operand_249 = @as([]const u8, "{");

                    break :block_250 ((std).mem).eql(u8, operand_248, operand_249);
                }) or block_254: {
                    const operand_252 = (block_251: {
                        break :block_251 (&value_12);
                    }).text;

                    const operand_253 = @as([]const u8, "(");

                    break :block_254 ((std).mem).eql(u8, operand_252, operand_253);
                }) or block_258: {
                    const operand_256 = (block_255: {
                        break :block_255 (&value_12);
                    }).text;

                    const operand_257 = @as([]const u8, "[");

                    break :block_258 ((std).mem).eql(u8, operand_256, operand_257);
                });

                const value_15: ?u64 = (if ((@as(u64, ((state_14).stack).len) == @as(u64, 0))) @as(?u64, null) else @as(?u64, block_245: {
                    const operand_243 = (state_14).stack;
                    const operand_244 = (@as(u64, ((state_14).stack).len) - @as(u64, 1));

                    if ((operand_244 >= (operand_243).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_245 (operand_243)[@intCast(operand_244)];
                }));

                const value_16: []const u8 = (if (((state_14).index == @as(u64, 0))) @as([]const u8, "") else (block_242: {
                    const operand_240 = ((state_14).input).tokens;
                    const operand_241 = ((state_14).index - @as(u64, 1));

                    if ((operand_241 >= (operand_240).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_242 (operand_240)[@intCast(operand_241)];
                }).text);
                const value_17: u64 = block_239: {
                    const value_65: value_5d3e8828bfb79a0b02434e75bf81807fc9ca4a276b0ce056e537edc7f1f1a013 = block_238: {
                        const operand_232 = block_233: {
                            break :block_233 value_16;
                        };
                        const operand_234 = (block_235: {
                            break :block_235 (&value_12);
                        }).text;

                        const operand_236 = (block_237: {
                            break :block_237 (&value_12);
                        }).gap;

                        break :block_238 @as(value_5d3e8828bfb79a0b02434e75bf81807fc9ca4a276b0ce056e537edc7f1f1a013, value_5d3e8828bfb79a0b02434e75bf81807fc9ca4a276b0ce056e537edc7f1f1a013{ .previous = operand_232, .current = operand_234, .actual = operand_236, });
                    };
                    const value_66: bool = ((block_225: {
                        const operand_223 = (value_65).previous;
                        const operand_224 = @as([]const u8, "{");

                        break :block_225 ((std).mem).eql(u8, operand_223, operand_224);
                    } or block_228: {
                        const operand_226 = (value_65).previous;
                        const operand_227 = @as([]const u8, "(");

                        break :block_228 ((std).mem).eql(u8, operand_226, operand_227);
                    }) or block_231: {
                        const operand_229 = (value_65).previous;
                        const operand_230 = @as([]const u8, "[");

                        break :block_231 ((std).mem).eql(u8, operand_229, operand_230);
                    });

                    const value_67: bool = ((block_216: {
                        const operand_214 = (value_65).current;
                        const operand_215 = @as([]const u8, "}");

                        break :block_216 ((std).mem).eql(u8, operand_214, operand_215);
                    } or block_219: {
                        const operand_217 = (value_65).current;
                        const operand_218 = @as([]const u8, ")");

                        break :block_219 ((std).mem).eql(u8, operand_217, operand_218);
                    }) or block_222: {
                        const operand_220 = (value_65).current;
                        const operand_221 = @as([]const u8, "]");

                        break :block_222 ((std).mem).eql(u8, operand_220, operand_221);
                    });

                    const value_68: bool = (((try function_0(allocator, (value_65).previous)) != @as(u64, 0)) or ((try function_0(allocator, (value_65).current)) != @as(u64, 0)));

                    break :block_239 (if ((((block_208: {
                        break :block_208 value_66;
                    } or block_209: {
                        break :block_209 value_67;
                    }) or block_210: {
                        break :block_210 value_68;
                    }) or block_213: {
                        const operand_211 = (value_65).previous;
                        const operand_212 = @as([]const u8, ",");

                        break :block_213 ((std).mem).eql(u8, operand_211, operand_212);
                    })) @as(u64, 1) else (value_65).actual);
                };

                const value_18: bool = ((block_199: {
                    break :block_199 value_15;
                } != null) and (block_203: {
                    const operand_201 = (block_200: {
                        break :block_200 (&value_12);
                    }).text;

                    const operand_202 = @as([]const u8, "case");

                    break :block_203 ((std).mem).eql(u8, operand_201, operand_202);
                } or block_207: {
                    const operand_205 = (block_204: {
                        break :block_204 (&value_12);
                    }).text;

                    const operand_206 = @as([]const u8, "default");

                    break :block_207 ((std).mem).eql(u8, operand_205, operand_206);
                }));

                const value_19: bool = ((block_193: {
                    break :block_193 value_18;
                } and (block_194: {
                    break :block_194 value_15;
                } != null)) and block_198: {
                    const operand_196 = (state_14).selections;

                    const operand_197 = block_195: {
                        break :block_195 value_15;
                    }.?;

                    if ((operand_197 >= (operand_196).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_198 (operand_196)[@intCast(operand_197)];
                });

                const value_20: u64 = ((@as(u64, ((state_14).stack).len) + (state_14).selection_depth) - (if (block_192: {
                    break :block_192 value_19;
                }) @as(u64, 1) else @as(u64, 0)));

                const value_22: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = (if (((((block_180: {
                    break :block_180 (&value_12);
                }).boundary or block_184: {
                    const operand_182 = block_181: {
                        break :block_181 value_16;
                    };

                    const operand_183 = @as([]const u8, "{");

                    break :block_184 ((std).mem).eql(u8, operand_182, operand_183);
                }) or block_188: {
                    const operand_186 = block_185: {
                        break :block_185 value_16;
                    };

                    const operand_187 = @as([]const u8, ",");

                    break :block_188 ((std).mem).eql(u8, operand_186, operand_187);
                }) or ((try function_0(allocator, block_189: {
                    break :block_189 value_16;
                })) != @as(u64, 0)))) block_191: {
                    const value_21: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_190: {
                        break :block_190 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (state_14).depths, .gaps = (state_14).gaps, .index = (state_14).index, .input = (state_14).input, .owners = (state_14).owners, .partners = (state_14).partners, .prefix = @as(u64, 0), .prefixes = (state_14).prefixes, .selection_depth = (state_14).selection_depth, .selections = (state_14).selections, .stack = (state_14).stack, .vertical_count = (state_14).vertical_count, .vertical_counts = (state_14).vertical_counts, .width = (state_14).width, .widths = (state_14).widths, });
                    };

                    break :block_191 value_21;
                } else state_14);

                const value_23: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_179: {
                    break :block_179 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_22).depths, .gaps = (value_22).gaps, .index = (value_22).index, .input = (value_22).input, .owners = (value_22).owners, .partners = (block_178: {
                        const operand_174 = (value_22).partners;
                        const operand_175 = @as(?u64, null);
                        const operand_176 = (try ((std).math).add(usize, (operand_174).len, 1));
                        const operand_177 = (try zxReserve(?u64, allocator, operand_174, operand_176, true));

                        (operand_177)[(operand_174).len] = operand_175;

                        break :block_178 @as(value_1eb4afd7f7f0d42a4f5fbed4ac0993b8f0388f7a17fdcaa1c00e1a4f08d936b2, .{ operand_177, {}, null, });
                    }).@"0", .prefix = (value_22).prefix, .prefixes = (value_22).prefixes, .selection_depth = (value_22).selection_depth, .selections = (value_22).selections, .stack = (value_22).stack, .vertical_count = (value_22).vertical_count, .vertical_counts = (value_22).vertical_counts, .width = (value_22).width, .widths = (value_22).widths, });
                };
                const value_24: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_173: {
                    break :block_173 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_23).depths, .gaps = (value_23).gaps, .index = (value_23).index, .input = (value_23).input, .owners = (block_172: {
                        const operand_167 = (value_23).owners;

                        const operand_169 = block_168: {
                            break :block_168 value_15;
                        };

                        const operand_170 = (try ((std).math).add(usize, (operand_167).len, 1));
                        const operand_171 = (try zxReserve(?u64, allocator, operand_167, operand_170, true));

                        (operand_171)[(operand_167).len] = operand_169;

                        break :block_172 @as(value_1eb4afd7f7f0d42a4f5fbed4ac0993b8f0388f7a17fdcaa1c00e1a4f08d936b2, .{ operand_171, {}, null, });
                    }).@"0", .partners = (value_23).partners, .prefix = (value_23).prefix, .prefixes = (value_23).prefixes, .selection_depth = (value_23).selection_depth, .selections = (value_23).selections, .stack = (value_23).stack, .vertical_count = (value_23).vertical_count, .vertical_counts = (value_23).vertical_counts, .width = (value_23).width, .widths = (value_23).widths, });
                };
                const value_25: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_166: {
                    break :block_166 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (block_165: {
                        const operand_160 = (value_24).depths;

                        const operand_162 = block_161: {
                            break :block_161 value_20;
                        };

                        const operand_163 = (try ((std).math).add(usize, (operand_160).len, 1));
                        const operand_164 = (try zxReserve(u64, allocator, operand_160, operand_163, true));

                        (operand_164)[(operand_160).len] = operand_162;

                        break :block_165 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_164, {}, null, });
                    }).@"0", .gaps = (value_24).gaps, .index = (value_24).index, .input = (value_24).input, .owners = (value_24).owners, .partners = (value_24).partners, .prefix = (value_24).prefix, .prefixes = (value_24).prefixes, .selection_depth = (value_24).selection_depth, .selections = (value_24).selections, .stack = (value_24).stack, .vertical_count = (value_24).vertical_count, .vertical_counts = (value_24).vertical_counts, .width = (value_24).width, .widths = (value_24).widths, });
                };
                const value_26: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_159: {
                    break :block_159 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_25).depths, .gaps = (value_25).gaps, .index = (value_25).index, .input = (value_25).input, .owners = (value_25).owners, .partners = (value_25).partners, .prefix = (value_25).prefix, .prefixes = (value_25).prefixes, .selection_depth = (value_25).selection_depth, .selections = (value_25).selections, .stack = (value_25).stack, .vertical_count = (value_25).vertical_count, .vertical_counts = (value_25).vertical_counts, .width = (value_25).width, .widths = (block_158: {
                        const operand_153 = (value_25).widths;

                        const operand_155 = ((value_25).width + block_154: {
                            break :block_154 value_17;
                        });

                        const operand_156 = (try ((std).math).add(usize, (operand_153).len, 1));
                        const operand_157 = (try zxReserve(u64, allocator, operand_153, operand_156, true));

                        (operand_157)[(operand_153).len] = operand_155;

                        break :block_158 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_157, {}, null, });
                    }).@"0", });
                };
                const value_27: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_152: {
                    break :block_152 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_26).depths, .gaps = (value_26).gaps, .index = (value_26).index, .input = (value_26).input, .owners = (value_26).owners, .partners = (value_26).partners, .prefix = (value_26).prefix, .prefixes = (block_151: {
                        const operand_146 = (value_26).prefixes;

                        const operand_148 = ((value_26).prefix + block_147: {
                            break :block_147 value_17;
                        });

                        const operand_149 = (try ((std).math).add(usize, (operand_146).len, 1));
                        const operand_150 = (try zxReserve(u64, allocator, operand_146, operand_149, true));

                        (operand_150)[(operand_146).len] = operand_148;

                        break :block_151 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_150, {}, null, });
                    }).@"0", .selection_depth = (value_26).selection_depth, .selections = (value_26).selections, .stack = (value_26).stack, .vertical_count = (value_26).vertical_count, .vertical_counts = (value_26).vertical_counts, .width = (value_26).width, .widths = (value_26).widths, });
                };
                const value_28: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_145: {
                    break :block_145 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_27).depths, .gaps = (value_27).gaps, .index = (value_27).index, .input = (value_27).input, .owners = (value_27).owners, .partners = (value_27).partners, .prefix = (value_27).prefix, .prefixes = (value_27).prefixes, .selection_depth = (value_27).selection_depth, .selections = (value_27).selections, .stack = (value_27).stack, .vertical_count = (value_27).vertical_count, .vertical_counts = (block_144: {
                        const operand_140 = (value_27).vertical_counts;
                        const operand_141 = (value_27).vertical_count;
                        const operand_142 = (try ((std).math).add(usize, (operand_140).len, 1));
                        const operand_143 = (try zxReserve(u64, allocator, operand_140, operand_142, true));

                        (operand_143)[(operand_140).len] = operand_141;

                        break :block_144 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_143, {}, null, });
                    }).@"0", .width = (value_27).width, .widths = (value_27).widths, });
                };
                const value_29: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_139: {
                    break :block_139 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_28).depths, .gaps = (block_138: {
                        const operand_133 = (value_28).gaps;

                        const operand_135 = block_134: {
                            break :block_134 value_17;
                        };

                        const operand_136 = (try ((std).math).add(usize, (operand_133).len, 1));
                        const operand_137 = (try zxReserve(u64, allocator, operand_133, operand_136, true));

                        (operand_137)[(operand_133).len] = operand_135;

                        break :block_138 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_137, {}, null, });
                    }).@"0", .index = (value_28).index, .input = (value_28).input, .owners = (value_28).owners, .partners = (value_28).partners, .prefix = (value_28).prefix, .prefixes = (value_28).prefixes, .selection_depth = (value_28).selection_depth, .selections = (value_28).selections, .stack = (value_28).stack, .vertical_count = (value_28).vertical_count, .vertical_counts = (value_28).vertical_counts, .width = (value_28).width, .widths = (value_28).widths, });
                };
                const value_30: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_132: {
                    break :block_132 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_29).depths, .gaps = (value_29).gaps, .index = (value_29).index, .input = (value_29).input, .owners = (value_29).owners, .partners = (value_29).partners, .prefix = (value_29).prefix, .prefixes = (value_29).prefixes, .selection_depth = (value_29).selection_depth, .selections = (block_131: {
                        const operand_127 = (value_29).selections;
                        const operand_128 = false;
                        const operand_129 = (try ((std).math).add(usize, (operand_127).len, 1));
                        const operand_130 = (try zxReserve(bool, allocator, operand_127, operand_129, true));

                        (operand_130)[(operand_127).len] = operand_128;

                        break :block_131 @as(value_a1c38879412823f74bee6b3d46d653aa8fdf4a6b742c6f3128689092dc0947d7, .{ operand_130, {}, null, });
                    }).@"0", .stack = (value_29).stack, .vertical_count = (value_29).vertical_count, .vertical_counts = (value_29).vertical_counts, .width = (value_29).width, .widths = (value_29).widths, });
                };

                const value_31: u64 = (value_30).width;

                const value_32: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_126: {
                    break :block_126 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_30).depths, .gaps = (value_30).gaps, .index = (value_30).index, .input = (value_30).input, .owners = (value_30).owners, .partners = (value_30).partners, .prefix = (value_30).prefix, .prefixes = (value_30).prefixes, .selection_depth = (value_30).selection_depth, .selections = (value_30).selections, .stack = (value_30).stack, .vertical_count = (value_30).vertical_count, .vertical_counts = (value_30).vertical_counts, .width = (block_123: {
                        break :block_123 value_31;
                    } + (@as(u64, ((block_124: {
                        break :block_124 (&value_12);
                    }).text).len) + block_125: {
                        break :block_125 value_17;
                    })), .widths = (value_30).widths, });
                };
                const value_33: u64 = (value_32).prefix;

                const value_34: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_122: {
                    break :block_122 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_32).depths, .gaps = (value_32).gaps, .index = (value_32).index, .input = (value_32).input, .owners = (value_32).owners, .partners = (value_32).partners, .prefix = (block_119: {
                        break :block_119 value_33;
                    } + (@as(u64, ((block_120: {
                        break :block_120 (&value_12);
                    }).text).len) + block_121: {
                        break :block_121 value_17;
                    })), .prefixes = (value_32).prefixes, .selection_depth = (value_32).selection_depth, .selections = (value_32).selections, .stack = (value_32).stack, .vertical_count = (value_32).vertical_count, .vertical_counts = (value_32).vertical_counts, .width = (value_32).width, .widths = (value_32).widths, });
                };
                const value_40: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = (if (((block_101: {
                    break :block_101 value_18;
                } and (block_102: {
                    break :block_102 value_15;
                } != null)) and (!block_106: {
                    const operand_104 = (value_34).selections;

                    const operand_105 = block_103: {
                        break :block_103 value_15;
                    }.?;

                    if ((operand_105 >= (operand_104).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_106 (operand_104)[@intCast(operand_105)];
                }))) block_118: {
                    const value_35: []const bool = (value_34).selections;

                    const value_36: u64 = block_117: {
                        break :block_117 value_15;
                    }.?;
                    const value_37: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_116: {
                        break :block_116 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_34).depths, .gaps = (value_34).gaps, .index = (value_34).index, .input = (value_34).input, .owners = (value_34).owners, .partners = (value_34).partners, .prefix = (value_34).prefix, .prefixes = (value_34).prefixes, .selection_depth = (value_34).selection_depth, .selections = block_115: {
                            const operand_110 = block_109: {
                                break :block_109 value_35;
                            };
                            const operand_112 = block_111: {
                                break :block_111 value_36;
                            };

                            if ((operand_112 >= (operand_110).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_113 = true;
                            const operand_114 = @constCast(operand_110);

                            (operand_114)[@intCast(operand_112)] = operand_113;

                            break :block_115 operand_114;
                        }, .stack = (value_34).stack, .vertical_count = (value_34).vertical_count, .vertical_counts = (value_34).vertical_counts, .width = (value_34).width, .widths = (value_34).widths, });
                    };
                    const value_38: u64 = (value_37).selection_depth;

                    const value_39: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_108: {
                        break :block_108 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_37).depths, .gaps = (value_37).gaps, .index = (value_37).index, .input = (value_37).input, .owners = (value_37).owners, .partners = (value_37).partners, .prefix = (value_37).prefix, .prefixes = (value_37).prefixes, .selection_depth = (block_107: {
                            break :block_107 value_38;
                        } + @as(u64, 1)), .selections = (value_37).selections, .stack = (value_37).stack, .vertical_count = (value_37).vertical_count, .vertical_counts = (value_37).vertical_counts, .width = (value_37).width, .widths = (value_37).widths, });
                    };

                    break :block_118 value_39;
                } else value_34);

                const value_43: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = (if ((((block_91: {
                    break :block_91 (&value_12);
                }).object and (((value_40).index + @as(u64, 1)) < @as(u64, (((value_40).input).tokens).len))) and (!block_97: {
                    const operand_95 = (block_94: {
                        const operand_92 = ((value_40).input).tokens;
                        const operand_93 = ((value_40).index + @as(u64, 1));

                        if ((operand_93 >= (operand_92).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_94 (operand_92)[@intCast(operand_93)];
                    }).text;

                    const operand_96 = @as([]const u8, "}");

                    break :block_97 ((std).mem).eql(u8, operand_95, operand_96);
                }))) block_100: {
                    const value_41: u64 = (value_40).vertical_count;

                    const value_42: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_99: {
                        break :block_99 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_40).depths, .gaps = (value_40).gaps, .index = (value_40).index, .input = (value_40).input, .owners = (value_40).owners, .partners = (value_40).partners, .prefix = (value_40).prefix, .prefixes = (value_40).prefixes, .selection_depth = (value_40).selection_depth, .selections = (value_40).selections, .stack = (value_40).stack, .vertical_count = (block_98: {
                            break :block_98 value_41;
                        } + @as(u64, 1)), .vertical_counts = (value_40).vertical_counts, .width = (value_40).width, .widths = (value_40).widths, });
                    };

                    break :block_100 value_42;
                } else value_40);

                const value_59: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = (if ((block_52: {
                    break :block_52 value_13;
                } and (@as(u64, ((value_43).stack).len) != @as(u64, 0)))) block_90: {
                    const value_44: value_06d4e5bb0ca23902f4bd02eaacc137074b7490f6f2531cc32dff07bb7465ff2d = block_89: {
                        const operand_88 = (value_43).stack;

                        if (((operand_88).len != 0)) {
                            zxRetract(u64, operand_88, ((operand_88).len - 1));
                        }

                        break :block_89 @as(value_06d4e5bb0ca23902f4bd02eaacc137074b7490f6f2531cc32dff07bb7465ff2d, (if (((operand_88).len == 0)) .{ operand_88, null, null, } else .{ (operand_88)[0..((operand_88).len - 1)], (operand_88)[((operand_88).len - 1)], null, }));
                    };
                    const value_45: ?u64 = (value_44).@"1";

                    const value_57: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = (if ((block_54: {
                        break :block_54 value_45;
                    } != null)) block_87: {
                        const value_46: []const ?u64 = (value_43).partners;

                        const value_47: u64 = block_86: {
                            break :block_86 value_45;
                        }.?;
                        const value_48: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_85: {
                            break :block_85 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_43).depths, .gaps = (value_43).gaps, .index = (value_43).index, .input = (value_43).input, .owners = (value_43).owners, .partners = block_84: {
                                const operand_79 = block_78: {
                                    break :block_78 value_46;
                                };
                                const operand_81 = block_80: {
                                    break :block_80 value_47;
                                };

                                if ((operand_81 >= (operand_79).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_82 = @as(?u64, (value_43).index);
                                const operand_83 = @constCast(operand_79);

                                (operand_83)[@intCast(operand_81)] = operand_82;
                                break :block_84 operand_83;
                            }, .prefix = (value_43).prefix, .prefixes = (value_43).prefixes, .selection_depth = (value_43).selection_depth, .selections = (value_43).selections, .stack = (value_43).stack, .vertical_count = (value_43).vertical_count, .vertical_counts = (value_43).vertical_counts, .width = (value_43).width, .widths = (value_43).widths, });
                        };
                        const value_49: []const ?u64 = (value_48).partners;
                        const value_50: u64 = (value_48).index;

                        const value_51: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_77: {
                            break :block_77 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_48).depths, .gaps = (value_48).gaps, .index = (value_48).index, .input = (value_48).input, .owners = (value_48).owners, .partners = block_76: {
                                const operand_70 = block_69: {
                                    break :block_69 value_49;
                                };
                                const operand_72 = block_71: {
                                    break :block_71 value_50;
                                };

                                if ((operand_72 >= (operand_70).len)) {
                                    return error.IndexOutOfBounds;
                                }
                                const operand_74 = @as(?u64, block_73: {
                                    break :block_73 value_45;
                                }.?);

                                const operand_75 = @constCast(operand_70);

                                (operand_75)[@intCast(operand_72)] = operand_74;
                                break :block_76 operand_75;
                            }, .prefix = (value_48).prefix, .prefixes = (value_48).prefixes, .selection_depth = (value_48).selection_depth, .selections = (value_48).selections, .stack = (value_48).stack, .vertical_count = (value_48).vertical_count, .vertical_counts = (value_48).vertical_counts, .width = (value_48).width, .widths = (value_48).widths, });
                        };

                        const value_52: u64 = (value_51).selection_depth;

                        const value_53: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_68: {
                            break :block_68 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_51).depths, .gaps = (value_51).gaps, .index = (value_51).index, .input = (value_51).input, .owners = (value_51).owners, .partners = (value_51).partners, .prefix = (value_51).prefix, .prefixes = (value_51).prefixes, .selection_depth = (block_63: {
                                break :block_63 value_52;
                            } - (if (block_67: {
                                const operand_65 = (value_51).selections;

                                const operand_66 = block_64: {
                                    break :block_64 value_45;
                                }.?;

                                if ((operand_66 >= (operand_65).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_67 (operand_65)[@intCast(operand_66)];
                            }) @as(u64, 1) else @as(u64, 0))), .selections = (value_51).selections, .stack = (value_51).stack, .vertical_count = (value_51).vertical_count, .vertical_counts = (value_51).vertical_counts, .width = (value_51).width, .widths = (value_51).widths, });
                        };

                        const value_54: []const u64 = (value_53).depths;
                        const value_55: u64 = (value_53).index;

                        const value_56: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_62: {
                            break :block_62 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = block_61: {
                                const operand_56 = block_55: {
                                    break :block_55 value_54;
                                };
                                const operand_58 = block_57: {
                                    break :block_57 value_55;
                                };

                                if ((operand_58 >= (operand_56).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_59 = ((@as(u64, ((value_53).stack).len) - @as(u64, 1)) + (value_53).selection_depth);
                                const operand_60 = @constCast(operand_56);

                                (operand_60)[@intCast(operand_58)] = operand_59;

                                break :block_61 operand_60;
                            }, .gaps = (value_53).gaps, .index = (value_53).index, .input = (value_53).input, .owners = (value_53).owners, .partners = (value_53).partners, .prefix = (value_53).prefix, .prefixes = (value_53).prefixes, .selection_depth = (value_53).selection_depth, .selections = (value_53).selections, .stack = (value_53).stack, .vertical_count = (value_53).vertical_count, .vertical_counts = (value_53).vertical_counts, .width = (value_53).width, .widths = (value_53).widths, });
                        };

                        break :block_87 value_56;
                    } else value_43);
                    const value_58: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_53: {
                        break :block_53 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_57).depths, .gaps = (value_57).gaps, .index = (value_57).index, .input = (value_57).input, .owners = (value_57).owners, .partners = (value_57).partners, .prefix = (value_57).prefix, .prefixes = (value_57).prefixes, .selection_depth = (value_57).selection_depth, .selections = (value_57).selections, .stack = (value_44).@"0", .vertical_count = (value_57).vertical_count, .vertical_counts = (value_57).vertical_counts, .width = (value_57).width, .widths = (value_57).widths, });
                    };

                    break :block_90 value_58;
                } else value_43);

                const value_61: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = (if (block_44: {
                    break :block_44 value_14;
                }) block_51: {
                    const value_60: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_50: {
                        break :block_50 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_59).depths, .gaps = (value_59).gaps, .index = (value_59).index, .input = (value_59).input, .owners = (value_59).owners, .partners = (value_59).partners, .prefix = (value_59).prefix, .prefixes = (value_59).prefixes, .selection_depth = (value_59).selection_depth, .selections = (value_59).selections, .stack = (block_49: {
                            const operand_45 = (value_59).stack;
                            const operand_46 = (value_59).index;
                            const operand_47 = (try ((std).math).add(usize, (operand_45).len, 1));
                            const operand_48 = (try zxReserve(u64, allocator, operand_45, operand_47, true));

                            (operand_48)[(operand_45).len] = operand_46;

                            break :block_49 @as(value_1d0b18ef22afd555e20d0532bfe580a896ab5b2a8982c73d01ef240b7a6e4658, .{ operand_48, {}, null, });
                        }).@"0", .vertical_count = (value_59).vertical_count, .vertical_counts = (value_59).vertical_counts, .width = (value_59).width, .widths = (value_59).widths, });
                    };

                    break :block_51 value_60;
                } else value_59);

                const value_62: u64 = (value_61).index;

                const value_63: value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af = block_43: {
                    break :block_43 @as(value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af, value_942717ba00d38d2e45a266daddb35722f4907483992d27d39d5d4057dd86a2af{ .depths = (value_61).depths, .gaps = (value_61).gaps, .index = (block_42: {
                        break :block_42 value_62;
                    } + @as(u64, 1)), .input = (value_61).input, .owners = (value_61).owners, .partners = (value_61).partners, .prefix = (value_61).prefix, .prefixes = (value_61).prefixes, .selection_depth = (value_61).selection_depth, .selections = (value_61).selections, .stack = (value_61).stack, .vertical_count = (value_61).vertical_count, .vertical_counts = (value_61).vertical_counts, .width = (value_61).width, .widths = (value_61).widths, });
                };

                break :block_275 value_63;
            };

            state_changed_41 = true;
        }

        break :block_277 (if (state_changed_41) state_14 else operand_40);
    };

    return block_13: {
        const operand_2 = in;
        const operand_3 = (value_64).partners;
        const operand_4 = (value_64).owners;
        const operand_5 = (value_64).depths;
        const operand_6 = (value_64).widths;
        const operand_7 = (value_64).prefixes;
        const operand_8 = (value_64).vertical_counts;
        const operand_9 = (value_64).gaps;

        const operand_10 = block_11: {
            break :block_11 (try (allocator).dupe(u64, (&[_]u64{})));
        };

        const operand_12 = (value_64).selections;

        break :block_13 @as(value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e, value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .input = operand_2, .partners = operand_3, .owners = operand_4, .depths = operand_5, .widths = operand_6, .prefixes = operand_7, .vertical_counts = operand_8, .gaps = operand_9, .trailers = operand_10, .selections = operand_12, });
    };
}

fn function_0(allocator: ((std).mem).Allocator, in: []const u8) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_56: {
        const operand_1 = in;

        break :block_56 (if (block_55: {
            const operand_53 = operand_1;
            const operand_54 = @as([]const u8, "?");

            break :block_55 ((std).mem).eql(u8, operand_53, operand_54);
        }) @as(u64, 1) else (if (block_52: {
            const operand_50 = operand_1;
            const operand_51 = @as([]const u8, "=");

            break :block_52 ((std).mem).eql(u8, operand_50, operand_51);
        }) @as(u64, 1) else (if (block_49: {
            const operand_47 = operand_1;
            const operand_48 = @as([]const u8, "=>");

            break :block_49 ((std).mem).eql(u8, operand_47, operand_48);
        }) @as(u64, 1) else (if (block_46: {
            const operand_44 = operand_1;
            const operand_45 = @as([]const u8, ":");

            break :block_46 ((std).mem).eql(u8, operand_44, operand_45);
        }) @as(u64, 1) else (if (block_43: {
            const operand_41 = operand_1;
            const operand_42 = @as([]const u8, "??");

            break :block_43 ((std).mem).eql(u8, operand_41, operand_42);
        }) @as(u64, 2) else (if (block_40: {
            const operand_38 = operand_1;
            const operand_39 = @as([]const u8, "||");

            break :block_40 ((std).mem).eql(u8, operand_38, operand_39);
        }) @as(u64, 3) else (if (block_37: {
            const operand_35 = operand_1;
            const operand_36 = @as([]const u8, "&&");

            break :block_37 ((std).mem).eql(u8, operand_35, operand_36);
        }) @as(u64, 4) else (if (block_34: {
            const operand_32 = operand_1;
            const operand_33 = @as([]const u8, "==");

            break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
        }) @as(u64, 5) else (if (block_31: {
            const operand_29 = operand_1;
            const operand_30 = @as([]const u8, "!=");

            break :block_31 ((std).mem).eql(u8, operand_29, operand_30);
        }) @as(u64, 5) else (if (block_28: {
            const operand_26 = operand_1;
            const operand_27 = @as([]const u8, "<");

            break :block_28 ((std).mem).eql(u8, operand_26, operand_27);
        }) @as(u64, 6) else (if (block_25: {
            const operand_23 = operand_1;
            const operand_24 = @as([]const u8, ">");

            break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
        }) @as(u64, 6) else (if (block_22: {
            const operand_20 = operand_1;
            const operand_21 = @as([]const u8, "<=");

            break :block_22 ((std).mem).eql(u8, operand_20, operand_21);
        }) @as(u64, 6) else (if (block_19: {
            const operand_17 = operand_1;
            const operand_18 = @as([]const u8, ">=");

            break :block_19 ((std).mem).eql(u8, operand_17, operand_18);
        }) @as(u64, 6) else (if (block_16: {
            const operand_14 = operand_1;
            const operand_15 = @as([]const u8, "+");

            break :block_16 ((std).mem).eql(u8, operand_14, operand_15);
        }) @as(u64, 7) else (if (block_13: {
            const operand_11 = operand_1;
            const operand_12 = @as([]const u8, "-");

            break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
        }) @as(u64, 7) else (if (block_10: {
            const operand_8 = operand_1;
            const operand_9 = @as([]const u8, "*");

            break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
        }) @as(u64, 8) else (if (block_7: {
            const operand_5 = operand_1;
            const operand_6 = @as([]const u8, "/");

            break :block_7 ((std).mem).eql(u8, operand_5, operand_6);
        }) @as(u64, 8) else (if (block_4: {
            const operand_2 = operand_1;
            const operand_3 = @as([]const u8, "%");

            break :block_4 ((std).mem).eql(u8, operand_2, operand_3);
        }) @as(u64, 8) else @as(u64, 0)))))))))))))))))));
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: *const zx_type_22) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    return (block_75: {
        const operand_7 = block_6: {
            const operand_2 = in;
            const operand_3 = (in).index;
            const operand_4 = @as(u64, 0);
            const operand_5 = false;

            break :block_6 zx_type_26{ .input = operand_2, .index = operand_3, .width = operand_4, .done = operand_5, };
        };

        var state_1: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e{ .done = (operand_7).done, .index = (operand_7).index, .input = value_79985eb06631c9582b56297bf35143f667307b8b1a78a0e14308af5cea7dd561{ .graph = value_9da82fc8983b3852d5af72d68f94cf87c9a3093b67b28dd1aa75bb146f18cf7e{ .depths = (((operand_7).input).graph).depths, .gaps = (((operand_7).input).graph).gaps, .input = (((operand_7).input).graph).input, .owners = (((operand_7).input).graph).owners, .partners = (((operand_7).input).graph).partners, .prefixes = (((operand_7).input).graph).prefixes, .selections = (((operand_7).input).graph).selections, .trailers = (((operand_7).input).graph).trailers, .vertical_counts = (((operand_7).input).graph).vertical_counts, .widths = (((operand_7).input).graph).widths, .zx_origin = ((operand_7).input).graph, }, .index = ((operand_7).input).index, .priority = ((operand_7).input).priority, .zx_origin = (operand_7).input, }, .width = (operand_7).width, .zx_origin = (&operand_7), };

        while (((!(state_1).done) and ((state_1).index < @as(u64, (((((state_1).input).graph).input).tokens).len)))) {
            state_1 = block_68: {
                const value_3: *const zx_type_11 = block_67: {
                    const operand_65 = ((((state_1).input).graph).input).tokens;
                    const operand_66 = (state_1).index;

                    if ((operand_66 >= (operand_65).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_67 (operand_65)[@intCast(operand_66)];
                };
                const value_4: ?u64 = block_64: {
                    const operand_62 = (((state_1).input).graph).owners;
                    const operand_63 = (state_1).index;

                    if ((operand_63 >= (operand_62).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_64 (operand_62)[@intCast(operand_63)];
                };
                const value_5: ?u64 = block_61: {
                    const operand_59 = (((state_1).input).graph).owners;
                    const operand_60 = ((state_1).input).index;

                    if ((operand_60 >= (operand_59).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_61 (operand_59)[@intCast(operand_60)];
                };
                const value_6: ?u64 = block_58: {
                    const operand_56 = (((state_1).input).graph).partners;
                    const operand_57 = (state_1).index;

                    if ((operand_57 >= (operand_56).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_58 (operand_56)[@intCast(operand_57)];
                };
                const value_7: bool = (block_49: {
                    const operand_47 = block_45: {
                        break :block_45 value_4;
                    };
                    const operand_48 = block_46: {
                        break :block_46 value_5;
                    };

                    break :block_49 (if (((operand_47 == null) or (operand_48 == null))) ((operand_47 == null) and (operand_48 == null)) else (operand_47.? == operand_48.?));
                } and (block_53: {
                    const operand_51 = (block_50: {
                        break :block_50 value_3;
                    }).text;

                    const operand_52 = @as([]const u8, ",");

                    break :block_53 ((std).mem).eql(u8, operand_51, operand_52);
                } or ((block_54: {
                    break :block_54 value_6;
                } != null) and (block_55: {
                    break :block_55 value_6;
                }.? < (state_1).index))));

                const value_8: bool = (((state_1).index > ((state_1).input).index) and (block_44: {
                    break :block_44 value_3;
                }).newline);

                const value_20: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = (if ((block_8: {
                    break :block_8 value_7;
                } or block_9: {
                    break :block_9 value_8;
                })) block_24: {
                    const value_12: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = (if ((block_11: {
                        break :block_11 value_7;
                    } and (!block_12: {
                        break :block_12 value_8;
                    }))) block_23: {
                        const value_9: u64 = (if ((((state_1).index + @as(u64, 1)) < @as(u64, ((((state_1).input).graph).trailers).len))) block_22: {
                            const operand_20 = (((state_1).input).graph).trailers;
                            const operand_21 = ((state_1).index + @as(u64, 1));

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        } else @as(u64, 0));

                        const value_10: u64 = (state_1).width;

                        const value_11: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = block_19: {
                            break :block_19 @as(value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e, value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e{ .done = (state_1).done, .index = (state_1).index, .input = (state_1).input, .width = (block_13: {
                                break :block_13 value_10;
                            } + ((@as(u64, ((block_14: {
                                break :block_14 value_3;
                            }).text).len) + block_17: {
                                const operand_15 = (((state_1).input).graph).gaps;
                                const operand_16 = (state_1).index;

                                if ((operand_16 >= (operand_15).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_17 (operand_15)[@intCast(operand_16)];
                            }) + block_18: {
                                break :block_18 value_9;
                            })), });
                        };

                        break :block_23 value_11;
                    } else state_1);

                    const value_13: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = block_10: {
                        break :block_10 @as(value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e, value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e{ .done = true, .index = (value_12).index, .input = (value_12).input, .width = (value_12).width, });
                    };

                    break :block_24 value_13;
                } else block_43: {
                    const value_14: u64 = (state_1).width;

                    const value_15: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = block_42: {
                        break :block_42 @as(value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e, value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e{ .done = (state_1).done, .index = (state_1).index, .input = (state_1).input, .width = (block_37: {
                            break :block_37 value_14;
                        } + (@as(u64, ((block_38: {
                            break :block_38 value_3;
                        }).text).len) + block_41: {
                            const operand_39 = (((state_1).input).graph).gaps;
                            const operand_40 = (state_1).index;

                            if ((operand_40 >= (operand_39).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_41 (operand_39)[@intCast(operand_40)];
                        })), });
                    };
                    const value_16: u64 = (try function_0(allocator, (block_36: {
                        break :block_36 value_3;
                    }).text));

                    const value_17: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = block_35: {
                        break :block_35 @as(value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e, value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e{ .done = ((block_27: {
                            break :block_27 value_3;
                        }).object or ((block_32: {
                            const operand_30 = block_28: {
                                break :block_28 value_4;
                            };
                            const operand_31 = block_29: {
                                break :block_29 value_5;
                            };

                            break :block_32 (if (((operand_30 == null) or (operand_31 == null))) ((operand_30 == null) and (operand_31 == null)) else (operand_30.? == operand_31.?));
                        } and (block_33: {
                            break :block_33 value_16;
                        } != @as(u64, 0))) and (block_34: {
                            break :block_34 value_16;
                        } <= ((value_15).input).priority))), .index = (value_15).index, .input = (value_15).input, .width = (value_15).width, });
                    };

                    const value_18: u64 = (value_17).index;

                    const value_19: value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e = block_26: {
                        break :block_26 @as(value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e, value_e80667d95c81d16e6398d7d71d0364d87abd0ca431c891b34618ffce0410020e{ .done = (value_17).done, .index = (block_25: {
                            break :block_25 value_18;
                        } + @as(u64, 1)), .input = (value_17).input, .width = (value_17).width, });
                    };

                    break :block_43 value_19;
                });

                break :block_68 value_20;
            };
        }

        break :block_75 block_74: {
            break :block_74 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_73: {
                break :block_73 zx_type_26{ .done = (state_1).done, .index = (state_1).index, .input = (if ((((state_1).input).zx_origin != null)) ((state_1).input).zx_origin.? else block_72: {
                    const operand_71 = (try (allocator).create(zx_type_22));

                    (operand_71).* = zx_type_22{ .graph = (if (((((state_1).input).graph).zx_origin != null)) (((state_1).input).graph).zx_origin.? else block_70: {
                        const operand_69 = (try (allocator).create(zx_type_18));

                        (operand_69).* = zx_type_18{ .depths = (((state_1).input).graph).depths, .gaps = (((state_1).input).graph).gaps, .input = (((state_1).input).graph).input, .owners = (((state_1).input).graph).owners, .partners = (((state_1).input).graph).partners, .prefixes = (((state_1).input).graph).prefixes, .selections = (((state_1).input).graph).selections, .trailers = (((state_1).input).graph).trailers, .vertical_counts = (((state_1).input).graph).vertical_counts, .widths = (((state_1).input).graph).widths, };

                        break :block_70 @as(*const zx_type_18, operand_69);
                    }), .index = ((state_1).input).index, .priority = ((state_1).input).priority, };

                    break :block_72 @as(*const zx_type_22, operand_71);
                }), .width = (state_1).width, };
            });
        };
    }).width;
}

