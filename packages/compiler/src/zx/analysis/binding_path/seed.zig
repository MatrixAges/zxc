const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;

pub fn valid(name: []const u8) bool {
    var parts = std.mem.splitScalar(u8, name, '.');

    while (parts.next()) |part| {
        if (part.len == 0 or zx.syntax.isKeyword(part) or (!std.ascii.isAlphabetic(part[0]) and part[0] != '_' and part[0] != '$')) return false;

        for (part[1..]) |byte| {
            if (!std.ascii.isAlphanumeric(byte) and byte != '_') return false;
        }
    }

    return true;
}

pub fn overlaps(left: []const u8, right: []const u8) bool {
    return contains(left, right) or contains(right, left);
}

fn contains(parent: []const u8, child: []const u8) bool {
    return std.mem.eql(u8, parent, child) or (child.len > parent.len and std.mem.startsWith(u8, child, parent) and child[parent.len] == '.');
}

pub fn matches(expression: anytype, name: []const u8) bool {
    const value = syntax.value(expression);

    if (value == .identifier) return std.mem.eql(u8, value.identifier.text, name);
    if (value != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, name, '.') orelse return false;

    return std.mem.eql(u8, value.field.name.text, name[separator + 1 ..]) and matches(value.field.target, name[0..separator]);
}

pub fn rooted(expression: anytype, name: []const u8) bool {
    if (matches(expression, name)) return true;

    const value = syntax.value(expression);

    return value == .field and rooted(value.field.target, name);
}

pub fn pathLength(expression: anytype) ?usize {
    const value = syntax.value(expression);

    return switch (value) {
        .identifier => |name| name.text.len,
        .field => |field| (pathLength(field.target) orelse return null) + 1 + field.name.text.len,
        else => null,
    };
}
