const std = @import("std");
const model = @import("model.zig");

pub fn build(allocator: std.mem.Allocator, backing: std.mem.Allocator, modules: []const model.Module, adjacency: model.Adjacency, roots: []const u64) std.mem.Allocator.Error!model.Scheduled {
    if (!@import("rx_options").generated_graph) return @import("seed.zig").build(allocator, backing, modules, roots);

    const generated = @import("generated_source_schedule");
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();

    const plan = generated.executeValue(temporary, &.{ .offsets = adjacency.starts, .ends = adjacency.ends, .targets = adjacency.targets, .roots = roots }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    if (plan.cycle) |cycle| {
        const module = modules[@intCast(cycle.owner)];
        var source_index = adjacency.starts[@intCast(cycle.owner)];

        for (module.dependencies) |edge| {
            if (edge.target != .source) continue;
            if (source_index == cycle.edge) return model.cycle(module, edge);

            source_index += 1;
        }

        unreachable;
    }

    const order = try retain(allocator, plan.order[0..@intCast(plan.count)]);

    errdefer allocator.free(order);

    return .{ .schedule = .{ .order = order, .batch_ends = try retain(allocator, plan.batch_ends) } };
}

fn retain(allocator: std.mem.Allocator, indices: []const u64) std.mem.Allocator.Error![]const usize {
    if (@bitSizeOf(usize) == 64 and @alignOf(u64) >= @alignOf(usize)) return allocator.dupe(usize, @ptrCast(indices));

    const output = try allocator.alloc(usize, indices.len);

    for (output, indices) |*index, value| index.* = @intCast(value);

    return output;
}
