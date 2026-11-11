const std = @import("std");
const model = @import("model.zig");

pub fn build(allocator: std.mem.Allocator, backing: std.mem.Allocator, modules: []const model.Module, roots: []const usize) std.mem.Allocator.Error!model.Scheduled {
    if (!@import("rx_options").generated_graph) return @import("seed.zig").build(allocator, backing, modules, roots);

    const generated = @import("generated_source_schedule");
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const offsets = try temporary.alloc(u64, modules.len + 1);
    var count: usize = 0;

    for (modules, offsets[0..modules.len]) |module, *offset| {
        offset.* = count;

        for (module.dependencies) |edge| {
            count += @intFromBool(edge.target == .source);
        }
    }

    offsets[modules.len] = count;

    const targets = try temporary.alloc(u64, count);
    var position: usize = 0;

    for (modules) |module| {
        for (module.dependencies) |edge| {
            if (edge.target != .source) continue;

            targets[position] = edge.target.source;
            position += 1;
        }
    }

    const root_indices: []const u64 = if (@bitSizeOf(usize) == 64 and @alignOf(usize) >= @alignOf(u64)) @ptrCast(roots) else converted: {
        const indices = try temporary.alloc(u64, roots.len);

        for (indices, roots) |*output, root| output.* = root;

        break :converted indices;
    };

    const plan = generated.executeValue(temporary, &.{ .offsets = offsets, .targets = targets, .roots = root_indices }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    if (plan.cycle) |cycle| {
        const module = modules[@intCast(cycle.owner)];
        var source_index = offsets[@intCast(cycle.owner)];

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
