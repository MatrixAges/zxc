const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: u64, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    if ((comptime ((std).meta).hasMethod(@TypeOf(context), "begin"))) {
        (try (context).begin([_]u32{0, }));
    }

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = ((context).store_0).*;

    const value_2: u64 = (try (@import("zxc_module_2435939d10fe518e53b63c1c6f9995b8f4a0ade94e91f8557d3e19f2c40f7309")).call(allocator, block_5: {
        const operand_1 = in;
        const operand_2 = value_1;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9));

            (operand_3).* = @as((zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9, (zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9{ .increment = operand_1, .state = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9, operand_3);
        };
    }, store_context_7: {
        const StoreContext_6 = struct {
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

        break :store_context_7 StoreContext_6{ .parent = context, };
    }));

    return value_2;
}
