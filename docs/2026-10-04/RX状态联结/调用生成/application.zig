const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d;
pub const Pending = *const (zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be;
pub const State = *const (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6;
pub const Output = u64;

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6,
    store_1: ?*const (zx_abi).zx_type_8cd497979d0b35efdc3275b9c12aab7d07ef6d57b99f5ac84fac6e25093c7eb6,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_b84038ca9b650498bc21102904c8221b7cc79c5a7b63e9f4695850ea4b6ab72d, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = (try (@import("zxc_module_852fb05da189c88958ff47970dc7c02ffc11531ac7653b6ddc98b3d76ef1104d")).call(allocator, in, store_context_4: {
        const StoreContext_3 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_1),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = null, .store_1 = (changes).store_0, }));
            }
        };

        break :store_context_4 StoreContext_3{ .parent = context, .store_0 = (context).store_1, };
    }));

    _ = (try (@import("zxc_module_852fb05da189c88958ff47970dc7c02ffc11531ac7653b6ddc98b3d76ef1104d")).call(allocator, in, store_context_2: {
        const StoreContext_1 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_1),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = null, .store_1 = (changes).store_0, }));
            }
        };

        break :store_context_2 StoreContext_1{ .parent = context, .store_0 = (context).store_1, };
    }));

    return (((context).store_1).*).count;
}

