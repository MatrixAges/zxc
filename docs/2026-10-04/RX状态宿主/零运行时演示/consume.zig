const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedDirectoryAndJsonInput;

    const directory = try std.Io.Dir.cwd().openDir(init.io, args[1], .{});

    defer directory.close(init.io);

    const input = try std.json.parseFromSliceLeaky(application.Input, allocator, args[2], .{});
    var state = State{ .arena = init.arena, .io = init.io, .directory = directory };

    try state.initialize();

    const result = try application.execute(init.arena, input, &state);

    std.debug.print("result={s}\n", .{try std.json.Stringify.valueAlloc(allocator, result, .{})});
}
