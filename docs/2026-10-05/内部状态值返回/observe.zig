const std = @import("std");
const application = @import("application");

pub fn main(init: std.process.Init) !void {
    var buffer: [1024]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    for ([_]usize{ 64, 4096, 65536 }) |count| {
        const input = try init.gpa.alloc(u8, count);

        defer init.gpa.free(input);
        @memset(input, '1');

        var arena = std.heap.ArenaAllocator.init(init.gpa);

        defer arena.deinit();

        const result = try application.execute(&arena, input);

        try std.json.Stringify.value(.{ .input_bytes = count, .result = result, .arena_capacity = arena.queryCapacity() }, .{}, &output.interface);
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
