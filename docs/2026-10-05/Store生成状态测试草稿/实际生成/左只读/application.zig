const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const Input = u64;

pub const Output = *const (zx_abi).zx_type_0400bb02e489ed406da40bcf4dafb819ada8c399d8ae6ddf33c845df84e4e2a6;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
    store_1: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!*const (zx_abi).zx_type_0400bb02e489ed406da40bcf4dafb819ada8c399d8ae6ddf33c845df84e4e2a6 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_2: *const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247 = (try (@import("zxc_module_4481bebfa87d82c45745378b63d2906a4407d8d6faed9c18c66cabec61b87640")).call(allocator, block_42: {
        const operand_38 = (value_1).value;
        const operand_39 = (value_1).value;

        break :block_42 block_41: {
            const operand_40 = (try (allocator).create((zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247));

            (operand_40).* = @as((zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247, (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247{ .first = operand_38, .second = operand_39, });

            break :block_41 @as(*const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247, operand_40);
        };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, 1, }));
    }

    const value_3: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_4: u64 = (try (@import("zxc_module_610d8a6c9fcdf5df756d53035d953970d98cdd07311b1f41b872fc5ecd6eccf3")).call(allocator, block_35: {
        const operand_30 = (value_3).value;
        const operand_31 = (value_3).value;
        const operand_32 = in;

        break :block_35 block_34: {
            const operand_33 = (try (allocator).create((zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049));

            (operand_33).* = @as((zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049{ .first = operand_30, .second = operand_31, .increment = operand_32, });

            break :block_34 @as(*const (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, operand_33);
        };
    }, store_context_37: {
        const StoreContext_36 = struct {
            parent: @TypeOf(context),
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

        break :store_context_37 StoreContext_36{ .parent = context, };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_5: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_1).*;
    const value_6: *const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247 = (try (@import("zxc_module_4481bebfa87d82c45745378b63d2906a4407d8d6faed9c18c66cabec61b87640")).call(allocator, block_29: {
        const operand_25 = (value_5).value;
        const operand_26 = (value_5).value;

        break :block_29 block_28: {
            const operand_27 = (try (allocator).create((zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247));

            (operand_27).* = @as((zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247, (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247{ .first = operand_25, .second = operand_26, });

            break :block_28 @as(*const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247, operand_27);
        };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_7: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_1).*;
    const value_8: u64 = (try (@import("zxc_module_610d8a6c9fcdf5df756d53035d953970d98cdd07311b1f41b872fc5ecd6eccf3")).call(allocator, block_22: {
        const operand_17 = (value_7).value;
        const operand_18 = (value_7).value;
        const operand_19 = in;

        break :block_22 block_21: {
            const operand_20 = (try (allocator).create((zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049));

            (operand_20).* = @as((zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049{ .first = operand_17, .second = operand_18, .increment = operand_19, });

            break :block_21 @as(*const (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, operand_20);
        };
    }, store_context_24: {
        const StoreContext_23 = struct {
            parent: @TypeOf(context),
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

        break :store_context_24 StoreContext_23{ .parent = context, };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_9: u64 = (try (@import("zxc_module_610d8a6c9fcdf5df756d53035d953970d98cdd07311b1f41b872fc5ecd6eccf3")).call(allocator, block_14: {
        const operand_9 = in;
        const operand_10 = in;
        const operand_11 = in;

        break :block_14 block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049));

            (operand_12).* = @as((zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049{ .first = operand_9, .second = operand_10, .increment = operand_11, });

            break :block_13 @as(*const (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, operand_12);
        };
    }, store_context_16: {
        const StoreContext_15 = struct {
            parent: @TypeOf(context),
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

        break :store_context_16 StoreContext_15{ .parent = context, };
    }));

    return block_8: {
        const operand_1 = value_2;
        const operand_2 = value_4;
        const operand_3 = value_6;
        const operand_4 = value_8;
        const operand_5 = value_9;

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_0400bb02e489ed406da40bcf4dafb819ada8c399d8ae6ddf33c845df84e4e2a6));

            (operand_6).* = @as((zx_abi).zx_type_0400bb02e489ed406da40bcf4dafb819ada8c399d8ae6ddf33c845df84e4e2a6, (zx_abi).zx_type_0400bb02e489ed406da40bcf4dafb819ada8c399d8ae6ddf33c845df84e4e2a6{ .before = operand_1, .written = operand_2, .after = operand_3, .overlap = operand_4, .only = operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_0400bb02e489ed406da40bcf4dafb819ada8c399d8ae6ddf33c845df84e4e2a6, operand_6);
        };
    };
}

