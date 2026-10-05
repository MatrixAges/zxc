const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;
pub const Input = u64;
pub const Output = u64;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;

    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_a90da377ff12e32470eeae28fa6748f7c3fae02be257e158b0d76ef60ac2c41b")).call(allocator, block_10: {
        const operand_6 = in;
        const operand_7 = value_1;

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create((zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9));

            (operand_8).* = @as((zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9, (zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9{ .increment = operand_6, .state = operand_7, });

            break :block_9 @as(*const (zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9, operand_8);
        };
    }, store_context_12: {
        const StoreContext_11 = struct {
            parent: @TypeOf(context),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, }));
            }
            pub fn begin(self: @This(), comptime slots: anytype) anyerror!void {
                if ((comptime ((std).meta).hasMethod(@TypeOf((self).parent), "begin"))) {
                    (try ((self).parent).begin((comptime mapped_slots: {
                        var selected = slots;

                        for ((&selected)) |*slot| {
                            (slot).* = ([_]u32{0, })[(slot).*];
                        }

                        break :mapped_slots selected;
                    })));
                }
            }
        };

        break :store_context_12 StoreContext_11{ .parent = context, };
    }));

    const value_3: u64 = (try (@import("zxc_module_3d7bd25413c79b7cc99c827e455bc0293fcbd594b262216eff19bb17017e3df0")).call(allocator, block_5: {
        const operand_1 = (value_2).history;
        const operand_2 = in;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_d460ce9a70a5e6244cb3db0b13850313c4687230311a46f4201cacbfa860e05e));

            (operand_3).* = @as((zx_abi).zx_type_d460ce9a70a5e6244cb3db0b13850313c4687230311a46f4201cacbfa860e05e, (zx_abi).zx_type_d460ce9a70a5e6244cb3db0b13850313c4687230311a46f4201cacbfa860e05e{ .values = operand_1, .index = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_d460ce9a70a5e6244cb3db0b13850313c4687230311a46f4201cacbfa860e05e, operand_3);
        };
    }));

    return value_3;
}

