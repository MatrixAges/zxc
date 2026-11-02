const std = @import("std");
const mapping = @import("unicode/mapping.zig");
const properties = @import("unicode/properties.zig");

const Iterator = struct {
    bytes: []const u8,
    offset: usize = 0,
    pending: ?u32 = null,
    preceded: bool = false,
    fn read(self: *Iterator) ?u32 {
        if (self.offset == self.bytes.len) return null;

        const start = self.offset;
        const len = std.unicode.utf8ByteSequenceLength(self.bytes[start]) catch 1;
        self.offset += @min(len, self.bytes.len - start);

        return std.unicode.utf8Decode(self.bytes[start..self.offset]) catch invalid: {
            self.offset = start + 1;

            break :invalid 0x110000 + @as(u32, self.bytes[start]);
        };
    }
    fn followed(self: Iterator) bool {
        var rest = self;

        while (rest.read()) |code| {
            if (contains(&properties.case_ignorable, code)) continue;

            return contains(&properties.cased, code);
        }

        return false;
    }
    fn next(self: *Iterator) ?u32 {
        if (self.pending) |code| {
            self.pending = null;

            return code;
        }

        const code = self.read() orelse return null;
        const preceded = self.preceded;

        if (!contains(&properties.case_ignorable, code)) self.preceded = contains(&properties.cased, code);

        for (mapping.final_sigma) |entry| {
            if (entry.code == code and preceded and !self.followed()) return entry.lower;
        }

        var begin: usize = 0;
        var end = mapping.mappings.len;

        while (begin < end) {
            const middle = begin + (end - begin) / 2;
            const entry = mapping.mappings[middle];

            if (code < entry.code) {
                end = middle;
            } else if (code > entry.code) {
                begin = middle + 1;
            } else {
                if (entry.lower[1] != 0) self.pending = entry.lower[1];

                return entry.lower[0];
            }
        }

        return code;
    }
};

fn contains(ranges: []const properties.Range, code: u32) bool {
    var begin: usize = 0;
    var end = ranges.len;

    while (begin < end) {
        const middle = begin + (end - begin) / 2;
        const range = ranges[middle];

        if (code < range.first) {
            end = middle;
        } else if (code > range.last) {
            begin = middle + 1;
        } else return true;
    }

    return false;
}

pub fn equal(left: []const u8, right: []const u8) bool {
    var a: Iterator = .{ .bytes = left };
    var b: Iterator = .{ .bytes = right };

    while (true) {
        const x = a.next();
        const y = b.next();

        if (x == null or y == null) return x == y;
        if ((x.? == '/' or x.? == '\\') and (y.? == '/' or y.? == '\\')) continue;
        if (x != y) return false;
    }
}
