const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;

const zx_shape_0 = .{
    .kind = .scalar,
};

const zx_shape_1 = .{
    .kind = .list,
    .child = zx_shape_0,
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
    .kind = .object,
    .fields = .{
        .callees = zx_shape_2,
        .partitions = zx_shape_0,
        .roots = zx_shape_1,
        .sizes = zx_shape_4,
    },
};

const zx_shape_6 = .{
    .kind = .object,
    .fields = .{
        .members = zx_shape_2,
        .owners = zx_shape_4,
    },
};

pub const input_shape = zx_shape_5;
pub const output_shape = zx_shape_6;
pub const Input = *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44;
pub const Output = *const (zx_abi).zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959;

pub fn executeIn(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959 {
    @setRuntimeSafety(true);

    return block_5: {
        const operand_1 = in;
        const operand_2 = (try (@import("zxc_module_509aa095f76b3a3a4b92135109bfcf97ae7e03060f6778c6dd0f392cddebf64d.zig")).callValue(allocator, operand_1));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959));

            (operand_3).* = (zx_abi).zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959{
                .members = ((operand_2).members).items,
                .owners = ((operand_2).owners).items,
            };

            break :block_4 @as(*const (zx_abi).zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959, operand_3);
        });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!*const (zx_abi).zx_type_48bedc59e6fd55bdcf9cfd24f316ecfa1bb6ac897abc35449c6cfcd6fac6b959 {
    return executeIn((arena).allocator(), in);
}

pub const executeState = (@import("zxc_module_509aa095f76b3a3a4b92135109bfcf97ae7e03060f6778c6dd0f392cddebf64d.zig")).callValue;

pub fn executeValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).view_value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77 {
    @setRuntimeSafety(true);

    const operand_8 = block_7: {
        break :block_7 (try (@import("zxc_module_509aa095f76b3a3a4b92135109bfcf97ae7e03060f6778c6dd0f392cddebf64d.zig")).callValue(allocator, block_6: {
            break :block_6 in;
        }));
    };

    return (zx_abi).view_value_b0e34e7ffc58a6e785576325b84c66ba56b2fe132ed315868a830c44d84bdb77{
        .members = ((operand_8).members).items,
        .owners = ((operand_8).owners).items,
        .zx_origin = (operand_8).zx_origin,
    };
}
