const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");

pub fn main(init: std.process.Init) !void {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer if (debug.deinit() == .leak) @panic("unreleased allocation");

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const release = args.len > 1 and !std.mem.eql(u8, args[1], "retain");
    const direct = args.len > 1 and std.mem.eql(u8, args[1], "direct");
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try run(&debug, release, direct, &output.interface);
    try std.json.Stringify.value(.{ .remaining_bytes = debug.total_requested_bytes }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn run(debug: *std.heap.DebugAllocator(.{ .enable_memory_limit = true }), release: bool, direct: bool, writer: *std.Io.Writer) !void {
    var arena = std.heap.ArenaAllocator.init(debug.allocator());

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    if (direct) try state.commit(.{ .store_0 = state.value_0 });

    var failures: usize = 0;

    for (1..1001) |index| {
        {
            var request = state.request();

            defer request.deinit();

            if (request.execute(1)) |_| {} else |_| failures += 1;
        }

        if (release) state.releaseRetired();
        if (index != 1 and index != 10 and index != 100 and index != 1000) continue;

        var regions: usize = 0;
        var next = state.retained;

        while (next) |region| : (next = region.next) regions += 1;

        try std.json.Stringify.value(.{
            .requests = index,
            .can_release = State.can_release_retired,
            .release_requested = release,
            .direct_commit = direct,
            .regions = regions,
            .allocated_bytes = debug.total_requested_bytes,
            .value = state.value_0.value,
            .history = state.value_0.history,
            .failures = failures,
        }, .{}, writer);

        try writer.writeByte('\n');
    }
}
