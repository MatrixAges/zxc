const std = @import("std");
const width = 32;
const Lanes = @Vector(width, u8);

pub fn find(haystack: []const u8, start: usize, needle: []const u8) ?usize {
    if (start > haystack.len) return null;
    if (needle.len < 2) return std.mem.indexOfPos(u8, haystack, start, needle);
    if (needle.len > haystack.len - start) return null;

    const first: Lanes = @splat(needle[0]);
    const last: Lanes = @splat(needle[needle.len - 1]);
    const limit = haystack.len - needle.len + 1;
    var index = start;

    while (limit - index >= width) : (index += width) {
        const heads: Lanes = haystack[index..][0..width].*;
        const tails: Lanes = haystack[index + needle.len - 1 ..][0..width].*;
        var candidates = @as(u32, @bitCast(heads == first)) & @as(u32, @bitCast(tails == last));

        while (candidates != 0) : (candidates &= candidates - 1) {
            const at = index + @ctz(candidates);

            if (std.mem.eql(u8, haystack[at..][0..needle.len], needle)) return at;
        }
    }

    return std.mem.indexOfPos(u8, haystack, index, needle);
}
