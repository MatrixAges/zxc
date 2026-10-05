const std = @import("std");

pub const Row = struct { line: usize, part: u8, columns: [5][]const u8 };

lines: std.mem.SplitIterator(u8, .scalar),

line: usize = 0,
part: u8 = 0,
const Rows = @This();

pub fn init(text: []const u8) Rows {
    return .{ .lines = std.mem.splitScalar(u8, text, '\n') };
}

pub fn next(self: *Rows) !?Row {
    while (self.lines.next()) |line| {
        self.line += 1;
        const end = std.mem.indexOfScalar(u8, line, '#') orelse line.len;
        const content = std.mem.trim(u8, line[0..end], " \t\r");

        if (content.len == 0) continue;

        if (std.mem.startsWith(u8, content, "@Part")) {
            self.part = try std.fmt.parseInt(u8, content[5..], 10);

            continue;
        }

        var fields = std.mem.splitScalar(u8, content, ';');
        var row = Row{ .line = self.line, .part = self.part, .columns = undefined };

        for (&row.columns) |*column| {
            column.* = std.mem.trim(u8, fields.next() orelse return error.MissingColumn, " \t");

            if (column.len == 0) return error.EmptyColumn;
        }

        if (fields.next()) |last| {
            if (std.mem.trim(u8, last, " \t").len != 0 or fields.next() != null) return error.ExtraColumn;
        }

        return row;
    }

    return null;
}

pub fn points(allocator: std.mem.Allocator, text: []const u8) ![]const u21 {
    var values: std.ArrayList(u21) = .empty;

    errdefer values.deinit(allocator);

    var tokens = std.mem.tokenizeAny(u8, text, " \t");

    while (tokens.next()) |token| try values.append(allocator, try std.fmt.parseInt(u21, token, 16));

    return values.toOwnedSlice(allocator);
}
