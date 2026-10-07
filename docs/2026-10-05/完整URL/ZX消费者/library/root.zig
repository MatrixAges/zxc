const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_a33b5217e8b3fc5301bcb6269d51e6aeb8bf78522132544102991082fdaf6b17;
pub const Output = *const (zx_abi).zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_a33b5217e8b3fc5301bcb6269d51e6aeb8bf78522132544102991082fdaf6b17) anyerror!*const (zx_abi).zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5 = (try (@import("zxc_module_7318a572e20e0801b09b7e0c6e3d6f9bdafef99c84bd84cfde6917004ceebe9d")).call(allocator, (in).address));

    const value_2: *const (zx_abi).zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5 = (try (@import("zxc_module_862317882b28a27c11d014f36c0503f929ceca248d7721908779a4810ae96c8c")).call(allocator, block_46: {
        const operand_42 = (in).relative;
        const operand_43 = @as(?[]const u8, (in).address);

        break :block_46 block_45: {
            const operand_44 = (try (allocator).create((zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd));

            (operand_44).* = @as((zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd, (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd{ .input = operand_42, .base = operand_43, });

            break :block_45 @as(*const (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd, operand_44);
        };
    }));

    const value_3: []const u8 = (try (@import("zxc_module_184a6c51ea04d6fa72138d3e7d356ebb2fce0d79d95095f9937b2a642b415046")).call(allocator, block_41: {
        const operand_36 = (in).file_path;
        const operand_37 = @as((zx_abi).zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16, .Posix);
        const operand_38 = (in).cwd;

        break :block_41 block_40: {
            const operand_39 = (try (allocator).create((zx_abi).zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078));

            (operand_39).* = @as((zx_abi).zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078, (zx_abi).zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078{ .path = operand_36, .platform = operand_37, .cwd = operand_38, });

            break :block_40 @as(*const (zx_abi).zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078, operand_39);
        };
    }));

    const value_4: *const (zx_abi).zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5 = (try (@import("zxc_module_7318a572e20e0801b09b7e0c6e3d6f9bdafef99c84bd84cfde6917004ceebe9d")).call(allocator, value_3));

    return block_35: {
        const operand_1 = value_1;
        const operand_2 = (try (@import("zxc_module_3bb1a823766ec208fff506832f14e592a1b39a5b5c560198a59147e2fd021fe7")).call(allocator, value_2));
        const operand_3 = (try (@import("zxc_module_3bb1a823766ec208fff506832f14e592a1b39a5b5c560198a59147e2fd021fe7")).call(allocator, value_1));
        const operand_4 = (try (@import("zxc_module_aa9a067085cfbc58391b9a900aba6859d151fe6bbfbb281e0997e254ba73088a")).call(allocator, value_1));
        const operand_5 = (try (@import("zxc_module_173678ed421757f042dafb952025de758bc05623d03d3ef8e56305b84192edf0")).call(allocator, value_1));
        const operand_6 = (try (@import("zxc_module_fa80c79528c1b09ebf4084ec9c56bba6f91c14c4586bf4cfd101d76aa85d1dcd")).call(allocator, (in).domain));
        const operand_7 = (try (@import("zxc_module_b1d65d61baaee201ecb2dc685839f117f61e624134860188428cb859ebc02237")).call(allocator, (in).domain));
        const operand_8 = value_3;

        const operand_9 = (try (@import("zxc_module_2e2a93364a8017bafb393f8ca370f2bafb98ba2ee2bfc943844e3e39b07666c5")).call(allocator, block_14: {
            const operand_10 = value_4;
            const operand_11 = @as((zx_abi).zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16, .Posix);

            break :block_14 block_13: {
                const operand_12 = (try (allocator).create((zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54));

                (operand_12).* = @as((zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54, (zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54{ .url = operand_10, .platform = operand_11, });

                break :block_13 @as(*const (zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54, operand_12);
            };
        }));

        const operand_15 = (try (@import("zxc_module_b511d3b6a9c27c88edd240133e6adf512250878ecd0cc718c59fb9947c3586e6")).call(allocator, block_20: {
            const operand_16 = value_4;
            const operand_17 = @as((zx_abi).zx_type_f6d6ab611985bd12e0a73fbf88820d3607dab8f0fab9af51709195c1c0f28a16, .Posix);

            break :block_20 block_19: {
                const operand_18 = (try (allocator).create((zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54));

                (operand_18).* = @as((zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54, (zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54{ .url = operand_16, .platform = operand_17, });

                break :block_19 @as(*const (zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54, operand_18);
            };
        }));

        const operand_21 = (try (@import("zxc_module_17301f56aa469cd2bcdeed4c5c2acce33c6e05fc457bf99658bf96c1322de779")).call(allocator, block_26: {
            const operand_22 = (in).address;
            const operand_23 = @as(?[]const u8, null);

            break :block_26 block_25: {
                const operand_24 = (try (allocator).create((zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd));

                (operand_24).* = @as((zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd, (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd{ .input = operand_22, .base = operand_23, });

                break :block_25 @as(*const (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd, operand_24);
            };
        }));

        const operand_27 = (try (@import("zxc_module_cac988214a2deaff641c7c3d8b3f8e5bd0701c6f25577bbd89a4b1ea6fdfab89")).call(allocator, block_32: {
            const operand_28 = (in).invalid;
            const operand_29 = @as(?[]const u8, null);

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd));

                (operand_30).* = @as((zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd, (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd{ .input = operand_28, .base = operand_29, });

                break :block_31 @as(*const (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd, operand_30);
            };
        }));

        break :block_35 block_34: {
            const operand_33 = (try (allocator).create((zx_abi).zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192));

            (operand_33).* = @as((zx_abi).zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192, (zx_abi).zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192{ .parsed = operand_1, .resolved = operand_2, .serialized = operand_3, .pathname = operand_4, .origin = operand_5, .ascii = operand_6, .unicode = operand_7, .file_url = operand_8, .file_path = operand_9, .file_bytes = operand_15, .valid = operand_21, .invalid = operand_27, });

            break :block_34 @as(*const (zx_abi).zx_type_894f75cb694b26eafee4c50bf6b39c74da8da16713636a52bf403e7aa9de9192, operand_33);
        };
    };
}

