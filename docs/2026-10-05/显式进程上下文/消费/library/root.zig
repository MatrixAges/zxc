const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = *const (zx_abi).zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec;
pub const consumes_input = false;
pub const requires_io = true;
pub const requires_process = true;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void, io: (std).Io, process: (((std).process).Init).Minimal) anyerror!*const (zx_abi).zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_6: {
        const operand_1 = (try (@import("zxc_module_ceab86de37cf192e0c605a9eac617af4c7f6713df976b8c83d0e50fc3f8e4e1d")).call(allocator, {}, process));
        const operand_2 = (try (@import("zxc_module_ee895aa56776d064344d2feeac739196665f440af61d11eb5fe5269d4d9b9707")).call(allocator, @as([]const u8, "ZXC_PROCESS_PROBE"), process));
        const operand_3 = (try (@import("zxc_module_20a1ef9ac5b4798f490f63ec5a650015f341d705b4158b9a0e46b29cd35a52f5")).call(allocator, {}, io));

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec));

            (operand_4).* = @as((zx_abi).zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec, (zx_abi).zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec{ .args = operand_1, .value = operand_2, .directory = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_da74f2239c103744b4247bd52a9ca5f859cef1c4234dffe1c3df2b45f3c5bcec, operand_4);
        };
    };
}

