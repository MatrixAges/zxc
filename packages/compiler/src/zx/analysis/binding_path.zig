const std = @import("std");
const zx = @import("zx");

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
