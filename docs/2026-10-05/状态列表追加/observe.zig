const std = @import("std");
const application = @import("生成.zig");

pub fn main(init: std.process.Init) !void {
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try output.interface.writeAll("[");

    for ([_]usize{ 0, 100, 1000, 5000 }, 0..) |count, index| {
        const input = try init.gpa.alloc(u64, count);

        defer init.gpa.free(input);

        @memset(input, 1);

        var arena = std.heap.ArenaAllocator.init(init.gpa);

        defer arena.deinit();

        const result = try application.execute(&arena, input);
        var sum: u64 = 0;

        for (result.values) |item| sum += item;
        if (index != 0) try output.interface.writeAll(",");
        try std.json.Stringify.value(.{ .input_count = count, .count = result.count, .length = result.values.len, .sum = sum, .arena_capacity = arena.queryCapacity() }, .{}, &output.interface);
    }

    try output.interface.writeAll("]\n");
    try output.interface.flush();
}
