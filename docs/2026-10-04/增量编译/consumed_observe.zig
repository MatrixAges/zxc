const std = @import("std");
const Inputs = @import("observed").Inputs;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) return error.ExpectedSourcePath;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    var inputs = try Inputs.init(init.io, heap.allocator());

    defer inputs.deinit();

    try inputs.add(init.io, args[1]);

    var input_buffer: [128]u8 = undefined;
    var input = std.Io.File.stdin().reader(init.io, &input_buffer);
    var output_buffer: [256]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &output_buffer);

    while (true) {
        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], heap.allocator(), .limited(16 * 1024 * 1024));

        defer heap.allocator().free(source);

        try inputs.record(init.io, args[1], source);

        var observed = try inputs.observed(heap.allocator());

        defer observed.deinit();

        var current = try inputs.current(init.io, heap.allocator());

        defer current.deinit();

        try output.interface.print("consistent={any} same={any}\n", .{ observed.consistent, observed.same(current) });
        try output.interface.flush();

        const command = try input.interface.takeDelimiter('\n') orelse break;

        if (std.mem.eql(u8, command, "quit")) break;
        if (!std.mem.eql(u8, command, "read")) return error.UnknownCommand;
    }
}
