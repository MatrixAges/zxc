const std = @import("std");
const runtime = @import("runtime");
const application = @import("application");
const initial = @import("initial");
const State = initial.Output;

const Context = struct {
    request: *runtime.Request(State),
    persistence: *runtime.SnapshotFile,
    store_0: *const State,
    pub fn commit(self: Context, changes: application.zx_pending) !void {
        if (changes.store_0) |value| {
            try self.request.commit(value, self.persistence);

            std.debug.print("commit revision={d}\n", .{self.request.current.revision()});

            self.persistence.sync(self.request.io) catch |err| {
                std.debug.print("committed revision={d}, directory sync failed: {s}\n", .{ self.request.current.revision(), @errorName(err) });

                return error.StoreDurabilityUnconfirmed;
            };
        }
    }
};

pub fn main(init: std.process.Init) !void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(debug_allocator.deinit() == .ok);

    const allocator = debug_allocator.allocator();
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 4 and args.len != 5) return error.ExpectedDirectoryIncrementAndMetadata;
    if (args.len == 5 and !std.mem.eql(u8, args[4], "--wait")) return error.InvalidOption;

    const text = try std.Io.Dir.cwd().readFileAlloc(init.io, args[3], init.arena.allocator(), .limited(1024 * 1024));
    const metadata = try std.json.parseFromSliceLeaky(runtime.SnapshotFile.Metadata, init.arena.allocator(), text, .{});

    try std.Io.Dir.cwd().createDirPath(init.io, args[1]);

    const directory = try std.Io.Dir.cwd().openDir(init.io, args[1], .{});

    defer directory.close(init.io);

    var persistence = runtime.SnapshotFile.init(allocator, directory, .{ .metadata = metadata });

    try run(allocator, init.io, try std.fmt.parseInt(u64, args[2], 10), &persistence, args.len == 5);

    std.debug.print("request released\n", .{});
}

fn run(allocator: std.mem.Allocator, io: std.Io, increment: u64, persistence: *runtime.SnapshotFile, wait: bool) !void {
    var owner = initial_state: {
        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        const loaded = try persistence.load(State, io, &arena, initial.execute);

        std.debug.print("loaded revision={d} value={d}\n", .{ loaded.revision, loaded.value.value });

        break :initial_state try runtime.Store(State).init(allocator, loaded.value, loaded.revision);
    };

    defer owner.deinit();

    try persistence.sync(io);

    var request = try runtime.Request(State).init(allocator, io, &owner);

    defer request.deinit();

    if (wait) {
        std.debug.print("ready\n", .{});

        var buffer: [1]u8 = undefined;
        var reader = std.Io.File.stdin().reader(io, &buffer);

        _ = try reader.interface.takeByte();
    }

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const context = Context{ .request = &request, .persistence = persistence, .store_0 = &request.value };
    const result = try application.execute(&arena, increment, context);
    const serialized = try std.json.Stringify.valueAlloc(arena.allocator(), result, .{});

    std.debug.print("result={s}\nrevision={d} retained={d}\n", .{ serialized, request.current.revision(), request.previous.items.len });
}
