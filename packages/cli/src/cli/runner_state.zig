const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const expected: usize = if (application.Input == void) 3 else 4;

    if (args.len != expected or !std.mem.eql(u8, args[1], "--state-dir")) return error.ExpectedStateDirectoryAndJsonInput;

    const directory = try std.Io.Dir.cwd().openDir(init.io, args[2], .{});

    defer directory.close(init.io);

    const input: application.Input = if (application.Input == void) {} else try std.json.parseFromSliceLeaky(application.Input, allocator, args[3], .{ .allocate = .alloc_always });
    var state = State{ .arena = init.arena, .io = init.io, .directory = directory };

    try state.initialize();

    const output = try application.execute(init.arena, input, &state);
    var buffer: [4096]u8 = undefined;
    var file = std.Io.File.Writer.init(.stdout(), init.io, &buffer);

    if (application.Output == void) {
        try file.interface.writeAll("null");
    } else {
        try std.json.Stringify.value(output, .{}, &file.interface);
    }

    try file.interface.writeByte('\n');
    try file.interface.flush();
}
