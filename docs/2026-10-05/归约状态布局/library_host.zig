const std = @import("std");
const application = @import("application");

pub fn main(init: std.process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(init.gpa);

    defer arena.deinit();

    const result = try application.execute(&arena, &.{ 2, 3, 5 });
    var buffer: [1024]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(result, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
