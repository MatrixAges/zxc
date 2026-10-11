const std = @import("std");
const frontend = @import("frontend");
const Export = @import("../../project.zig").Export;
const State = @import("state.zig");

pub fn collect(state: *State, requested: []const Export) State.Error![]const frontend.project.compiled.Export {
    const result = try state.allocator.alloc(frontend.project.compiled.Export, requested.len);
    var names: std.StringHashMapUnmanaged(void) = .empty;

    defer names.deinit(state.allocator);

    for (requested, result) |exported, *item| {
        if (exported.name.len == 0 or (try names.getOrPut(state.allocator, exported.name)).found_existing) {
            return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "public module names must be nonempty and unique");
        }

        const path = try std.fs.path.resolve(state.allocator, &.{ state.options.root_dir, exported.path });

        defer state.allocator.free(path);

        const selected = for (state.graph.modules, 0..) |module, index| {
            if (std.mem.eql(u8, module.path, path)) break state.finished[index];
        } else null;

        const loaded = selected orelse return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "public module was not compiled in the shared source graph");

        item.* = .{
            .name = try state.allocator.dupe(u8, exported.name),
            .path = try state.allocator.dupe(u8, exported.path),
            .function = loaded.function,
            .types = loaded.exports,
        };
    }

    return result;
}
