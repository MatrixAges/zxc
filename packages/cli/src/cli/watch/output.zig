const std = @import("std");
const Inputs = @import("inputs.zig");

pub fn check(io: std.Io, allocator: std.mem.Allocator, inputs: *const Inputs, path: []const u8) ![:0]u8 {
    const absolute = try std.fs.path.resolve(allocator, &.{ inputs.cwd, path });

    defer allocator.free(absolute);

    const parent = try physicalDirectory(io, allocator, std.fs.path.dirname(absolute).?);

    defer allocator.free(parent);

    var target = try std.fs.path.joinZ(allocator, &.{ parent, std.fs.path.basename(absolute) });

    errdefer allocator.free(target);

    const existing = std.Io.Dir.cwd().statFile(io, absolute, .{ .follow_symlinks = false }) catch |err| switch (err) {
        error.FileNotFound => null,
        else => return err,
    };

    if (existing) |file| {
        if (file.kind != .sym_link) {
            const resolved = try std.Io.Dir.cwd().realPathFileAlloc(io, absolute, allocator);

            allocator.free(target);

            target = resolved;
        }
    }

    var entries = inputs.entries.iterator();

    while (entries.next()) |entry| {
        const physical = switch (entry.value_ptr.state) {
            .file => |file| file.physical_path,
            .directory => |directory| directory.physical_path,
            else => entry.key_ptr.*,
        };

        if (std.mem.eql(u8, absolute, entry.key_ptr.*) or std.mem.eql(u8, target, physical)) return error.OutputOverlapsInput;
    }

    return target;
}

fn physicalDirectory(io: std.Io, allocator: std.mem.Allocator, path: []const u8) ![:0]u8 {
    return std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator) catch |err| {
        if (err != error.FileNotFound) return err;

        const parent = std.fs.path.dirname(path) orelse return err;
        const physical = try physicalDirectory(io, allocator, parent);

        defer allocator.free(physical);

        return std.fs.path.joinZ(allocator, &.{ physical, std.fs.path.basename(path) });
    };
}
