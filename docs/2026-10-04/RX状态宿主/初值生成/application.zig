const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = *const (zx_abi).zx_type_582b0e2cb75cedfd9f2e9696b5e65f62eae935784566db602166f3278c41e64c;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!*const (zx_abi).zx_type_582b0e2cb75cedfd9f2e9696b5e65f62eae935784566db602166f3278c41e64c {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: u64 = (try (@import("zxc_module_327213d625a1a4f2e5f49e4b08df7d16caf19eecdffdad3d991d91aaf7a3b924")).call(allocator, in, store_context_10: {
        const StoreContext_9 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, }));
            }
        };

        break :store_context_10 StoreContext_9{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_2: u64 = (try (@import("zxc_module_327213d625a1a4f2e5f49e4b08df7d16caf19eecdffdad3d991d91aaf7a3b924")).call(allocator, in, store_context_8: {
        const StoreContext_7 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, }));
            }
        };

        break :store_context_8 StoreContext_7{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_3: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_4: u64 = (try (@import("zxc_module_82c4500d58b8f61da8ac20d05834dc6b593ef7ef4772463eb5a9e97c3e9b24ec")).call(allocator, (value_3).value));

    return block_6: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = value_4;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_582b0e2cb75cedfd9f2e9696b5e65f62eae935784566db602166f3278c41e64c));

            (operand_4).* = @as((zx_abi).zx_type_582b0e2cb75cedfd9f2e9696b5e65f62eae935784566db602166f3278c41e64c, (zx_abi).zx_type_582b0e2cb75cedfd9f2e9696b5e65f62eae935784566db602166f3278c41e64c{ .first = operand_1, .second = operand_2, .current = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_582b0e2cb75cedfd9f2e9696b5e65f62eae935784566db602166f3278c41e64c, operand_4);
        };
    };
}

