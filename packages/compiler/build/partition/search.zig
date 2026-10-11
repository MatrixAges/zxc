const std = @import("std");

const lanes = 32;
const Lanes = @Vector(lanes, u8);

/// Offset of `needle` in `haystack` at or after `start`. Generated Zig is dense in the bytes that end the needles
/// searched here (`_`, a space), where Boyer-Moore-Horspool advances one byte at a time; this compares the first and
/// last needle byte at 32 positions per step and checks the whole needle only where both match.
pub fn find(haystack: []const u8, start: usize, needle: []const u8) ?usize {
    if (needle.len < 2) return std.mem.indexOfPos(u8, haystack, start, needle);

    const first: Lanes = @splat(needle[0]);
    const last: Lanes = @splat(needle[needle.len - 1]);
    var index = start;

    while (index + needle.len - 1 + lanes <= haystack.len) : (index += lanes) {
        const heads: Lanes = haystack[index..][0..lanes].*;
        const tails: Lanes = haystack[index + needle.len - 1 ..][0..lanes].*;
        var candidates = @as(u32, @bitCast(heads == first)) & @as(u32, @bitCast(tails == last));

        while (candidates != 0) : (candidates &= candidates - 1) {
            const at = index + @ctz(candidates);

            if (std.mem.eql(u8, haystack[at..][0..needle.len], needle)) return at;
        }
    }

    return std.mem.indexOfPos(u8, haystack, index, needle);
}
