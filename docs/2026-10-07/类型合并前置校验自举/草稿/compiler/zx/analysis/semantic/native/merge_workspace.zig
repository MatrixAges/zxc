const std = @import("std");
const ir = @import("zx").ir;
pub const Workspace = @import("zxc_abi").native.@"zig:merge_workspace".Workspace;
pub const View = @import("merge_workspace_view");

fn view(workspace: Workspace) *View {
    return @ptrCast(@alignCast(@constCast(workspace)));
}

pub fn allocateOrigins(workspace: Workspace, count: u64) std.mem.Allocator.Error!void {
    const data = view(workspace);

    data.result.origins = try data.temporary.alloc(?usize, @intCast(count));

    @memset(data.result.origins, null);
}

pub fn allocateMapping(workspace: Workspace, count: u64) std.mem.Allocator.Error!void {
    const data = view(workspace);

    data.result.mapping = try data.allocator.alloc(ir.TypeId, @intCast(count));
}

pub fn hasOrigin(workspace: Workspace, index: u64) bool {
    return view(workspace).result.origins[@intCast(index)] != null;
}

pub fn setOrigin(workspace: Workspace, index: u64, origin: u64) void {
    view(workspace).result.origins[@intCast(index)] = @intCast(origin);
}

pub fn setIdentity(workspace: Workspace, index: u64) void {
    view(workspace).result.mapping[@intCast(index)] = @fromBackingInt(@intCast(index));
}
