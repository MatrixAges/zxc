const std = @import("std");
const model = @import("../model.zig");
const percent = @import("../percent.zig");

pub fn append(allocator: std.mem.Allocator, url: *model.Url, input: []const u8) !void {
    var segments: std.ArrayList([]const u8) = .empty;

    try segments.appendSlice(allocator, url.path);

    const is_file = std.mem.eql(u8, url.scheme, "file");
    const is_special = model.special(url.scheme);
    var start: usize = 0;
    var index: usize = 0;

    while (index <= input.len) : (index += 1) {
        const end = index == input.len;

        if (!end and input[index] != '/' and !(is_special and input[index] == '\\')) continue;

        const segment = input[start..index];

        if (dot(segment, true)) {
            shorten(&segments, is_file);

            if (end) try segments.append(allocator, "");
        } else if (dot(segment, false)) {
            if (end) try segments.append(allocator, "");
        } else if (is_file and segments.items.len == 0 and drive(segment)) {
            try segments.append(allocator, try allocator.dupe(u8, &.{ segment[0], ':' }));
        } else try segments.append(allocator, try percent.encode(allocator, segment, .path));

        start = index + 1;
    }

    url.path = try segments.toOwnedSlice(allocator);
}

pub fn shorten(segments: *std.ArrayList([]const u8), is_file: bool) void {
    if (is_file and segments.items.len == 1 and drive(segments.items[0]) and segments.items[0][1] == ':') return;

    _ = segments.pop();
}

pub fn drive(input: []const u8) bool {
    return input.len == 2 and std.ascii.isAlphabetic(input[0]) and (input[1] == ':' or input[1] == '|');
}

pub fn startsDrive(input: []const u8) bool {
    return input.len >= 2 and drive(input[0..2]) and (input.len == 2 or std.mem.indexOfScalar(u8, "/\\?#", input[2]) != null);
}

fn dot(input: []const u8, double: bool) bool {
    if (!double) return std.mem.eql(u8, input, ".") or std.ascii.eqlIgnoreCase(input, "%2e");

    return std.mem.eql(u8, input, "..") or std.ascii.eqlIgnoreCase(input, ".%2e") or std.ascii.eqlIgnoreCase(input, "%2e.") or std.ascii.eqlIgnoreCase(input, "%2e%2e");
}
