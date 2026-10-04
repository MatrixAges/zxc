const std = @import("std");
const application = @import("application");
const Self = @This();
const initial_0 = @import("zxc_store_initial_48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720");

arena: *std.heap.ArenaAllocator,
value_0: initial_0.Output = undefined,

store_0: *initial_0.Output = undefined,
pub fn initialize(self: *Self) !void {
    self.value_0 = try initial_0.execute(self.arena, {});
    self.store_0 = &self.value_0;
}

pub fn commit(self: *Self, changes: application.zx_pending) !void {
    var count: usize = 0;

    if (changes.store_0 != null) count += 1;
    if (count > 1) return error.MultipleStoreObjects;
    if (changes.store_0) |value| self.value_0 = value;
}
