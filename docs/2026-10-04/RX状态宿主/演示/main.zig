const std = @import("std");
const Store = @import("runtime").Store;

const State = *const struct {
    title: []const u8,
    items: []const ?*const struct { count: u64 },
    flags: [2]bool,
    pair: struct { u64, enum { ready, done } },
    optional: ?u64,
    ratio: f64,
};

const Persistence = struct {
    reject: bool,
    saves: usize = 0,
    pub fn save(self: *Persistence, _: std.Io, previous: u64, next: u64, value: State) !void {
        if (self.reject) return error.SaveRefused;

        self.saves += 1;

        std.debug.print("save revision={d}->{d} title={s}\n", .{ previous, next, value.title });
    }
};

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 3) return error.ExpectedInitialAndReplacementJson;

    var heap: std.heap.DebugAllocator(.{}) = .init;
    const allocator = heap.allocator();

    try execute(init.io, allocator, args[1], args[2]);

    std.debug.print("allocator={t}\n", .{heap.deinit()});
}

fn execute(io: std.Io, allocator: std.mem.Allocator, first: []const u8, second: []const u8) !void {
    var input_arena = std.heap.ArenaAllocator.init(allocator);
    const initial = try std.json.parseFromSliceLeaky(State, input_arena.allocator(), first, .{ .allocate = .alloc_always });
    var owner = try Store(State).init(allocator, initial, 0);

    input_arena.deinit();

    var original = try owner.snapshot(io);
    var competing = original.retain();
    var request_arena = std.heap.ArenaAllocator.init(allocator);
    const replacement = try std.json.parseFromSliceLeaky(State, request_arena.allocator(), second, .{ .allocate = .alloc_always });
    var persistence = Persistence{ .reject = false };
    var current = try owner.commit(io, original, replacement, &persistence);

    request_arena.deinit();
    std.debug.print("old={s} current={s} revision={d}\n", .{ original.value().title, current.value().title, current.revision() });

    if (owner.commit(io, competing, current.value(), &persistence)) |snapshot| {
        var unexpected = snapshot;

        unexpected.deinit();
    } else |err| std.debug.print("competing={s} saves={d}\n", .{ @errorName(err), persistence.saves });

    persistence.reject = true;

    if (owner.commit(io, current, original.value(), &persistence)) |snapshot| {
        var unexpected = snapshot;

        unexpected.deinit();
    } else |err| std.debug.print("persistence={s} saves={d}\n", .{ @errorName(err), persistence.saves });

    var unchanged = try owner.snapshot(io);

    std.debug.print("after failure={s} revision={d}\n", .{ unchanged.value().title, unchanged.revision() });
    owner.deinit();
    std.debug.print("after owner release: old={s} nested={d} current={s} nested={d}\n", .{ original.value().title, original.value().items[0].?.count, current.value().title, current.value().items[0].?.count });

    const encoded = try std.json.Stringify.valueAlloc(allocator, current.value(), .{});

    defer allocator.free(encoded);
    std.debug.print("retained={s}\n", .{encoded});
    unchanged.deinit();
    current.deinit();
    competing.deinit();
    original.deinit();
}
