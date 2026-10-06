const std = @import("std");
const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;

pub fn allocateChildren(workspace: Workspace, count: u64) error{OutOfMemory}!void {
    try view(workspace).allocateChildren(@intCast(count));
}

pub fn allocateFields(workspace: Workspace, count: u64) error{OutOfMemory}!void {
    try view(workspace).allocateFields(@intCast(count));
}

pub fn allocateMembers(workspace: Workspace, count: u64) error{OutOfMemory}!void {
    try view(workspace).allocateMembers(@intCast(count));
}

pub fn saveChild(workspace: Workspace) void {
    const data = view(workspace);
    const frame = data.current();

    frame.children[frame.index] = data.state.result;
}

pub fn saveField(workspace: Workspace) error{OutOfMemory}!void {
    const data = view(workspace);
    const frame = data.current();

    frame.columns.names[frame.index] = try data.allocator.dupe(u8, frame.name.text);
    frame.columns.types.?[frame.index] = @backingInt(data.state.result);
}

pub fn saveMember(workspace: Workspace, index: u64) error{OutOfMemory}!void {
    const data = view(workspace);
    const frame = data.current();

    frame.columns.names[@intCast(index)] = try data.allocator.dupe(u8, data.reader.memberAt(frame.value, @intCast(index)).text);
}

pub fn references(workspace: Workspace) []const u32 {
    return @ptrCast(view(workspace).current().children);
}

pub fn fieldNames(workspace: Workspace) []const []const u8 {
    return view(workspace).current().columns.names;
}

pub fn fieldTypes(workspace: Workspace) []const u32 {
    return view(workspace).current().columns.types.?;
}

pub fn sortFields(workspace: Workspace) error{OutOfMemory}!void {
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    @import("generated_name_sort").execute(&arena, @ptrCast(&view(workspace).current().columns)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
