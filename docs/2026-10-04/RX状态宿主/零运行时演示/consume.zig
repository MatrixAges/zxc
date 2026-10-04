const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 2) return error.ExpectedJsonInputs;

    var state = State{ .arena = init.arena };

    try state.initialize();

    for (args[1..]) |argument| {
        const input = try std.json.parseFromSliceLeaky(application.Input, allocator, argument, .{ .allocate = .alloc_always });
        const result = try application.execute(init.arena, input, &state);

        std.debug.print("result={s}\n", .{try std.json.Stringify.valueAlloc(allocator, result, .{})});
    }
}
