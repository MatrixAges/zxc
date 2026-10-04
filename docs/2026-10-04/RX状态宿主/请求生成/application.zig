const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = *const (zx_abi).zx_type_28a83ce26ef5e46abc2550f26a770e0512274a215593bd331ba70d718a441b5c;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!*const (zx_abi).zx_type_28a83ce26ef5e46abc2550f26a770e0512274a215593bd331ba70d718a441b5c {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_82c4500d58b8f61da8ac20d05834dc6b593ef7ef4772463eb5a9e97c3e9b24ec")).call(allocator, value_1));

    const value_3: u64 = (try (@import("zxc_module_327213d625a1a4f2e5f49e4b08df7d16caf19eecdffdad3d991d91aaf7a3b924")).call(allocator, in, store_context_11: {
        const StoreContext_10 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, }));
            }
        };

        break :store_context_11 StoreContext_10{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_4: u64 = (try (@import("zxc_module_327213d625a1a4f2e5f49e4b08df7d16caf19eecdffdad3d991d91aaf7a3b924")).call(allocator, in, store_context_9: {
        const StoreContext_8 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, }));
            }
        };

        break :store_context_9 StoreContext_8{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_5: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_6: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_82c4500d58b8f61da8ac20d05834dc6b593ef7ef4772463eb5a9e97c3e9b24ec")).call(allocator, value_5));

    return block_7: {
        const operand_1 = value_2;
        const operand_2 = value_3;
        const operand_3 = value_4;
        const operand_4 = value_6;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_28a83ce26ef5e46abc2550f26a770e0512274a215593bd331ba70d718a441b5c));

            (operand_5).* = @as((zx_abi).zx_type_28a83ce26ef5e46abc2550f26a770e0512274a215593bd331ba70d718a441b5c, (zx_abi).zx_type_28a83ce26ef5e46abc2550f26a770e0512274a215593bd331ba70d718a441b5c{ .original = operand_1, .first = operand_2, .second = operand_3, .current = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_28a83ce26ef5e46abc2550f26a770e0512274a215593bd331ba70d718a441b5c, operand_5);
        };
    };
}

