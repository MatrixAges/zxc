const std = @import("std");
const model = @import("model.zig");
const Diagnostic = @import("../../call/target.zig").Diagnostic;
const State = enum { unseen, visiting, done };
const Frame = struct { index: usize, dependency: usize = 0 };

pub const Value = union(enum) { order: []const usize, diagnostic: Diagnostic };

pub fn build(allocator: std.mem.Allocator, modules: []const model.Module, roots: []const usize) std.mem.Allocator.Error!Value {
    const states = try allocator.alloc(State, modules.len);

    defer allocator.free(states);

    @memset(states, .unseen);

    var pending: std.ArrayList(Frame) = .empty;
    var result: std.ArrayList(usize) = .empty;

    defer pending.deinit(allocator);
    errdefer result.deinit(allocator);

    for (roots) |entry| {
        if (states[entry] == .done) continue;
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

    return .{ .order = try result.toOwnedSlice(allocator) };
}
