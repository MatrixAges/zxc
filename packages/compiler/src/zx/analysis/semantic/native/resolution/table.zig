const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;

pub fn kinds(workspace: Workspace) []const u8 {
    return view(workspace).items.kinds.items;
}

pub fn first(workspace: Workspace) []const u32 {
    return view(workspace).items.first.items;
}

pub fn second(workspace: Workspace) []const u32 {
    return view(workspace).items.second.items;
}

pub fn labels(workspace: Workspace) []const []const u8 {
    return view(workspace).items.labels.items;
}

pub fn children(workspace: Workspace) []const u32 {
    return view(workspace).items.children.items;
}

pub fn allFieldTypes(workspace: Workspace) []const u32 {
    return view(workspace).items.field_types.items;
}

pub fn allFieldNames(workspace: Workspace) []const []const u8 {
    return view(workspace).items.field_names.items;
}

pub fn names(workspace: Workspace) []const []const u8 {
    return view(workspace).items.names.items;
}

pub fn typeCount(workspace: Workspace) u64 {
    return view(workspace).items.count();
}

pub fn typeKind(workspace: Workspace, index: u64) u64 {
    return view(workspace).items.kinds.items[@intCast(index)];
}
