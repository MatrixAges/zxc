const std = @import("std");
const zx = @import("zx");
const Types = @import("../types.zig");
const Workspace = @import("resolution_workspace");
pub const State = Workspace.State;

pub fn workspace(types: *Types, view: anytype, state: *State) Workspace {
    return .{
        .allocator = types.allocator,
        .state = state,
        .reporter = types.reporter,
        .reader = Workspace.Source.from(view),
        .items = &types.items,
        .resolved = &types.resolved,
        .visiting = &types.visiting,
        .aliases = types.aliases,
        .native_interface = types.native_interface,
    };
}

pub fn execute(data: *const Workspace, initialize: bool) zx.Error!void {
    const generated = @import("generated_type_resolution");
    const Input = @typeInfo(generated.Input).pointer.child;
    const input: Input = .{ .workspace = @ptrCast(data), .initialize = initialize };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidSource => return error.InvalidSource,
        else => unreachable,
    };
}
