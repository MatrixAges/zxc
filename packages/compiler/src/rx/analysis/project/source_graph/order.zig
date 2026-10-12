const std = @import("std");
const model = @import("model.zig");
const Diagnostic = @import("../../call/target.zig").Diagnostic;
const State = enum { unseen, visiting, done };
const Frame = struct { index: usize, dependency: usize = 0 };

pub const Value = union(enum) { order: []const usize, diagnostic: Diagnostic };

/// Dependencies before their dependents. The modules each root adds come in order of depth, so the modules of one
/// depth form runs that depend on no module of their run, and the root still closes its own modules.
pub fn build(allocator: std.mem.Allocator, modules: []const model.Module, roots: []const usize) std.mem.Allocator.Error!Value {
    const states = try allocator.alloc(State, modules.len);

    defer allocator.free(states);

    @memset(states, .unseen);

    var pending: std.ArrayList(Frame) = .empty;
    var result: std.ArrayList(usize) = .empty;
    var segments: std.ArrayList(usize) = .empty;

    defer pending.deinit(allocator);
    defer segments.deinit(allocator);
    errdefer result.deinit(allocator);

    for (roots) |entry| {
        if (states[entry] == .done) continue;
        try segments.append(allocator, result.items.len);
        try pending.append(allocator, .{ .index = entry });

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

                    return .{ .diagnostic = .{
                        .path = module.path,
                        .location = edge.location,
                        .code = "module",
                        .message = "source module dependencies must be acyclic across RX and ZX, including unused imports",
                    } };
                },
                .unseen => {
                    states[index] = .visiting;

                    try pending.append(allocator, .{ .index = index });
                },
            }
        }
    }

    const order = try result.toOwnedSlice(allocator);

    errdefer allocator.free(order);

    const depths = try depth(allocator, modules, order);

    defer allocator.free(depths);

    try segments.append(allocator, order.len);
    for (segments.items[0 .. segments.items.len - 1], segments.items[1..]) |start, end| std.sort.block(usize, order[start..end], depths, shallower);

    return .{ .order = order };
}

/// Each module's depth: one more than its deepest source dependency, from a dependency order.
pub fn depth(allocator: std.mem.Allocator, modules: []const model.Module, order: []const usize) std.mem.Allocator.Error![]u32 {
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
