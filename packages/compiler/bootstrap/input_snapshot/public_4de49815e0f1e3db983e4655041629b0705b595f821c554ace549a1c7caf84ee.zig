const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;

const zx_shape_0 = .{
    .kind = .string,
};

const zx_shape_1 = .{
    .kind = .scalar,
};

const zx_shape_2 = .{
    .kind = .list,
    .child = zx_shape_1,
};

const zx_shape_3 = .{
    .kind = .scalar,
};

const zx_shape_4 = .{
    .kind = .list,
    .child = zx_shape_3,
};

const zx_shape_5 = .{
    .kind = .list,
    .child = zx_shape_0,
};

const zx_shape_6 = .{
    .kind = .object,
    .fields = .{
        .ctime_high = zx_shape_2,
        .ctime_low = zx_shape_4,
        .inodes = zx_shape_4,
        .mtime_high = zx_shape_2,
        .mtime_low = zx_shape_4,
        .paths = zx_shape_5,
        .read_high = zx_shape_2,
        .read_low = zx_shape_4,
        .sizes = zx_shape_4,
    },
};

const zx_shape_7 = .{
    .kind = .object,
    .fields = .{
        .context = zx_shape_0,
        .files = zx_shape_6,
        .fingerprint = zx_shape_0,
    },
};

const zx_shape_8 = .{
    .kind = .object,
    .fields = .{
        .actual_checksum = zx_shape_0,
        .context = zx_shape_0,
        .current = zx_shape_6,
        .now_high = zx_shape_1,
        .now_low = zx_shape_3,
        .previous = zx_shape_7,
        .stored_checksum = zx_shape_0,
    },
};

const zx_shape_9 = .{
    .kind = .scalar,
};

pub const input_shape = zx_shape_8;
pub const output_shape = zx_shape_9;
pub const Input = *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048;
pub const Output = bool;

pub fn executeIn(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_9a4812aef1582889b1781334e5886af88d2d5441fc7c9b39c0c647c122aa4e46.zig")).call(allocator, in));
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    return executeIn((arena).allocator(), in);
}

pub const executeValue = executeIn;
