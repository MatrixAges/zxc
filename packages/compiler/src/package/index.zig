const std = @import("std");
const pkgs = @import("pkgs");

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: []const []const u8, output: *std.Io.Writer, errors: *std.Io.Writer) !bool {
    const resolving = std.mem.eql(u8, args[0], "resolve");
    const required: usize = if (resolving) 3 else 1;

    if (args.len < required or args.len > required + 1) {
        try errors.writeAll("zxc pkg index [index.json]\nzxc pkg resolve <name> <range> [index.json]\n");

        return false;
    }

    const path = if (args.len > required) args[required] else null;

    const source = if (path) |file| std.Io.Dir.cwd().readFileAlloc(io, file, allocator, .limited(16 * 1024 * 1024)) catch |err| {
        if (err == error.OutOfMemory) return err;

        try errors.print("{s}: index: {s}\n", .{ file, @errorName(err) });

        return false;
    } else @import("bundle").index;

    defer if (path != null) allocator.free(source);

    const parsed = pkgs.Index.parse(allocator, source) catch |err| {
        if (err == error.OutOfMemory) return err;

        try errors.print("{s}: index: {s}\n", .{ path orelse "embedded index", @errorName(err) });

        return false;
    };

    defer parsed.deinit();

    if (resolving) {
        const release = parsed.value.select(args[1], args[2]) catch |err| {
            try errors.print("{s}: {s}: {s}\n", .{ args[1], args[2], @errorName(err) });

            return false;
        };

        if (release == null) {
            try errors.print("{s}: no indexed version satisfies {s}\n", .{ args[1], args[2] });

            return false;
        }

        try std.json.Stringify.value(release.?, .{ .whitespace = .indent_2 }, output);
    } else try std.json.Stringify.value(parsed.value, .{ .whitespace = .indent_2 }, output);

    try output.writeByte('\n');

    return true;
}
