const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;

pub fn resolved(workspace: Workspace) u64 {
    const data = view(workspace);

    return if (data.resolved.get(data.current().name.text)) |id| @as(u64, @backingInt(id)) + 1 else 0;
}

pub fn visiting(workspace: Workspace) bool {
    const data = view(workspace);

    return data.visiting.contains(data.current().name.text);
}

pub fn visitingCount(workspace: Workspace) u64 {
    return view(workspace).visiting.count();
}

pub fn enter(workspace: Workspace) error{OutOfMemory}!void {
    try view(workspace).enter();
}

pub fn leave(workspace: Workspace) void {
    view(workspace).leave();
}

pub fn cacheResult(workspace: Workspace) error{OutOfMemory}!void {
    const data = view(workspace);

    try data.resolved.put(data.allocator, data.current().name.text, data.state.result);
}
