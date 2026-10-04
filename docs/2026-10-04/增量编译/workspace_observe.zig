const std = @import("std");
const api = @import("observed");
const Inputs = api.Inputs;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) return error.ExpectedInputPaths;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    var baseline = block: {
        var inputs = try Inputs.init(init.io, heap.allocator());

        defer inputs.deinit();

        var members = try api.workspace.loadWithInputs(init.io, heap.allocator(), args[1], &inputs);

        defer members.deinit();

        if (members.diagnostic) |message| std.debug.print("{s}\n", .{message});

        break :block try inputs.observed(heap.allocator());
    };

    defer baseline.deinit();

    const Snapshot = @TypeOf(baseline);
    const paths = try init.arena.allocator().alloc([]const u8, baseline.entries.len);

    for (baseline.entries, paths) |entry, *path| path.* = entry.path;

    var input_buffer: [128]u8 = undefined;
    var input = std.Io.File.stdin().reader(init.io, &input_buffer);
    var output_buffer: [256]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &output_buffer);

    try output.interface.print("ready entries={d}\n", .{baseline.entries.len});
    try output.interface.flush();

    while (true) {
        const command = try input.interface.takeDelimiter('\n') orelse break;

        if (std.mem.eql(u8, command, "quit")) break;
        if (!std.mem.eql(u8, command, "capture")) return error.UnknownCommand;

        var current = try Snapshot.capture(init.io, heap.allocator(), paths);

        defer current.deinit();

        try output.interface.print("same={any} entries={d}\n", .{ baseline.same(current), current.entries.len });
        try output.interface.flush();
    }
}
