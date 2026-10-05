const std = @import("std");
const tables = @import("tables.zig");
const nfc = @import("nfc.zig");
const punycode = @import("punycode.zig");
const joiners = @import("joiners.zig");
const bidi = @import("bidi.zig");
const prefix = [_]u21{ 'x', 'n', '-', '-' };

pub fn parse(allocator: std.mem.Allocator, input: []const u8) ![]const []const u21 {
    const view = std.unicode.Utf8View.init(input) catch return error.InvalidDomain;
    var iterator = view.iterator();
    var mapped: std.ArrayList(u21) = .empty;

    defer mapped.deinit(allocator);

    while (iterator.nextCodepoint()) |point| {
        const entry = tables.mapping(point) orelse return error.InvalidDomain;

        switch (entry.status) {
            .ignored => {},
            .mapped => try mapped.appendSlice(allocator, entry.values),
            else => try mapped.append(allocator, point),
        }
    }

    const normalized = try nfc.normalize(allocator, mapped.items);
    var labels: std.ArrayList([]const u21) = .empty;
    var parts = std.mem.splitScalar(u21, normalized, '.');

    while (parts.next()) |part| {
        const label = if (std.mem.startsWith(u21, part, &prefix)) try decode(allocator, part[4..]) else part;

        try validate(label);
        try labels.append(allocator, label);
    }

    if (bidi.required(labels.items)) {
        for (labels.items) |label| try bidi.validate(label);
    }

    return labels.toOwnedSlice(allocator);
}

fn decode(allocator: std.mem.Allocator, input: []const u21) ![]const u21 {
    const bytes = try allocator.alloc(u8, input.len);

    defer allocator.free(bytes);

    for (input, bytes) |point, *byte| {
        if (point >= 128) return error.InvalidDomain;

        byte.* = @intCast(point);
    }

    const decoded = try punycode.decode(allocator, bytes);
    const normalized = try nfc.normalize(allocator, decoded);

    defer allocator.free(normalized);

    if (isAscii(decoded) or !std.mem.eql(u21, decoded, normalized)) return error.InvalidDomain;

    return decoded;
}

fn validate(label: []const u21) !void {
    if (label.len == 0) return;
    if (std.mem.startsWith(u21, label, &prefix) or tables.inspect(label[0]).mark) return error.InvalidDomain;

    for (label) |point| {
        if (point == '.') return error.InvalidDomain;

        const entry = tables.mapping(point) orelse return error.InvalidDomain;

        if (entry.status != .valid and entry.status != .deviation) return error.InvalidDomain;
    }

    try joiners.validate(label);
}

pub fn isAscii(label: []const u21) bool {
    for (label) |point| {
        if (point >= 128) return false;
    }

    return true;
}
