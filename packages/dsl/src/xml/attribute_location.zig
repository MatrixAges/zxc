const std = @import("std");
const ast = @import("../ast.zig");

pub fn locate(attribute: ast.Attribute, decoded_offset: usize) ?ast.Location {
    return locateWithBias(attribute, decoded_offset, false, true);
}

pub fn locateEnd(attribute: ast.Attribute, decoded_offset: usize) ?ast.Location {
    return locateWithBias(attribute, decoded_offset, true, true);
}

pub fn byteOffset(attribute: ast.Attribute, decoded_offset: usize, end_bias: bool) ?usize {
    const location = locateWithBias(attribute, decoded_offset, end_bias, false) orelse return null;

    return location.offset;
}

fn locateWithBias(attribute: ast.Attribute, decoded_offset: usize, end_bias: bool, comptime coordinates: bool) ?ast.Location {
    if (decoded_offset > attribute.value.len) return null;

    const source = attribute.raw_value orelse return null;
    var location = attribute.value_location;

    if (attribute.kind == .expression) {
        if (coordinates) advance(&location, source, 0, decoded_offset);

        location.offset += decoded_offset;

        return location;
    }

    var raw_offset: usize = 0;
    var offset: usize = 0;

    while (offset < decoded_offset) {
        if (raw_offset == source.len) return null;

        const count = if (source[raw_offset] == '&') entity: {
            const end = std.mem.indexOfScalarPos(u8, source, raw_offset, ';') orelse return null;
            const width = std.unicode.utf8ByteSequenceLength(attribute.value[offset]) catch return null;

            if (!end_bias and decoded_offset - offset < width) return location;

            offset += width;

            break :entity end - raw_offset + 1;
        } else plain: {
            offset += 1;

            break :plain if (std.mem.startsWith(u8, source[raw_offset..], "\r\n")) @as(usize, 2) else 1;
        };

        if (coordinates) advance(&location, source, raw_offset, count);

        raw_offset += count;
        location.offset += count;
    }

    return location;
}

fn advance(location: *ast.Location, source: []const u8, start: usize, count: usize) void {
    for (source[start..][0..count], start..) |byte, index| {
        if (byte == '\r' or (byte == '\n' and (index == 0 or source[index - 1] != '\r'))) {
            location.line += 1;
            location.column = 1;
        } else if (byte != '\n') location.column += 1;
    }
}
