const std = @import("std");
const builtin = @import("builtin");
pub const Package = struct { specifier: []const u8, entry: []const u8 };
pub const Scope = struct { root: []const u8, packages: []const Package };

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
