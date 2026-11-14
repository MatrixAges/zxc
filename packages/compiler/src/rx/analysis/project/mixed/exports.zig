const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Export = @import("../../project.zig").Export;
const State = @import("state.zig");

pub fn collect(state: *State, requested: []const Export, roots: []const usize) State.Error![]const frontend.project.compiled.Export {
    if (requested.len == 0) return &.{};

    const location: rx.ast.Location = .{ .offset = 0, .line = 1, .column = 1 };

    if (!state.scratch.reset(.retain_capacity)) return error.OutOfMemory;

    const invalid = try frontend.project.public_exports.invalidRootName(state.scratch.allocator(), requested);
    const result = try state.allocator.alloc(frontend.project.compiled.Export, requested.len);

    for (requested, roots, result, 0..) |exported, root, *item, index| {
        if (invalid == index) return state.fail(location, "public module names must be nonempty and unique");

        const loaded = state.finished[root] orelse
            return state.fail(location, "public module was not compiled in the shared source graph");

        item.* = .{
            .name = try state.allocator.dupe(u8, exported.name),
            .path = try state.allocator.dupe(u8, exported.path),
            .function = loaded.function,
            .types = loaded.exports,
            .constants = loaded.constant_exports,
            .members = loaded.members,
        };
    }

    return result;
}
