const data = @import("data/normalization.zig");

pub fn combiningClass(point: u21) u8 {
    var start: usize = 0;
    var end: usize = data.classes.len;

    while (start < end) {
        const middle = start + (end - start) / 2;
        const entry = data.classes[middle];

        if (point < entry.first) {
            end = middle;
        } else if (point > entry.last) {
            start = middle + 1;
        } else return entry.value;
    }

    return 0;
}

pub fn decomposition(point: u21) ?[]const u21 {
    var start: usize = 0;
    var end: usize = data.decompositions.len;

    while (start < end) {
        const middle = start + (end - start) / 2;
        const entry = data.decompositions[middle];

        if (point < entry.point) {
            end = middle;
        } else if (point > entry.point) {
            start = middle + 1;
        } else return entry.values;
    }

    return null;
}

pub fn compose(first: u21, second: u21) ?u21 {
    if (first >= 0x1100 and first < 0x1113 and second >= 0x1161 and second < 0x1176) {
        return 0xac00 + (first - 0x1100) * 588 + (second - 0x1161) * 28;
    }

    if (first >= 0xac00 and first < 0xd7a4 and (first - 0xac00) % 28 == 0 and second > 0x11a7 and second < 0x11c3) {
        return first + second - 0x11a7;
    }

    const key = @as(u64, first) << 21 | second;
    var start: usize = 0;
    var end: usize = data.compositions.len;

    while (start < end) {
        const middle = start + (end - start) / 2;
        const entry = data.compositions[middle];
        const candidate = @as(u64, entry.first) << 21 | entry.second;

        if (key < candidate) {
            end = middle;
        } else if (key > candidate) {
            start = middle + 1;
        } else return entry.point;
    }

    return null;
}
