const std = @import("std");

pub fn Store(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        current: *Revision,
        mutex: std.Io.Mutex = .init,
        const Self = @This();

        const Revision = @import("store/revision.zig").Revision(T);

        pub const Snapshot = struct {
            node: *Revision,
            pub fn value(self: Snapshot) T {
                return self.node.value;
            }
            pub fn revision(self: Snapshot) u64 {
                return self.node.number;
            }
            pub fn retain(self: Snapshot) Snapshot {
                self.node.retain();

                return self;
            }
            pub fn deinit(self: *Snapshot) void {
                self.node.release();

                self.* = undefined;
            }
        };
        pub fn init(allocator: std.mem.Allocator, value: T, revision: u64) std.mem.Allocator.Error!Self {
            return .{ .allocator = allocator, .current = try Revision.create(allocator, value, revision) };
        }
        pub fn deinit(self: *Self) void {
            self.current.release();

            self.* = undefined;
        }
        pub fn snapshot(self: *Self, io: std.Io) std.Io.Cancelable!Snapshot {
            try self.mutex.lock(io);

            defer self.mutex.unlock(io);
            self.current.retain();

            return .{ .node = self.current };
        }
        pub fn commit(self: *Self, io: std.Io, expected: Snapshot, value: T, persistence: anytype) !Snapshot {
            const number = std.math.add(u64, expected.revision(), 1) catch return error.RevisionExhausted;
            const candidate = try Revision.create(self.allocator, value, number);

            errdefer candidate.release();

            try self.mutex.lock(io);

            defer self.mutex.unlock(io);

            if (self.current != expected.node) return error.Conflict;
            try persistence.save(io, expected.revision(), number, candidate.value);

            const previous = self.current;

            self.current = candidate;

            candidate.retain();
            previous.release();

            return .{ .node = candidate };
        }
    };
}
