const std = @import("std");
const Store = @import("store.zig").Store;

pub fn Request(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        io: std.Io,
        owner: *Store(T),
        current: Store(T).Snapshot,
        previous: std.ArrayList(Store(T).Snapshot) = .empty,
        value: T,
        const Self = @This();

        pub fn init(allocator: std.mem.Allocator, io: std.Io, owner: *Store(T)) std.Io.Cancelable!Self {
            const current = try owner.snapshot(io);

            return .{ .allocator = allocator, .io = io, .owner = owner, .current = current, .value = current.value() };
        }
        pub fn deinit(self: *Self) void {
            for (self.previous.items) |*snapshot| snapshot.deinit();

            self.previous.deinit(self.allocator);
            self.current.deinit();

            self.* = undefined;
        }
        pub fn commit(self: *Self, value: T, persistence: anytype) !void {
            try self.previous.ensureUnusedCapacity(self.allocator, 1);

            const next = try self.owner.commit(self.io, self.current, value, persistence);

            self.previous.appendAssumeCapacity(self.current);

            self.current = next;
            self.value = next.value();
        }
    };
}
