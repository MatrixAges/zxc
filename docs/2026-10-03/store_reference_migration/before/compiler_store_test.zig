const std = @import("std");
const program = @import("store");

const Host = struct {
    store_0: *const program.State,
    current: *program.State,
    commits: usize = 0,
    conflict: bool = false,
    pub fn commit(self: *Host, pending: program.zx_pending) !void {
        if (self.conflict) return error.Conflict;
        if (pending.store_0) |next| self.current.* = next;

        self.commits += 1;
    }
};

test "store: injected getter sees staged setter and commits once" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = program.State{ .count = 3, .items = &.{ 8, 9 } };
    var host = Host{ .store_0 = &state, .current = &state };
    const original_pointer = state.items.ptr;
    const result = try program.execute(&arena, .{ .increment = 2, .index = 0 }, &host);

    try std.testing.expectEqual(@as(u64, 13), result);
    try std.testing.expectEqual(@as(u64, 5), state.count);
    try std.testing.expectEqual(@as(usize, 1), host.commits);
    try std.testing.expectEqual(original_pointer, state.items.ptr);
}

test "store: failure after staging leaves the snapshot unchanged" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = program.State{ .count = 3, .items = &.{8} };
    var host = Host{ .store_0 = &state, .current = &state };

    try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, .{ .increment = 2, .index = 1 }, &host));
    try std.testing.expectEqual(@as(u64, 3), state.count);
    try std.testing.expectEqual(@as(usize, 0), host.commits);
}

test "store: host commit conflicts propagate without returning success" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = program.State{ .count = 3, .items = &.{8} };
    var host = Host{ .store_0 = &state, .current = &state, .conflict = true };

    try std.testing.expectError(error.Conflict, program.execute(&arena, .{ .increment = 2, .index = 0 }, &host));
    try std.testing.expectEqual(@as(u64, 3), state.count);
    try std.testing.expectEqual(@as(usize, 0), host.commits);
}

test "store: scalar update needs no allocation or list cloning" {
    var empty: [0]u8 = .{};
    var backing = std.heap.FixedBufferAllocator.init(&empty);
    var arena = std.heap.ArenaAllocator.init(backing.allocator());

    defer arena.deinit();

    var state = program.State{ .count = 3, .items = &.{8} };
    var host = Host{ .store_0 = &state, .current = &state };
    const pointer = state.items.ptr;
    _ = try program.execute(&arena, .{ .increment = 2, .index = 0 }, &host);

    try std.testing.expectEqual(@as(u64, 5), state.count);
    try std.testing.expectEqual(pointer, state.items.ptr);
}
