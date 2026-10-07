const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79;
pub const Output = (zx_abi).zx_type_be89fb2b411515188d522f46aa8e8421d3fb4c8bcc6fb127b0fb70e1a64f402e;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .native_reference, };
const zx_shape_12 = .{ .kind = .native_reference, };
const zx_shape_13 = .{ .kind = .native_reference, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_5, .@"2" = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .scalar, };
const zx_shape_18 = .{ .kind = .scalar, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .fallback = zx_shape_5, .kind = zx_shape_18, .name = zx_shape_10, .required = zx_shape_1, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_17, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_17;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79) error{ }!(zx_abi).zx_type_be89fb2b411515188d522f46aa8e8421d3fb4c8bcc6fb127b0fb70e1a64f402e {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: (zx_abi).zx_type_be89fb2b411515188d522f46aa8e8421d3fb4c8bcc6fb127b0fb70e1a64f402e = (try (@import("zxc_module_5a81e1912231a71f1b90f905e933faf58698ff17d6743a9c7b7d83dce4c8856c")).call(allocator, in));

    return value_1;
}

