const mappings = @import("data/mapping.zig");
const properties = @import("data/properties.zig");
pub const Properties = properties.Properties;
pub const Bidi = properties.Bidi;
pub const Joining = properties.Joining;

pub fn mapping(point: u21) ?*const mappings.Entry {
    var start: usize = 0;
    var end: usize = mappings.entries.len;

    while (start < end) {
        const middle = start + (end - start) / 2;
        const entry = &mappings.entries[middle];

        if (point < entry.first) {
            end = middle;
        } else if (point > entry.last) {
            start = middle + 1;
        } else return entry;
    }

    return null;
}

pub fn inspect(point: u21) Properties {
    var start: usize = 0;
    var end: usize = properties.entries.len;

    while (start < end) {
        const middle = start + (end - start) / 2;
        const entry = properties.entries[middle];

        if (point < entry.first) {
            end = middle;
        } else if (point > entry.last) {
            start = middle + 1;
        } else return entry.value;
    }

    return .{};
}
