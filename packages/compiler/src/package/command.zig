const std = @import("std");
const manifest = @import("manifest.zig");

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: []const []const u8, output: *std.Io.Writer, errors: *std.Io.Writer) !bool {
    if (args.len != 0 and (std.mem.eql(u8, args[0], "index") or std.mem.eql(u8, args[0], "resolve"))) return @import("index.zig").run(io, allocator, args, output, errors);

    if (args.len < 1 or args.len > 2 or (!std.mem.eql(u8, args[0], "inspect") and !std.mem.eql(u8, args[0], "workspace") and !std.mem.eql(u8, args[0], "graph"))) {
        try errors.writeAll("zxc pkg inspect|workspace|graph [pkg.yaml]\n");

        return false;
    }

    const path = if (args.len == 2) args[1] else "pkg.yaml";

    if (std.mem.eql(u8, args[0], "graph")) {
        var result = try @import("graph.zig").load(io, allocator, path);

        defer result.deinit();

        if (result.diagnostic) |message| {
            try errors.print("{s}\n", .{message});

            return false;
        }

        try std.json.Stringify.value(result.packages, .{ .whitespace = .indent_2 }, output);
        try output.writeByte('\n');

        return true;
    }

    if (std.mem.eql(u8, args[0], "workspace")) {
        var result = try @import("workspace.zig").load(io, allocator, path);

        defer result.deinit();

        if (result.diagnostic) |message| {
            try errors.print("{s}\n", .{message});

            return false;
        }

        try std.json.Stringify.value(result.packages, .{ .whitespace = .indent_2 }, output);
        try output.writeByte('\n');

        return true;
    }

    const source = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(4 * 1024 * 1024)) catch |err| {
        if (err == error.OutOfMemory) return err;

        try errors.print("{s}: {s}\n", .{ path, @errorName(err) });

        return false;
    };

    defer allocator.free(source);

    var result = try manifest.parse(allocator, source);

    defer result.deinit();

    switch (result.value) {
        .diagnostic => |issue| {
            try errors.print("{s}:{d}:{d}: manifest: {s}\n", .{ path, issue.line, issue.column, issue.message });

            return false;
        },
        .data => |data| {
            try std.json.Stringify.value(data, .{ .whitespace = .indent_2 }, output);
            try output.writeByte('\n');
        },
    }

    return true;
}
