const std = @import("std");
const syntax = @import("syntax.zig");
const Allocator = std.mem.Allocator;

pub fn equal(windows: bool, left: []const u8, right: []const u8) bool {
    if (!windows) return std.mem.eql(u8, left, right);

    return @import("lowercase.zig").equal(left, right);
}

pub fn resolve(allocator: Allocator, windows: bool, cwd: []const u8, paths: []const []const u8) ![]const u8 {
    const cwd_root = syntax.root(windows, cwd);

    if (!cwd_root.absolute or (windows and cwd_root.device_end == 0)) return error.InvalidWorkingDirectory;

    var tail = try allocator.dupe(u8, "");

    defer allocator.free(tail);

    var device: []const u8 = "";
    var absolute = false;
    var offset = paths.len + 1;

    while (offset > 0) {
        offset -= 1;

        const path = if (offset == 0) cwd else paths[offset - 1];

        if (path.len == 0) continue;

        const root = syntax.root(windows, path);

        if (root.device_end != 0) {
            const candidate = path[0..root.device_end];

            if (device.len != 0 and !sameDevice(windows, device, candidate)) continue;

            device = candidate;
        }

        if (!absolute) {
            const next = try std.fmt.allocPrint(allocator, "{s}{c}{s}", .{ path[root.end..], if (windows) @as(u8, '\\') else '/', tail });

            allocator.free(tail);

            tail = next;
            absolute = root.absolute;
        }

        if (absolute and (!windows or device.len != 0)) break;
    }

    if (!absolute or (windows and device.len == 0)) return error.MissingDriveDirectory;

    const combined = try std.fmt.allocPrint(allocator, "{s}{c}{s}", .{ device, if (windows) @as(u8, '\\') else '/', tail });

    defer allocator.free(combined);

    const normalized = try @import("normalize.zig").normalize(allocator, windows, combined);

    defer allocator.free(normalized);

    const root = syntax.root(windows, normalized);
    var end = normalized.len;

    while (end > root.end and syntax.separator(windows, normalized[end - 1])) : (end -= 1) {}

    return allocator.dupe(u8, normalized[0..end]);
}

fn sameDevice(windows: bool, left: []const u8, right: []const u8) bool {
    const a = syntax.root(windows, left);
    const b = syntax.root(windows, right);

    if (a.server.len != 0 and b.server.len != 0) return equal(windows, a.server, b.server) and equal(windows, a.share, b.share);

    return equal(windows, left, right);
}

pub fn relative(allocator: Allocator, windows: bool, cwd: []const u8, from_path: []const u8, to_path: []const u8) ![]const u8 {
    const from = try resolve(allocator, windows, cwd, &.{from_path});

    defer allocator.free(from);

    const to = try resolve(allocator, windows, cwd, &.{to_path});

    defer allocator.free(to);

    const from_root = syntax.root(windows, from);
    const to_root = syntax.root(windows, to);

    if (!equal(windows, from[0..from_root.device_end], to[0..to_root.device_end])) return allocator.dupe(u8, to);

    var left: std.ArrayList([]const u8) = .empty;
    var right: std.ArrayList([]const u8) = .empty;

    defer left.deinit(allocator);
    defer right.deinit(allocator);

    const separator: u8 = if (windows) '\\' else '/';
    var from_parts = std.mem.splitScalar(u8, from[from_root.end..], separator);
    var to_parts = std.mem.splitScalar(u8, to[to_root.end..], separator);

    while (from_parts.next()) |part| if (part.len != 0) {
        try left.append(allocator, part);
    };

    while (to_parts.next()) |part| if (part.len != 0) {
        try right.append(allocator, part);
    };

    var common: usize = 0;

    while (common < left.items.len and common < right.items.len and equal(windows, left.items[common], right.items[common])) : (common += 1) {}

    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();

    for (common..left.items.len) |_| {
        if (output.written().len > 0) try output.writer.writeByte(separator);
        try output.writer.writeAll("..");
    }

    for (right.items[common..]) |part| {
        if (output.written().len > 0) try output.writer.writeByte(separator);
        try output.writer.writeAll(part);
    }

    return output.toOwnedSlice();
}
