const std = @import("std");
const runtime = @import("runtime");
const application = @import("application");
const initial = @import("initial");
const State = initial.Output;

const Persistence = struct {
    commits: usize = 0,
    pub fn save(self: *Persistence, _: std.Io, previous: u64, next: u64, _: State) !void {
        std.debug.print("commit={d}->{d}\n", .{ previous, next });

        self.commits += 1;
    }
};

const Context = struct {
    request: *runtime.Request(State),
    persistence: *Persistence,
    store_0: *const State,
    pub fn commit(self: Context, changes: application.zx_pending) !void {
        if (changes.store_0) |value| try self.request.commit(value, self.persistence);
    }
};

pub fn main(init: std.process.Init) !void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(debug_allocator.deinit() == .ok);

    const allocator = debug_allocator.allocator();
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) return error.ExpectedIncrement;
    try run(allocator, init.io, try std.fmt.parseInt(u64, args[1], 10));

    std.debug.print("request released\n", .{});
}

fn run(allocator: std.mem.Allocator, io: std.Io, increment: u64) !void {
    var owner = initial_state: {
        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        break :initial_state try runtime.Store(State).init(allocator, try initial.execute(&arena, {}), 0);
    };

    defer owner.deinit();

    var request = try runtime.Request(State).init(allocator, io, &owner);

    defer request.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var persistence: Persistence = .{};
    const context = Context{ .request = &request, .persistence = &persistence, .store_0 = &request.value };
    const result = try application.execute(&arena, increment, context);
    const serialized = try std.json.Stringify.valueAlloc(arena.allocator(), result, .{});

    std.debug.print("result={s}\nrevision={d} commits={d} retained={d}\n", .{ serialized, request.current.revision(), persistence.commits, request.previous.items.len });
}
