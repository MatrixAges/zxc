const std = @import("std");
const rx = @import("rx");
const fixtures = @import("fixtures");

fn run(sources: []const rx.ModuleSource) void {
    var result = rx.validateModules(std.heap.page_allocator, sources) catch |err| {
        std.debug.print("RX_ERROR={s}\n", .{@errorName(err)});
        std.process.exit(2);
    };

    defer result.deinit();

    if (result.value != .data) std.process.exit(3);

    std.debug.print("RX_VALID={d}\n", .{result.value.data.len});
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const size = try std.fmt.parseInt(usize, args[1], 10);
    const edges = try allocator.alloc(usize, size - 1);

    for (edges, 0..) |*edge, index| edge.* = index * size + index + 1;

    const sources = try fixtures.sources(allocator, size, .call, edges);
    const stack_size = if (args.len > 2) try std.fmt.parseInt(usize, args[2], 10) else 256 * 1024;
    const thread = try std.Thread.spawn(.{ .stack_size = stack_size }, run, .{sources});

    thread.join();
}
