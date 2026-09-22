pub const Span = struct {
    start: usize,
    end: usize,
};

pub const Location = struct {
    line: usize,
    column: usize,
};

pub fn locate(text: []const u8, offset: usize) Location {
    var location = Location{ .line = 1, .column = 1 };

    for (text[0..@min(offset, text.len)]) |byte| {
        if (byte == '\n') {
            location.line += 1;
            location.column = 1;
        } else {
            location.column += 1;
        }
    }

    return location;
}
