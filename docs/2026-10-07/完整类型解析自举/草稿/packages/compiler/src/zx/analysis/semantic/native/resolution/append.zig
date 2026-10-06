const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;

pub fn appendScalar(workspace: Workspace, index: u64) error{OutOfMemory}!void {
    const data = view(workspace);

    try data.items.append(data.allocator, .{ .scalar = @fromBackingInt(@intCast(index)) });
}

pub fn appendOptional(workspace: Workspace) error{OutOfMemory}!u64 {
    const data = view(workspace);
    const id = data.items.count();

    try data.items.append(data.allocator, .{ .optional = data.state.result });

    return id;
}

pub fn appendList(workspace: Workspace) error{OutOfMemory}!u64 {
    const data = view(workspace);
    const id = data.items.count();

    try data.items.append(data.allocator, .{ .list = data.state.result });

    return id;
}

pub fn appendTuple(workspace: Workspace) error{OutOfMemory}!u64 {
    const data = view(workspace);
    const id = data.items.count();

    try data.items.append(data.allocator, .{ .tuple = data.current().children });

    return id;
}

pub fn appendObject(workspace: Workspace) error{OutOfMemory}!u64 {
    const data = view(workspace);
    const frame = data.current();
    const id = data.items.count();

    try data.items.append(data.allocator, .{ .object = .{ .names = frame.columns.names, .types = frame.columns.types.?, .len = frame.columns.names.len } });

    return id;
}

pub fn appendEnumeration(workspace: Workspace) error{OutOfMemory}!u64 {
    const data = view(workspace);
    const frame = data.current();
    const id = data.items.count();

    try data.items.append(data.allocator, .{ .enumeration = .{ .name = try data.allocator.dupe(u8, frame.declaration.text), .members = frame.columns.names } });

    return id;
}

pub fn appendNative(workspace: Workspace) error{OutOfMemory}!u64 {
    const data = view(workspace);
    const id = data.items.count();

    try data.items.append(data.allocator, .{ .native_reference = try data.allocator.dupe(u8, data.current().declaration.text) });

    return id;
}
