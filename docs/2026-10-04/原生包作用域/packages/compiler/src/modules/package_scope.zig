const std = @import("std");
const builtin = @import("builtin");
pub const Package = struct { specifier: []const u8, entry: []const u8 };
const interface = @import("interface.zig");

pub const Scope = struct { root: []const u8, packages: []const Package, native_interfaces: []const interface.Native = &.{}, externals: []const interface.External = &.{} };

pub fn nativeInterfaces(scopes: []const Scope, path: []const u8, fallback: []const interface.Native) []const interface.Native {
    if (scopes.len == 0) return fallback;

    const index = owner(scopes, path) orelse return &.{};

    return scopes[index].native_interfaces;
}

pub fn externals(scopes: []const Scope, path: []const u8, fallback: []const interface.External) []const interface.External {
    if (scopes.len == 0) return fallback;

    const index = owner(scopes, path) orelse return &.{};

    return scopes[index].externals;
}

pub fn owner(scopes: []const Scope, path: []const u8) ?usize {
    var selected: ?usize = null;

    for (scopes, 0..) |scope, index| {
        if (!contains(scope.root, path)) continue;
        if (selected == null or scope.root.len > scopes[selected.?].root.len) selected = index;
    }

    return selected;
}

fn contains(root: []const u8, path: []const u8) bool {
    if (root.len > path.len) return false;

    const prefix = path[0..root.len];
    const same = if (builtin.os.tag == .windows) std.ascii.eqlIgnoreCase(root, prefix) else std.mem.eql(u8, root, prefix);

    if (!same) return false;
    if (root.len == path.len or (root.len > 0 and separator(root[root.len - 1]))) return true;

    return separator(path[root.len]);
}

fn separator(byte: u8) bool {
    return byte == '/' or (builtin.os.tag == .windows and byte == '\\');
}
