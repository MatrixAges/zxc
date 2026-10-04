const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = *const (zx_abi).zx_type_d803453a047b8af8851c7488b29bdfebcbf3b477476a716c9f007afdc571fb6e;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!*const (zx_abi).zx_type_d803453a047b8af8851c7488b29bdfebcbf3b477476a716c9f007afdc571fb6e {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: u64 = (try (@import("zxc_module_c88c610977dc252a1728a0dd66d1024f93356eeb920cdd9c6da2e75af2114754")).call(allocator, {}, store_context_15: {
        const StoreContext_14 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
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

        break :store_context_15 StoreContext_14{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_2: u64 = (try (@import("zxc_module_d4d7d429fca2e20d04f9391baeacd773f64b6f194556a2de41d112ffd64e457b")).call(allocator, in, store_context_13: {
        const StoreContext_12 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
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

        break :store_context_13 StoreContext_12{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_3: u64 = (try (@import("zxc_module_d4d7d429fca2e20d04f9391baeacd773f64b6f194556a2de41d112ffd64e457b")).call(allocator, in, store_context_11: {
        const StoreContext_10 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
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

        break :store_context_11 StoreContext_10{ .parent = context, .store_0 = (context).store_0, };
    }));

    const value_4: u64 = (try (@import("zxc_module_c88c610977dc252a1728a0dd66d1024f93356eeb920cdd9c6da2e75af2114754")).call(allocator, {}, store_context_9: {
        const StoreContext_8 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
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

        break :store_context_9 StoreContext_8{ .parent = context, .store_0 = (context).store_0, };
    }));

    return block_7: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = value_3;
        const operand_4 = value_4;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_d803453a047b8af8851c7488b29bdfebcbf3b477476a716c9f007afdc571fb6e));

            (operand_5).* = @as((zx_abi).zx_type_d803453a047b8af8851c7488b29bdfebcbf3b477476a716c9f007afdc571fb6e, (zx_abi).zx_type_d803453a047b8af8851c7488b29bdfebcbf3b477476a716c9f007afdc571fb6e{ .before = operand_1, .first = operand_2, .second = operand_3, .after = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_d803453a047b8af8851c7488b29bdfebcbf3b477476a716c9f007afdc571fb6e, operand_5);
        };
    };
}
