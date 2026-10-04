const std = @import("std");
const application = @import("application");
const Self = @This();
const initial_0 = @import("zxc_store_initial_7b39a9bbf8bc215ecc3bc1884a8848d0d4d59abcbbe34ffb2577045458c84de5");
const initial_1 = @import("zxc_store_initial_97556df5e8ef047863d2bb6d161d930a2efa055fcf2885ab639b2e83c3c85dea");

arena: *std.heap.ArenaAllocator,
retained: ?*Region = null,
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
    if (try validate(changes)) self.apply(changes);
}

fn validate(changes: application.zx_pending) !bool {
    var count: usize = 0;

    if (changes.store_0 != null) count += 1;
    if (changes.store_1 != null) count += 1;
    if (count > 1) return error.MultipleStoreObjects;

    return count != 0;
}

fn apply(self: *Self, changes: application.zx_pending) void {
    if (changes.store_0) |value| self.value_0 = value;
    if (changes.store_1) |value| self.value_1 = value;
}

const Region = struct {
    arena: std.heap.ArenaAllocator,
    next: ?*Region,
};

pub fn deinit(self: *Self) void {
    var region = self.retained;

    while (region) |current| {
        const next = current.next;

        current.arena.deinit();

        region = next;
    }

    self.retained = null;
}

pub fn request(self: *Self) Request {
    return .{
        .parent = self,
        .arena = std.heap.ArenaAllocator.init(self.arena.child_allocator),
        .store_0 = self.store_0,
        .store_1 = self.store_1,
    };
}

pub const Request = struct {
    parent: *Self,
    arena: std.heap.ArenaAllocator,
    retained: ?*Region = null,
    store_0: *initial_0.Output,
    store_1: *initial_1.Output,
    pub fn execute(self: *Request, input: application.Input) !application.Output {
        return application.execute(&self.arena, input, self);
    }
    pub fn deinit(self: *Request) void {
        if (self.retained) |region| {
            region.arena = self.arena;
        } else self.arena.deinit();

        self.* = undefined;
    }

    pub fn commit(self: *Request, changes: application.zx_pending) !void {
        if (!try Self.validate(changes)) return;

        if (self.retained == null) {
            const region = try self.parent.arena.allocator().create(Region);

            region.* = .{
                .arena = std.heap.ArenaAllocator.init(self.parent.arena.child_allocator),
                .next = self.parent.retained,
            };

            self.parent.retained = region;
            self.retained = region;
        }

        self.parent.apply(changes);
    }
};
