const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: u64, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_7690ebc84f085e3301e6b1c794cd66b7fba54fb883b38a5a51cb9259233a3806")).call(allocator, in, store_context_2: {
        const StoreContext_1 = struct {
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

        break :store_context_2 StoreContext_1{ .parent = context, .store_0 = (context).store_0, };
    }));
}
