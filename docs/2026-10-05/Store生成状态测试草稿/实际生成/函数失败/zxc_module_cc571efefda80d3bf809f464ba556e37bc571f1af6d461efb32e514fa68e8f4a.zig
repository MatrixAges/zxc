const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;
    const value_2: u64 = (try (@import("zxc_module_18405a4371f817a7be5c20e7ac0965bbcdaf1d7a32fcf3a63e0a01b21e1adfed")).call(allocator, block_6: {
        const operand_1 = (in).increment;
        const operand_2 = (in).index;
        const operand_3 = value_1;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6));

            (operand_4).* = @as((zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6, (zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6{ .increment = operand_1, .index = operand_2, .state = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6, operand_4);
        };
    }, store_context_8: {
        const StoreContext_7 = struct {
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

        break :store_context_8 StoreContext_7{ .parent = context, };
    }));

    return value_2;
}

