const std = @import("std");
const Origins = @import("nominal_data");
const References = @import("reference_view");
const View = @import("extract_workspace_view");
const abi = @import("zxc_abi");
pub const Workspace = abi.native.@"zig:extract_workspace".Workspace;

fn view(workspace: Workspace) *View {
    return @ptrCast(@alignCast(@constCast(workspace)));
}

pub fn hasMapping(workspace: Workspace, index: u64) bool {
    return view(workspace).mapping[@intCast(index)] != null;
}

pub fn getMapping(workspace: Workspace, index: u64) u64 {
    return @backingInt(view(workspace).mapping[@intCast(index)].?);
}

pub fn setMapping(workspace: Workspace, index: u64, value: u64) void {
    view(workspace).mapping[@intCast(index)] = @fromBackingInt(@intCast(value));
}

pub fn prepareReferences(workspace: Workspace, count: u64, dynamic: bool) std.mem.Allocator.Error!void {
    const data = view(workspace);

    data.references.target = if (dynamic) try data.temporary.alloc(u32, @intCast(count)) else &data.scalar;
}

pub fn appendType(workspace: Workspace, index: u64) std.mem.Allocator.Error!u64 {
    const data = view(workspace);
    const borrowed = References.borrow(data.source.at(@intCast(index)), data.references.target);
    const owned = try View.copy(data.allocator, borrowed);
    const id = data.items.count();

    try data.items.append(data.allocator, owned);

    return id;
}

pub fn appendOrigin(workspace: Workspace, index: u64, origin: u64) std.mem.Allocator.Error!void {
    const data = view(workspace);

    try data.nominal.append(data.allocator, .{
        .type_id = @fromBackingInt(@intCast(index)),
        .origin = try Origins.copy(data.allocator, data.origins.at(@intCast(origin)).origin),
        .name = data.items.view().labels[@intCast(index)],
    });
}
