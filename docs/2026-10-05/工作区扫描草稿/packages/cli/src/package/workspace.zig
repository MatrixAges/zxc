const std = @import("std");
const Inputs = @import("../cli/watch/inputs.zig");
const manifest = @import("manifest.zig");
const Manifest = @import("manifest/model.zig").Manifest;
const Pattern = @import("workspace/pattern.zig");
const directory = @import("workspace/directory.zig");
pub const Package = struct { path: []const u8, manifest: Manifest };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    packages: []const Package = &.{},
    diagnostic: ?[]const u8 = null,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn load(io: std.Io, allocator: std.mem.Allocator, path: []const u8) !Result {
    return loadWithInputs(io, allocator, path, null);
}

pub fn loadWithInputs(io: std.Io, allocator: std.mem.Allocator, path: []const u8, inputs: ?*Inputs) !Result {
    if (inputs) |observed| try observed.add(io, path);

    var result: Result = .{ .arena = .init(allocator) };

    errdefer result.deinit();

    result.packages = collect(io, &result, path, inputs) catch |err| {
        if (err == error.OutOfMemory) return err;
        if (result.diagnostic == null) result.diagnostic = try std.fmt.allocPrint(result.arena.allocator(), "{s}: {s}", .{ path, @errorName(err) });

        return result;
    };

    return result;
}

fn collect(io: std.Io, result: *Result, path: []const u8, inputs: ?*Inputs) ![]const Package {
    const allocator = result.arena.allocator();
    const root_path = try std.Io.Dir.cwd().realPathFileAlloc(io, std.fs.path.dirname(path) orelse ".", allocator);
    const root = try read(io, result, root_path, path, inputs);
    var packages: std.ArrayList(Package) = .empty;

    try packages.append(allocator, .{ .path = ".", .manifest = root });

    const workspace = root.workspace orelse return try packages.toOwnedSlice(allocator);

    if (workspace.packages.len == 0) return try packages.toOwnedSlice(allocator);

    const patterns = try allocator.alloc(Pattern, workspace.packages.len);

    for (workspace.packages, patterns) |text, *pattern| {
        pattern.* = Pattern.parse(allocator, text) catch |err| {
            if (err == error.OutOfMemory) return err;

            result.diagnostic = try std.fmt.allocPrint(allocator, "{s}: unsupported workspace pattern: {s}", .{ path, text });

            return error.InvalidWorkspace;
        };
    }

    if (inputs) |observed| try observed.add(io, root_path);

    var dir = try std.Io.Dir.openDirAbsolute(io, root_path, .{ .iterate = true });

    defer dir.close(io);

    var walker = try dir.walkSelectively(allocator);

    defer {
        while (walker.stack.items.len > 0) walker.leave(io);

        walker.deinit();
    }

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(io)) |entry| {
        if (entry.kind != .directory or directory.ignored(entry.basename)) continue;

        var included = false;
        var excluded = false;
        var descendants = false;

        for (patterns) |pattern| {
            const match = try pattern.inspect(allocator, entry.path);

            if (!pattern.exclude) descendants = descendants or match.descendants;
            if (!match.matched) continue;
            if (pattern.exclude) excluded = true else included = true;
        }

        if (included and !excluded) try paths.append(allocator, try allocator.dupe(u8, entry.path));
        if (!descendants) continue;

        if (inputs) |observed| {
            const child = try std.fs.path.join(allocator, &.{ root_path, entry.path });

            try observed.add(io, child);
        }

        try walker.enter(io, entry);
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);

    var names: std.StringHashMap([]const u8) = .init(allocator);

    try names.put(root.name, ".");

    for (paths.items) |member| {
        const member_path = try std.fs.path.join(allocator, &.{ root_path, member, "pkg.yaml" });

        const data = read(io, result, root_path, member_path, inputs) catch |err| switch (err) {
            error.FileNotFound => continue,
            else => {
                if (err == error.OutOfMemory) return err;
                if (result.diagnostic == null) result.diagnostic = try std.fmt.allocPrint(allocator, "{s}: {s}", .{ member_path, @errorName(err) });

                return err;
            },
        };

        const previous = try names.getOrPut(data.name);

        if (previous.found_existing) {
            result.diagnostic = try std.fmt.allocPrint(allocator, "{s}: duplicate workspace package {s}; first declared at {s}", .{ member_path, data.name, previous.value_ptr.* });

            return error.InvalidWorkspace;
        }

        previous.value_ptr.* = member;

        const portable = try allocator.dupe(u8, member);

        std.mem.replaceScalar(u8, portable, '\\', '/');

        try packages.append(allocator, .{ .path = portable, .manifest = data });
    }

    return try packages.toOwnedSlice(allocator);
}

fn read(io: std.Io, result: *Result, root: []const u8, path: []const u8, inputs: ?*Inputs) !Manifest {
    const allocator = result.arena.allocator();

    if (inputs) |observed| try observed.add(io, path);

    const real = try std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator);
    const relative = try std.fs.path.relative(allocator, root, null, root, real);

    if (std.fs.path.isAbsolute(relative) or std.mem.eql(u8, relative, "..") or std.mem.startsWith(u8, relative, "../") or std.mem.startsWith(u8, relative, "..\\")) {
        result.diagnostic = try std.fmt.allocPrint(allocator, "{s}: manifest escapes the workspace root", .{path});

        return error.InvalidWorkspace;
    }

    const source = try std.Io.Dir.cwd().readFileAlloc(io, real, allocator, .limited(4 * 1024 * 1024));

    if (inputs) |observed| try observed.record(io, path, source);

    const parsed = try manifest.parse(allocator, source);

    return switch (parsed.value) {
        .data => |data| data,
        .diagnostic => |issue| {
            result.diagnostic = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: manifest: {s}", .{ path, issue.line, issue.column, issue.message });

            return error.InvalidWorkspace;
        },
    };
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
