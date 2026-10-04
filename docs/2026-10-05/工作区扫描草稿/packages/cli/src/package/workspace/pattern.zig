const std = @import("std");
const Pattern = @This();

pub const Match = struct { matched: bool, descendants: bool };

exclude: bool,
parts: []const []const u8,
pub fn parse(allocator: std.mem.Allocator, text: []const u8) !Pattern {
    const exclude = text[0] == '!';
    const path = if (exclude) text[1..] else text;

    if (std.mem.indexOfAny(u8, path, "[]{}()!") != null) return error.UnsupportedWorkspacePattern;

    var parts: std.ArrayList([]const u8) = .empty;

    errdefer parts.deinit(allocator);

    var segments = std.mem.splitScalar(u8, path, '/');

    while (segments.next()) |part| {
        if (part.len == 0 or std.mem.eql(u8, part, ".")) continue;
        if (std.mem.indexOf(u8, part, "**") != null and !std.mem.eql(u8, part, "**")) return error.UnsupportedWorkspacePattern;
        try parts.append(allocator, part);
    }

    return .{ .exclude = exclude, .parts = try parts.toOwnedSlice(allocator) };
}

pub fn matches(self: Pattern, allocator: std.mem.Allocator, path: []const u8) !bool {
    return (try self.inspect(allocator, path)).matched;
}

pub fn inspect(self: Pattern, allocator: std.mem.Allocator, path: []const u8) !Match {
    const current = try allocator.alloc(bool, self.parts.len + 1);

    defer allocator.free(current);

    const next = try allocator.alloc(bool, current.len);

    defer allocator.free(next);

    @memset(current, false);

    current[0] = true;

    self.close(current);

    var segments = std.mem.tokenizeAny(u8, path, "/\\");

    while (segments.next()) |segment| {
        @memset(next, false);

        for (self.parts, 0..) |part, index| {
            if (!current[index]) continue;

            if (std.mem.eql(u8, part, "**")) {
                next[index] = true;
            } else if (matchSegment(part, segment)) {
                next[index + 1] = true;
            }
        }

        self.close(next);
        @memcpy(current, next);
    }

    const descendants = for (current[0..self.parts.len]) |active| {
        if (active) break true;
    } else false;

    return .{ .matched = current[self.parts.len], .descendants = descendants };
}

fn close(self: Pattern, states: []bool) void {
    for (self.parts, 0..) |part, index| {
        if (states[index] and std.mem.eql(u8, part, "**")) states[index + 1] = true;
    }
}

fn matchSegment(pattern: []const u8, text: []const u8) bool {
    var p: usize = 0;
    var t: usize = 0;
    var star: ?usize = null;
    var retry: usize = 0;

    while (t < text.len) {
        if (p < pattern.len and (pattern[p] == '?' or pattern[p] == text[t])) {
            p += 1;
            t += 1;
        } else if (p < pattern.len and pattern[p] == '*') {
            star = p;
            p += 1;
            retry = t;
        } else if (star) |index| {
            retry += 1;
            t = retry;
            p = index + 1;
        } else return false;
    }

    while (p < pattern.len and pattern[p] == '*') : (p += 1) {}

    return p == pattern.len;
}
