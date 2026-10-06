const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;

pub fn frameCount(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.state.frames.items.len;
}

pub fn operation(workspace: Workspace) u64 {
    const data = view(workspace);

    return @backingInt(data.current().operation);
}

pub fn frameIndex(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.current().index;
}

pub fn waiting(workspace: Workspace) bool {
    const data = view(workspace);

    return data.current().waiting;
}

pub fn isList(workspace: Workspace) bool {
    const data = view(workspace);

    return data.current().list;
}

pub fn result(workspace: Workspace) u64 {
    const data = view(workspace);

    return @backingInt(data.state.result);
}

pub fn name(workspace: Workspace) []const u8 {
    const data = view(workspace);

    return data.current().name.text;
}

pub fn nameStart(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.current().name.span.start;
}

pub fn nameEnd(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.current().name.span.end;
}

pub fn declaredStart(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.current().declaration.span.start;
}

pub fn declaredEnd(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.current().declaration.span.end;
}

pub fn setOperation(workspace: Workspace, value: u64) void {
    view(workspace).current().operation = @fromBackingInt(@intCast(value));
}

pub fn setIndex(workspace: Workspace, value: u64) void {
    view(workspace).current().index = @intCast(value);
}

pub fn setPosition(workspace: Workspace, value: u64) void {
    view(workspace).current().position = @intCast(value);
}

pub fn setWaiting(workspace: Workspace, value: bool) void {
    view(workspace).current().waiting = value;
}

pub fn setList(workspace: Workspace, value: bool) void {
    view(workspace).current().list = value;
}

pub fn setResult(workspace: Workspace, value: u64) void {
    view(workspace).state.result = @fromBackingInt(@intCast(value));
}

pub fn pop(workspace: Workspace) void {
    view(workspace).pop();
}

pub fn pushChild(workspace: Workspace) error{OutOfMemory}!void {
    const data = view(workspace);
    const value = data.reader.child(data.current().value);

    try data.push(.{ .operation = .node, .value = value });
}

pub fn pushItem(workspace: Workspace) error{OutOfMemory}!void {
    const data = view(workspace);
    const value = data.reader.childAt(data.current().value, data.current().position);

    try data.push(.{ .operation = .node, .value = value });
}

pub fn pushField(workspace: Workspace) error{OutOfMemory}!void {
    const data = view(workspace);
    const value = data.reader.fieldAt(data.current().value, data.current().position).value;

    try data.push(.{ .operation = .node, .value = value });
}

pub fn pushValue(workspace: Workspace) error{OutOfMemory}!void {
    const data = view(workspace);
    const value = data.current().value;

    try data.push(.{ .operation = .node, .value = value });
}

pub fn pushDeclaration(workspace: Workspace, index: u64) error{OutOfMemory}!void {
    const data = view(workspace);

    try data.push(.{ .operation = .name, .name = data.reader.declarationAt(@intCast(index)).name });
}
