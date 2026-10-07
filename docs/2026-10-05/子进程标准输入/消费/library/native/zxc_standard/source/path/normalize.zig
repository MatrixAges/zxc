const std = @import("std");
const syntax = @import("syntax.zig");

pub fn normalize(allocator: std.mem.Allocator, windows: bool, path: []const u8) ![]const u8 {
    if (path.len == 0) return allocator.dupe(u8, ".");

    const root = syntax.root(windows, path);
    var parts: std.ArrayList([]const u8) = .empty;

    defer parts.deinit(allocator);

    var begin = root.end;
    var index = begin;

    while (index <= path.len) : (index += 1) {
        if (index != path.len and !syntax.separator(windows, path[index])) continue;

        const part = path[begin..index];

        begin = index + 1;

        if (part.len == 0 or std.mem.eql(u8, part, ".")) continue;

        if (std.mem.eql(u8, part, "..")) {
            if (parts.items.len > 0 and !std.mem.eql(u8, parts.items[parts.items.len - 1], "..")) {
                _ = parts.pop();
            } else if (!root.absolute) try parts.append(allocator, part);
        } else try parts.append(allocator, part);
    }

    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();

    const writer = &output.writer;
    const separator: u8 = if (windows) '\\' else '/';

    if (root.server.len != 0) {
        try writer.print("\\\\{s}\\{s}\\", .{ root.server, root.share });
    } else {
        try writer.writeAll(path[0..root.device_end]);
        if (root.absolute) try writer.writeByte(separator);
    }

    if (parts.items.len == 0 and !root.absolute) try writer.writeByte('.');

    for (parts.items, 0..) |part, part_index| {
        if (part_index != 0) try writer.writeByte(separator);
        try writer.writeAll(part);
    }

    if (syntax.separator(windows, path[path.len - 1]) and !syntax.separator(windows, output.written()[output.written().len - 1])) try writer.writeByte(separator);

    return output.toOwnedSlice();
}
