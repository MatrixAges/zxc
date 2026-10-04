const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = *const (zx_abi).zx_type_11e8e62e94dfbf6dec6c2a6e4e1cce79964b6f00e1e3fd3d293765e91abca908;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
    store_1: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!*const (zx_abi).zx_type_11e8e62e94dfbf6dec6c2a6e4e1cce79964b6f00e1e3fd3d293765e91abca908 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_16babf993030ff68c599fbdb88988cafdf5044448b9c6d9948fbfb704a981ed0")).call(allocator, value_1));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_3: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_1).*;
    const value_4: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_16babf993030ff68c599fbdb88988cafdf5044448b9c6d9948fbfb704a981ed0")).call(allocator, value_3));

    const value_5: u64 = (try (@import("zxc_module_cc571efefda80d3bf809f464ba556e37bc571f1af6d461efb32e514fa68e8f4a")).call(allocator, in, store_context_14: {
        const StoreContext_13 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, .store_1 = null, }));
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

        break :store_context_14 StoreContext_13{ .parent = context, .store_0 = (context).store_0, };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_6: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_1).*;
    const value_7: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_16babf993030ff68c599fbdb88988cafdf5044448b9c6d9948fbfb704a981ed0")).call(allocator, value_6));

    const value_8: u64 = (try (@import("zxc_module_4d1dc412a27fb589f50a4b7bdaba85084668cbc49c31dbbc366e229879218dcd")).call(allocator, in, store_context_12: {
        const StoreContext_11 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_1),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = null, .store_1 = (changes).store_0, }));
            }
            pub fn begin(self: @This(), comptime slots: anytype) anyerror!void {
                if ((comptime ((std).meta).hasMethod(@TypeOf((self).parent), "begin"))) {
                    (try ((self).parent).begin((comptime mapped_slots: {
                        var selected = slots;

                        for ((&selected)) |*slot| {
                            (slot).* = ([_]u32{1, })[(slot).*];
                        }

                        break :mapped_slots selected;
                    })));
                }
            }
        };

        break :store_context_12 StoreContext_11{ .parent = context, .store_0 = (context).store_1, };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_9: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_10: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_16babf993030ff68c599fbdb88988cafdf5044448b9c6d9948fbfb704a981ed0")).call(allocator, value_9));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_11: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_1).*;
    const value_12: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = (try (@import("zxc_module_16babf993030ff68c599fbdb88988cafdf5044448b9c6d9948fbfb704a981ed0")).call(allocator, value_11));

    return block_10: {
        const operand_1 = value_2;
        const operand_2 = value_4;
        const operand_3 = value_7;
        const operand_4 = value_10;
        const operand_5 = value_12;
        const operand_6 = value_5;
        const operand_7 = value_8;

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create((zx_abi).zx_type_11e8e62e94dfbf6dec6c2a6e4e1cce79964b6f00e1e3fd3d293765e91abca908));

            (operand_8).* = @as((zx_abi).zx_type_11e8e62e94dfbf6dec6c2a6e4e1cce79964b6f00e1e3fd3d293765e91abca908, (zx_abi).zx_type_11e8e62e94dfbf6dec6c2a6e4e1cce79964b6f00e1e3fd3d293765e91abca908{ .before_left = operand_1, .before_right = operand_2, .untouched = operand_3, .after_left = operand_4, .after_right = operand_5, .first = operand_6, .second = operand_7, });

            break :block_9 @as(*const (zx_abi).zx_type_11e8e62e94dfbf6dec6c2a6e4e1cce79964b6f00e1e3fd3d293765e91abca908, operand_8);
        };
    };
}
