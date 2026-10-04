const std = @import("std");
const application = @import("application");
const Self = @This();

const initial_0 = @import("zxc_store_initial_7b39a9bbf8bc215ecc3bc1884a8848d0d4d59abcbbe34ffb2577045458c84de5");
const initial_1 = @import("zxc_store_initial_97556df5e8ef047863d2bb6d161d930a2efa055fcf2885ab639b2e83c3c85dea");

arena: *std.heap.ArenaAllocator,
value_0: initial_0.Output = undefined,
store_0: *initial_0.Output = undefined,
value_1: initial_1.Output = undefined,
store_1: *initial_1.Output = undefined,

pub fn initialize(self: *Self) !void {
    self.value_0 = try initial_0.execute(self.arena, {});
    self.store_0 = &self.value_0;
    self.value_1 = try initial_1.execute(self.arena, {});
    self.store_1 = &self.value_1;
}

pub fn commit(self: *Self, changes: application.zx_pending) !void {
    var count: usize = 0;
    if (changes.store_0 != null) count += 1;
    if (changes.store_1 != null) count += 1;
    if (count > 1) return error.MultipleStoreObjects;

    if (changes.store_0 != null) return error.StoreNotWritable;
    if (changes.store_1) |value| self.value_1 = value;
}
