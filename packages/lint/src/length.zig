const std = @import("std");
/// Default lint limit for one ZX source file; the compiler itself never enforces it.
pub const default_maximum: usize = 120;
pub const Exceeded = struct { lines: usize, maximum: usize };

/// Counts physical lines, including blank and comment lines; a maximum of zero disables the rule.
pub fn check(source: []const u8, maximum: usize) ?Exceeded {
    if (maximum == 0) return null;

    const lines = count(source);

    return if (lines > maximum) .{ .lines = lines, .maximum = maximum } else null;
}

pub fn count(source: []const u8) usize {
    if (source.len == 0) return 0;

    const breaks = std.mem.countScalar(u8, source, '\n');

    return if (source[source.len - 1] == '\n') breaks else breaks + 1;
}
