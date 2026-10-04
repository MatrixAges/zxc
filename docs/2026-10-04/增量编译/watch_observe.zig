const std = @import("std");
const Inputs = @import("inputs");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) return error.ExpectedInputPaths;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    var baseline = block: {
        var inputs = try Inputs.init(init.io, heap.allocator());

        defer inputs.deinit();

        for (args[1..]) |path| try inputs.add(init.io, path);

        break :block try inputs.observed(heap.allocator());
    };

    defer baseline.deinit();

    const Snapshot = @TypeOf(baseline);
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

        var current = try Snapshot.capture(init.io, heap.allocator(), args[1..]);

        defer current.deinit();

        try output.interface.print("same={any} entries={d}\n", .{ baseline.same(current), current.entries.len });
        try output.interface.flush();
    }
}
