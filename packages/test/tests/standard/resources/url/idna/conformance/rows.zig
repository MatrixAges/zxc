const std = @import("std");

pub const Row = struct { line: usize, input: []const u8, unicode: []const u8, ascii: []const u8, accepted: bool };

lines: std.mem.SplitIterator(u8, .scalar),

line: usize = 0,
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

        var fields = std.mem.splitScalar(u8, content, ';');
        var columns: [7][]const u8 = undefined;

        for (&columns) |*column| column.* = std.mem.trim(u8, fields.next() orelse return error.MissingColumn, " \t");
        if (fields.next() != null) return error.ExtraColumn;

        const unicode = if (columns[1].len == 0) columns[0] else columns[1];
        const ascii = if (columns[3].len == 0) unicode else columns[3];
        const status = if (columns[4].len == 0) columns[2] else columns[4];
        var tokens = std.mem.tokenizeAny(u8, status, "[], \t");
        var accepted = true;

        while (tokens.next()) |code| {
            const ignored = for ([_][]const u8{ "A4_1", "A4_2", "V2", "V3", "U1" }) |flag| {
                if (std.mem.eql(u8, code, flag)) break true;
            } else false;

            if (!ignored) accepted = false;
        }

        return .{ .line = self.line, .input = columns[0], .unicode = unicode, .ascii = ascii, .accepted = accepted };
    }

    return null;
}
