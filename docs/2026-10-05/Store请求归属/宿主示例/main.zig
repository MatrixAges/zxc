const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");
const slots = std.meta.fields(application.zx_pending);

const Snapshot = blk: {
    var types: [slots.len]type = undefined;

    for (slots, 0..) |_, index| types[index] = @FieldType(State, std.fmt.comptimePrint("value_{d}", .{index}));

    break :blk std.meta.Tuple(&types);
};

pub fn main(init: std.process.Init) !void {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer if (debug.deinit() == .leak) @panic("request example leaked memory");

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.init(.stdout(), init.io, &buffer);

    try run(debug.allocator(), args[1..], &output.interface);
    try std.json.Stringify.value(.{ .remaining_bytes = debug.total_requested_bytes }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn run(allocator: std.mem.Allocator, inputs: []const []const u8, writer: *std.Io.Writer) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    for (inputs) |source| {
        const previous = snapshot(&state);

        {
            var request = state.request();

            defer request.deinit();

            const input: application.Input = if (application.Input == void) {} else try std.json.parseFromSliceLeaky(application.Input, request.arena.allocator(), source, .{ .allocate = .alloc_always });

            if (request.execute(input)) |result| {
                try std.json.Stringify.value(.{ .phase = "result", .input = source, .output = result }, .{}, writer);
            } else |err| {
                try std.json.Stringify.value(.{ .phase = "result", .input = source, .failure = @errorName(err) }, .{}, writer);
            }

            try writer.writeByte('\n');
        }

        try std.json.Stringify.value(.{ .phase = "closed", .before = previous, .after = snapshot(&state) }, .{}, writer);
        try writer.writeByte('\n');
    }
}

fn snapshot(state: *const State) Snapshot {
    var values: Snapshot = undefined;

    inline for (slots, 0..) |_, index| values[index] = @field(state, std.fmt.comptimePrint("value_{d}", .{index}));

    return values;
}
