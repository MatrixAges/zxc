const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = (try (@import("zxc_module_8ac8392c768edebf5e44fee61b1007dc942718ab0b4f0c63c54f50ef0d8118b6")).call(allocator, in, store_context_2: {
        const StoreContext_1 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = (changes).store_0, }));
            }
        };

        break :store_context_2 StoreContext_1{ .parent = context, .store_0 = (context).store_0, };
    }));

    return (((context).store_0).*).count;
}

