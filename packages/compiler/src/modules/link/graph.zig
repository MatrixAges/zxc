const std = @import("std");
const Module = @import("../artifact/model.zig").Module;
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingModule, CyclicDependency };

pub fn order(allocator: std.mem.Allocator, modules: []const Module, entry: []const u8) Error![]const usize {
    var paths: std.StringHashMapUnmanaged(usize) = .empty;

    defer paths.deinit(allocator);

    for (modules, 0..) |module, index| {
        if (module.path.len == 0) return error.InvalidModule;

        const found = try paths.getOrPut(allocator, module.path);

        if (found.found_existing) return error.InvalidModule;

        found.value_ptr.* = index;
    }

    const root = paths.get(entry) orelse return error.MissingModule;
    const State = enum { unseen, visiting, done };
    const states = try allocator.alloc(State, modules.len);

    defer allocator.free(states);

    @memset(states, .unseen);

    const Frame = struct { index: usize, dependency: usize = 0 };
    var pending: std.ArrayList(Frame) = .empty;
    var result: std.ArrayList(usize) = .empty;

    defer pending.deinit(allocator);
    errdefer result.deinit(allocator);

    try pending.append(allocator, .{ .index = root });

    states[root] = .visiting;

    while (pending.items.len != 0) {
        const frame = &pending.items[pending.items.len - 1];
        const dependencies = modules[frame.index].dependencies;

        if (frame.dependency == dependencies.len) {
            try result.append(allocator, frame.index);

            states[frame.index] = .done;
            _ = pending.pop();

            continue;
        }

        const dependency = dependencies[frame.dependency];

        frame.dependency += 1;

        if (dependency.target != .source) continue;

        const index = paths.get(dependency.target.source) orelse return error.MissingModule;

        switch (states[index]) {
            .done => {},
            .visiting => return error.CyclicDependency,
            .unseen => {
                states[index] = .visiting;

                try pending.append(allocator, .{ .index = index });
            },
        }
    }

    return result.toOwnedSlice(allocator);
}
