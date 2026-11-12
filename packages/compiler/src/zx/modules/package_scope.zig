const std = @import("std");
const builtin = @import("builtin");
const zx = @import("zx");
pub const Package = struct { specifier: []const u8, entry: []const u8 = "", compiled: ?@import("compiled.zig").Target = null };
const interface = @import("interface.zig");
pub const lookup_batch_size = 32;
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
    if (comptime @import("parser_options").generated_parser) return generatedOwner(scopes, path);

    var selected: ?usize = null;

    for (scopes, 0..) |scope, index| {
        if (!contains(scope.root, path)) continue;
        if (selected == null or scope.root.len > scopes[selected.?].root.len) selected = index;
    }

    return selected;
}

fn generatedOwner(scopes: []const Scope, path: []const u8) ?usize {
    if (scopes.len == 0) return null;

    const generated = @import("generated_project_package_owner");
    const Input = std.meta.Child(generated.Input);
    const Owner = std.meta.Child(@FieldType(Input, "selected"));
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var roots: [lookup_batch_size][]const u8 = undefined;
    var selected: Owner = .{ .index = null, .width = 0 };
    var offset: usize = 0;

    while (offset < scopes.len) {
        const batch = scopes[offset..][0..@min(roots.len, scopes.len - offset)];
        for (batch, roots[0..batch.len]) |*scope, *root| root.* = scope.root;

        const input: Input = .{
            .roots = roots[0..batch.len],
            .path = path,
            .windows = builtin.os.tag == .windows,
            .offset = offset,
            .selected = &selected,
        };

        const result = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;

        selected = .{ .index = result.index, .width = result.width };
        offset += batch.len;
    }

    return if (selected.index) |id| @intCast(id) else null;
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
