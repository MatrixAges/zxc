const std = @import("std");
const manifest = @import("manifest.zig");
const workspace = @import("workspace.zig");

pub const Result = struct { path: ?[]const u8 = null, diagnostic: ?[]const u8 = null };

pub fn find(io: std.Io, allocator: std.mem.Allocator, entry: []const u8) !Result {
    const real = try std.Io.Dir.cwd().realPathFileAlloc(io, entry, allocator);
    var directory = std.fs.path.dirname(real).?;
    var nearest: ?[]const u8 = null;

    while (true) {
        const path = try std.fs.path.join(allocator, &.{ directory, "pkg.yaml" });

        const source = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4 * 1024 * 1024)) catch |err| switch (err) {
            error.FileNotFound => null,
            else => return err,
        };

        if (source) |text| {
            const parsed = try manifest.parse(allocator, text);

            switch (parsed.value) {
                .diagnostic => |issue| return .{ .diagnostic = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: manifest: {s}", .{ path, issue.line, issue.column, issue.message }) },
                .data => |data| {
                    if (nearest == null) nearest = path;

                    if (data.workspace != null) {
                        if (std.mem.eql(u8, nearest.?, path)) return .{ .path = path };

                        const members = try workspace.load(io, allocator, path);

                        if (members.diagnostic) |message| return .{ .diagnostic = message };

                        for (members.packages) |member| {
                            const member_path = try std.fs.path.resolve(allocator, &.{ directory, member.path, "pkg.yaml" });

                            if (std.mem.eql(u8, member_path, nearest.?)) return .{ .path = path };
                        }
                    }
                },
            }
        }

        directory = std.fs.path.dirname(directory) orelse break;
    }

    return .{ .path = nearest };
}
