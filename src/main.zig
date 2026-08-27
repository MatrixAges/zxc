const std = @import("std");
const compiler = @import("zxc_compiler");

const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var stdout_buffer: [4096]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), init.io, &stdout_buffer);
    const stdout = &stdout_file_writer.interface;
    defer stdout.flush() catch {};

    var stderr_buffer: [4096]u8 = undefined;
    var stderr_file_writer: Io.File.Writer = .init(.stderr(), init.io, &stderr_buffer);
    const stderr = &stderr_file_writer.interface;
    defer stderr.flush() catch {};

    if (args.len == 2 and std.mem.eql(u8, args[1], "--help")) {
        try writeUsage(stdout);
        return;
    }
    if (args.len != 2 and args.len != 4) {
        try writeUsage(stderr);
        try stderr.flush();
        std.process.exit(1);
    }
    if (args.len == 4 and !std.mem.eql(u8, args[2], "--out")) {
        try stderr.print("unknown option: {s}\n", .{args[2]});
        try writeUsage(stderr);
        try stderr.flush();
        std.process.exit(1);
    }

    const input_path = args[1];
    const source = std.Io.Dir.cwd().readFileAlloc(
        init.io,
        input_path,
        allocator,
        .limited(16 * 1024 * 1024),
    ) catch |err| {
        try stderr.print("unable to read {s}: {t}\n", .{ input_path, err });
        try stderr.flush();
        std.process.exit(1);
    };

    const result = try compiler.compile(allocator, source, std.fs.path.basename(input_path));
    switch (result) {
        .diagnostic => |value| {
            try stderr.print(
                "{s}:{d}:{d}: {s}\n",
                .{ value.file_name, value.location.line, value.location.column, value.message },
            );
            try stderr.flush();
            std.process.exit(1);
        },
        .zig_source => |zig_source| {
            const output_path = if (args.len == 4)
                args[3]
            else
                defaultOutputPath(allocator, init.io, input_path) catch |err| switch (err) {
                    error.InputOutsideProjectRoot => {
                        try stderr.print("input must be inside the project root: {s}\n", .{input_path});
                        try stderr.flush();
                        std.process.exit(1);
                    },
                    error.InvalidInputExtension => {
                        try stderr.print("input must use the .zx extension: {s}\n", .{input_path});
                        try stderr.flush();
                        std.process.exit(1);
                    },
                    else => return err,
                };

            if (std.fs.path.dirname(output_path)) |parent_path| {
                std.Io.Dir.cwd().createDirPath(init.io, parent_path) catch |err| {
                    try stderr.print("unable to create {s}: {t}\n", .{ parent_path, err });
                    try stderr.flush();
                    std.process.exit(1);
                };
            }
            std.Io.Dir.cwd().writeFile(init.io, .{
                .sub_path = output_path,
                .data = zig_source,
            }) catch |err| {
                try stderr.print("unable to write {s}: {t}\n", .{ output_path, err });
                try stderr.flush();
                std.process.exit(1);
            };
            try stdout.print("Compiled {s} -> {s}\n", .{ input_path, output_path });
        },
    }
}

fn defaultOutputPath(
    allocator: std.mem.Allocator,
    io: Io,
    input_path: []const u8,
) ![]u8 {
    const project_root = try std.process.currentPathAlloc(io, allocator);
    const absolute_input = try std.fs.path.resolve(allocator, &.{ project_root, input_path });
    const project_relative = try std.fs.path.relative(
        allocator,
        project_root,
        null,
        project_root,
        absolute_input,
    );
    if (isOutsideProjectRoot(project_relative)) return error.InputOutsideProjectRoot;

    const source_relative = if (project_relative.len > 4 and
        std.mem.eql(u8, project_relative[0..3], "src") and
        std.fs.path.isSep(project_relative[3]))
        project_relative[4..]
    else
        project_relative;
    const extension = std.fs.path.extension(source_relative);
    if (!std.mem.eql(u8, extension, ".zx")) return error.InvalidInputExtension;

    const output_name = try std.fmt.allocPrint(
        allocator,
        "{s}.zig",
        .{source_relative[0 .. source_relative.len - extension.len]},
    );
    return std.fs.path.join(allocator, &.{ ".zxc", output_name });
}

fn isOutsideProjectRoot(relative_path: []const u8) bool {
    return std.fs.path.isAbsolute(relative_path) or
        std.mem.eql(u8, relative_path, "..") or
        (relative_path.len > 2 and
            std.mem.eql(u8, relative_path[0..2], "..") and
            std.fs.path.isSep(relative_path[2]));
}

fn writeUsage(writer: *Io.Writer) Io.Writer.Error!void {
    try writer.writeAll(
        \\Usage: zxc <input.zx> [--out output.zig]
        \\Default output: src/<path>.zx -> .zxc/<path>.zig
        \\
    );
}
