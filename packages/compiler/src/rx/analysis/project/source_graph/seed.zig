const std = @import("std");
const model = @import("model.zig");
const State = enum { unseen, visiting, done };
const Frame = struct { index: usize, dependency: usize = 0 };

/// Dependencies before their dependents. The first root's modules come first and close with it; the modules the other
/// roots add follow. Each part comes in order of depth, so the modules of one depth form runs that depend on no module
/// of their run.
pub fn build(allocator: std.mem.Allocator, scratch: std.mem.Allocator, modules: []const model.Module, roots: []const usize) std.mem.Allocator.Error!model.Scheduled {
    const states = try scratch.alloc(State, modules.len);

    defer scratch.free(states);

    @memset(states, .unseen);

    var pending: std.ArrayList(Frame) = .empty;
    var result: std.ArrayList(usize) = .empty;
    var closed: ?usize = null;

    defer pending.deinit(scratch);
    errdefer result.deinit(allocator);

    for (roots) |entry| {
        if (states[entry] == .done) continue;
        if (result.items.len != 0 and closed == null) closed = result.items.len;
        try pending.append(scratch, .{ .index = entry });

        states[entry] = .visiting;

        while (pending.items.len != 0) {
            const frame = &pending.items[pending.items.len - 1];
            const module = modules[frame.index];

            if (frame.dependency == module.dependencies.len) {
                try result.append(allocator, frame.index);

                states[frame.index] = .done;
                _ = pending.pop();

                continue;
            }

            const edge = module.dependencies[frame.dependency];

            frame.dependency += 1;

            if (edge.target != .source) continue;

            const index = edge.target.source;

            switch (states[index]) {
                .done => {},
                .visiting => {
                    result.deinit(allocator);

                    return model.cycle(module, edge);
                },
                .unseen => {
                    states[index] = .visiting;

                    try pending.append(scratch, .{ .index = index });
                },
            }
        }
    }

    const order = try result.toOwnedSlice(allocator);

    errdefer allocator.free(order);

    const depths = try depth(scratch, modules, order);

    defer scratch.free(depths);

    const first = closed orelse order.len;

    std.sort.block(usize, order[0..first], depths, shallower);
    std.sort.block(usize, order[first..], depths, shallower);

    var ends: std.ArrayList(usize) = .empty;

    defer ends.deinit(scratch);

    if (order.len != 0) {
        for (order[1..], order[0 .. order.len - 1], 1..) |current, previous, position| {
            if (depths[current] != depths[previous]) try ends.append(scratch, position);
        }

        try ends.append(scratch, order.len);
    }

    return .{ .schedule = .{ .order = order, .batch_ends = try allocator.dupe(usize, ends.items) } };
}

/// Each module's depth: one more than its deepest source dependency, from a dependency order.
fn depth(allocator: std.mem.Allocator, modules: []const model.Module, order: []const usize) std.mem.Allocator.Error![]u32 {
    const result = try allocator.alloc(u32, modules.len);

    @memset(result, 0);

    for (order) |index| {
        for (modules[index].dependencies) |edge| {
            if (edge.target == .source) result[index] = @max(result[index], result[edge.target.source] + 1);
        }
    }

    return result;
}

fn shallower(depths: []const u32, left: usize, right: usize) bool {
    return depths[left] < depths[right];
}
