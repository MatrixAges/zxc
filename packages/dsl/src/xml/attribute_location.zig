const std = @import("std");
const ast = @import("../ast.zig");

pub fn locate(attribute: ast.Attribute, decoded_offset: usize) ?ast.Location {
    return locateWithBias(attribute, decoded_offset, false);
}

pub fn locateEnd(attribute: ast.Attribute, decoded_offset: usize) ?ast.Location {
    return locateWithBias(attribute, decoded_offset, true);
}

fn locateWithBias(attribute: ast.Attribute, decoded_offset: usize, end_bias: bool) ?ast.Location {
    if (decoded_offset > attribute.value.len) return null;

    const source = attribute.raw_value orelse return null;
    var location = attribute.value_location;

    if (attribute.kind == .expression) {
        for (source[0..decoded_offset], 0..) |byte, index| {
            if (byte == '\r' or (byte == '\n' and (index == 0 or source[index - 1] != '\r'))) {
                location.line += 1;
                location.column = 1;
            } else if (byte != '\n') location.column += 1;
        }

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

        for (source[raw_offset..][0..count], raw_offset..) |byte, index| {
            if (byte == '\r' or (byte == '\n' and (index == 0 or source[index - 1] != '\r'))) {
                location.line += 1;
                location.column = 1;
            } else if (byte != '\n') location.column += 1;
        }

        raw_offset += count;
        location.offset += count;
    }

    return location;
}
