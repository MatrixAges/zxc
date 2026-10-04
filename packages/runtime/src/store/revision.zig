const std = @import("std");
const clone = @import("clone.zig").clone;

pub fn Revision(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        arena: std.heap.ArenaAllocator,
        references: std.atomic.Value(usize),
        number: u64,
        value: T,
        const Self = @This();

        pub fn create(allocator: std.mem.Allocator, value: T, number: u64) std.mem.Allocator.Error!*Self {
            const revision = try allocator.create(Self);

            errdefer allocator.destroy(revision);

            var arena = std.heap.ArenaAllocator.init(allocator);

            errdefer arena.deinit();

            const copied = try clone(arena.allocator(), value);

            revision.* = .{ .allocator = allocator, .arena = arena, .references = .init(1), .number = number, .value = copied };

            return revision;
        }
        pub fn retain(self: *Self) void {
            const previous = self.references.fetchAdd(1, .monotonic);

            std.debug.assert(previous > 0 and previous < std.math.maxInt(usize));
        }

        pub fn release(self: *Self) void {
            const previous = self.references.fetchSub(1, .acq_rel);

            std.debug.assert(previous > 0);

            if (previous != 1) return;

            const allocator = self.allocator;

            self.arena.deinit();
            allocator.destroy(self);
        }
    };
}
