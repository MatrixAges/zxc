const std = @import("std");
const choose = @import("choose");
const read = @import("read");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 2) return error.ExpectedJsonInput;

    const input = try std.json.parseFromSliceLeaky(choose.Input, allocator, args[1], .{});

    const result = .{
        .selected = try choose.execute(init.arena, input),
        .original = try read.execute(init.arena, input),
    };

    std.debug.print("{s}\n", .{try std.json.Stringify.valueAlloc(allocator, result, .{})});
}
