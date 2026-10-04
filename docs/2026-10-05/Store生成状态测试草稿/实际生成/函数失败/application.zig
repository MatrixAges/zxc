const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const Input = *const (zx_abi).zx_type_15aae4ccbfbe98de70ec70abe1300a25f4c66c2917790623e26fec0842f8c226;

pub const Output = *const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
    store_1: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15aae4ccbfbe98de70ec70abe1300a25f4c66c2917790623e26fec0842f8c226, context: anytype) anyerror!*const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try (@import("zxc_module_cc571efefda80d3bf809f464ba556e37bc571f1af6d461efb32e514fa68e8f4a")).call(allocator, block_18: {
        const operand_14 = (in).increment;
        const operand_15 = (in).left_index;

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d));

            (operand_16).* = @as((zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d, (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d{ .increment = operand_14, .index = operand_15, });

            break :block_17 @as(*const (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d, operand_16);
        };
    }, store_context_20: {
        const StoreContext_19 = struct {
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

        break :store_context_20 StoreContext_19{ .parent = context, .store_0 = (context).store_0, };
    }));

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{1, }));
    }

    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_1).*;
    const value_3: u64 = (try (@import("zxc_module_18405a4371f817a7be5c20e7ac0965bbcdaf1d7a32fcf3a63e0a01b21e1adfed")).call(allocator, block_11: {
        const operand_6 = (in).increment;
        const operand_7 = (in).right_index;
        const operand_8 = value_2;

        break :block_11 block_10: {
            const operand_9 = (try (allocator).create((zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6));

            (operand_9).* = @as((zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6, (zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6{ .increment = operand_6, .index = operand_7, .state = operand_8, });

            break :block_10 @as(*const (zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6, operand_9);
        };
    }, store_context_13: {
        const StoreContext_12 = struct {
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

        break :store_context_13 StoreContext_12{ .parent = context, };
    }));

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_3;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247));

            (operand_3).* = @as((zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247, (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247{ .first = operand_1, .second = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247, operand_3);
        };
    };
}

