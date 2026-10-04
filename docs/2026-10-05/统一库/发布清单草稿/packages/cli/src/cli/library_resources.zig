const std = @import("std");
const Inputs = @import("watch/inputs.zig");
const inventory = @import("library/inventory.zig");

pub fn retiredFromStaging(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, staging: []const u8, inputs: *Inputs) ![]const []const u8 {
    var next = try inventory.read(io, allocator, staging) orelse return error.MissingLibraryInventory;

    defer next.deinit();

    return retired(io, allocator, directory, next.value.managed_files orelse next.value.bundled_files, inputs);
}

pub fn retired(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, current: anytype, inputs: ?*Inputs) ![]const []const u8 {
    var previous = try inventory.read(io, allocator, directory) orelse return &.{};

    defer previous.deinit();

    const root = try std.fs.path.resolve(allocator, &.{directory});
    const physical_root = try std.Io.Dir.cwd().realPathFileAlloc(io, root, allocator);
    var paths: std.ArrayList([]const u8) = .empty;

    for (previous.value.managed_files orelse previous.value.bundled_files) |resource| {
        const path = try std.fs.path.resolve(allocator, &.{ root, resource.path });
        const relative = try std.fs.path.relative(allocator, root, null, root, path);
        const portable = try allocator.dupe(u8, relative);

        defer allocator.free(portable);

        if (std.fs.path.sep == '\\') for (portable) |*byte| if (byte.* == '\\') {
            byte.* = '/';
        };

        if (!inventory.valid(portable, previous.value.managed_files == null)) return error.InvalidLibraryInventory;

        var retained = false;

        for (current) |file| {
            const target = try std.fs.path.resolve(allocator, &.{ root, file.path });

            if (std.mem.eql(u8, path, target)) retained = true;
        }

        if (retained) continue;

        const stat = std.Io.Dir.cwd().statFile(io, path, .{ .follow_symlinks = false }) catch |err| switch (err) {
            error.FileNotFound => continue,
            else => return err,
        };

        if (stat.kind != .file) return error.LibraryResourceModified;

        const physical = try std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator);
        const physical_relative = try std.fs.path.relative(allocator, physical_root, null, physical_root, physical);

        if (std.fs.path.isAbsolute(physical_relative) or std.mem.eql(u8, physical_relative, "..") or std.mem.startsWith(u8, physical_relative, ".." ++ std.fs.path.sep_str)) return error.LibraryResourceOutsideOutput;

        for (current) |file| {
            const target = try std.fs.path.resolve(allocator, &.{ root, file.path });

            const target_stat = std.Io.Dir.cwd().statFile(io, target, .{ .follow_symlinks = false }) catch |err| switch (err) {
                error.FileNotFound => continue,
                else => return err,
            };

            if (target_stat.kind != .file) continue;

            const target_physical = try std.Io.Dir.cwd().realPathFileAlloc(io, target, allocator);

            if (std.mem.eql(u8, physical, target_physical)) retained = true;
        }

        if (retained) continue;

        if (inputs) |observed| {
            const output = try @import("watch/output.zig").check(io, allocator, observed, path);

            allocator.free(output);
        }

        const bytes = try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .unlimited);

        defer allocator.free(bytes);

        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(bytes, &digest, .{});

        const hex = std.fmt.bytesToHex(digest, .lower);

        if (!std.ascii.eqlIgnoreCase(&hex, resource.sha256)) return error.LibraryResourceModified;
        try paths.append(allocator, path);
    }

    return paths.items;
}

pub fn remove(io: std.Io, paths: []const []const u8) !void {
    for (paths) |path| {
        std.Io.Dir.cwd().deleteFile(io, path) catch |err| switch (err) {
            error.FileNotFound => {},
            else => return err,
        };
    }
}
