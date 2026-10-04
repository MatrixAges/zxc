const std = @import("std");
const manifest = @import("manifest.zig");
const Manifest = @import("manifest/model.zig").Manifest;
pub const usage = "zxc pkg init <name> [--version <version>] [--entry <path>] [--private]\n";

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: []const []const u8, output: *std.Io.Writer, errors: *std.Io.Writer) !bool {
    const data = options(args) catch {
        try errors.writeAll(usage);

        return false;
    };

    var source: std.Io.Writer.Allocating = .init(allocator);

    defer source.deinit();

    try @import("manifest/write.zig").write(&source.writer, data);

    var parsed = try manifest.parse(allocator, source.written());

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        try errors.print("pkg.yaml: {s}\n", .{parsed.value.diagnostic.message});

        return false;
    }

    const file = std.Io.Dir.cwd().createFile(io, "pkg.yaml", .{ .exclusive = true }) catch |err| {
        try errors.print("pkg.yaml: {s}\n", .{@errorName(err)});

        return false;
    };

    var completed = false;

    defer {
        file.close(io);

        if (!completed) std.Io.Dir.cwd().deleteFile(io, "pkg.yaml") catch {};
    }

    var buffer: [4096]u8 = undefined;
    var writer = file.writer(io, &buffer);

    writer.interface.writeAll(source.written()) catch {
        try errors.print("pkg.yaml: {s}\n", .{@errorName(writer.err.?)});

        return false;
    };

    writer.interface.flush() catch {
        try errors.print("pkg.yaml: {s}\n", .{@errorName(writer.err.?)});

        return false;
    };

    completed = true;

    try output.writeAll("Created pkg.yaml\n");

    return true;
}

fn options(args: []const []const u8) !Manifest {
    if (args.len < 2) return error.InvalidArguments;

    var data = Manifest{ .name = args[1], .version = "0.1.0" };
    var version_set = false;
    var index: usize = 2;

    while (index < args.len) : (index += 1) {
        const option = args[index];

        if (std.mem.eql(u8, option, "--private")) {
            if (data.private) return error.InvalidArguments;

            data.private = true;
        } else if (std.mem.eql(u8, option, "--version")) {
            if (version_set or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            data.version = args[index];
            version_set = true;
        } else if (std.mem.eql(u8, option, "--entry")) {
            if (data.entry != null or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            data.entry = args[index];
        } else return error.InvalidArguments;
    }

    return data;
}
