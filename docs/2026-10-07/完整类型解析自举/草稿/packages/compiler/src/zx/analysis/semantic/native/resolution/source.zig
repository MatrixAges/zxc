const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;

pub fn declarationCount(workspace: Workspace) u64 {
    return view(workspace).reader.declarationCount();
}

pub fn declarationName(workspace: Workspace, index: u64) []const u8 {
    return view(workspace).reader.declarationAt(@intCast(index)).name.text;
}

pub fn declarationStart(workspace: Workspace, index: u64) u64 {
    return view(workspace).reader.declarationAt(@intCast(index)).name.span.start;
}

pub fn declarationEnd(workspace: Workspace, index: u64) u64 {
    return view(workspace).reader.declarationAt(@intCast(index)).name.span.end;
}

pub fn aliasCount(workspace: Workspace) u64 {
    return view(workspace).aliases.len;
}

pub fn aliasName(workspace: Workspace, index: u64) []const u8 {
    return view(workspace).aliases[@intCast(index)].name;
}

pub fn aliasType(workspace: Workspace, index: u64) u64 {
    return @backingInt(view(workspace).aliases[@intCast(index)].type_id);
}

pub fn nativeInterface(workspace: Workspace) bool {
    return view(workspace).native_interface;
}

pub fn nodeKind(workspace: Workspace) u64 {
    const data = view(workspace);

    return @backingInt(data.reader.kind(data.current().value));
}

pub fn nodeName(workspace: Workspace) []const u8 {
    const data = view(workspace);

    return data.reader.name(data.current().value).text;
}

pub fn readName(workspace: Workspace) void {
    const data = view(workspace);
    const frame = data.current();

    frame.name = data.reader.name(frame.value);
}

pub fn selectDeclaration(workspace: Workspace, index: u64) void {
    const data = view(workspace);
    const entry = data.reader.declarationAt(@intCast(index));
    const frame = data.current();

    frame.value = entry.value;
    frame.declaration = entry.name;
}

pub fn fieldCount(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.reader.count(data.current().value, true);
}

pub fn firstField(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.reader.firstPosition(data.current().value, true);
}

pub fn nextField(workspace: Workspace) void {
    const data = view(workspace);
    const frame = data.current();

    frame.position = data.reader.nextPosition(frame.value, frame.position, true);
}

pub fn itemCount(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.reader.count(data.current().value, false);
}

pub fn firstItem(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.reader.firstPosition(data.current().value, false);
}

pub fn nextItem(workspace: Workspace) void {
    const data = view(workspace);
    const frame = data.current();

    frame.position = data.reader.nextPosition(frame.value, frame.position, false);
}

pub fn readFieldName(workspace: Workspace) void {
    const data = view(workspace);
    const frame = data.current();

    frame.name = data.reader.fieldAt(frame.value, frame.position).name;
}

pub fn memberCount(workspace: Workspace) u64 {
    const data = view(workspace);

    return data.reader.memberCount(data.current().value);
}

pub fn memberName(workspace: Workspace, index: u64) []const u8 {
    const data = view(workspace);

    return data.reader.memberAt(data.current().value, @intCast(index)).text;
}

pub fn memberStart(workspace: Workspace, index: u64) u64 {
    const data = view(workspace);

    return data.reader.memberAt(data.current().value, @intCast(index)).span.start;
}

pub fn memberEnd(workspace: Workspace, index: u64) u64 {
    const data = view(workspace);

    return data.reader.memberAt(data.current().value, @intCast(index)).span.end;
}
