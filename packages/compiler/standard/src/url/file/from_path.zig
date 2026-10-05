const std = @import("std");
const resolve = @import("../../path/resolve.zig");
const syntax = @import("../../path/syntax.zig");
const host = @import("../host/root.zig");
const percent = @import("../percent.zig");
const parser = @import("../parser/root.zig");
const serialize = @import("../serialize.zig");

pub fn fromPath(allocator: std.mem.Allocator, input: []const u8, windows: bool, cwd: []const u8) ![]const u8 {
    if (!std.unicode.utf8ValidateSlice(input)) return error.InvalidFilePath;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const unc = windows and std.mem.startsWith(u8, input, "\\\\");
    var resolved = if (unc) input else try resolve.resolve(temporary, windows, cwd, &.{input});
    var name: []const u8 = "";

    if (windows and std.mem.startsWith(u8, resolved, "\\\\")) {
        const start: usize = if (std.mem.startsWith(u8, resolved, "\\\\?\\UNC\\")) 8 else 2;
        const boundary = std.mem.indexOfScalarPos(u8, resolved, start, '\\') orelse return error.InvalidFilePath;

        if (boundary == start) return error.InvalidFilePath;

        name = try host.parse(temporary, resolved[start..boundary], false);
        resolved = resolved[boundary..];
    } else if (input.len != 0 and syntax.separator(windows, input[input.len - 1]) and !syntax.separator(windows, resolved[resolved.len - 1])) {
        resolved = try std.fmt.allocPrint(temporary, "{s}/", .{resolved});
    }

    var literal: std.ArrayList(u8) = .empty;
    const hex = "0123456789ABCDEF";

    for (resolved) |byte| {
        if (std.mem.indexOfScalar(u8, "%[]|~", byte) != null) {
            try literal.appendSlice(temporary, &.{ '%', hex[byte >> 4], hex[byte & 15] });
        } else if (byte == '\\') {
            try literal.appendSlice(temporary, if (windows) "/" else "%5C");
        } else try literal.append(temporary, byte);
    }

    const encoded = try percent.encode(temporary, literal.items, .path);
    const prefix = if (windows and name.len == 0) "file:///" else "file://";
    const text = try std.fmt.allocPrint(temporary, "{s}{s}{s}", .{ prefix, name, encoded });
    const parsed = try parser.parse(temporary, text, null);

    return serialize.serialize(allocator, parsed, false);
}
