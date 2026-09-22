const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    var stdout_buffer: [4096]u8 = undefined;
    var stderr_buffer: [4096]u8 = undefined;
    var stdout_file = std.Io.File.Writer.init(.stdout(), init.io, &stdout_buffer);
    var stderr_file = std.Io.File.Writer.init(.stderr(), init.io, &stderr_buffer);
    const stdout = &stdout_file.interface;
    const stderr = &stderr_file.interface;

    defer stdout.flush() catch {};
    defer stderr.flush() catch {};

    if (args.len == 2 and std.mem.eql(u8, args[1], "--help")) {
        try usage(stdout);

        return;
    }

    const formatting = args.len > 1 and std.mem.eql(u8, args[1], "fmt");
    const source_index: usize = if (formatting) 2 else 1;

    if (args.len <= source_index) {
        try usage(stderr);
        try stderr.flush();

        std.process.exit(1);
    }

    const input_path = args[source_index];
    const extra = args[source_index + 1 ..];
    const check = formatting and extra.len == 1 and std.mem.eql(u8, extra[0], "--check");
    const write = formatting and extra.len == 1 and std.mem.eql(u8, extra[0], "--write");
    const output = !formatting and extra.len == 2 and std.mem.eql(u8, extra[0], "--out");

    if (extra.len != 0 and !check and !write and !output) {
        try usage(stderr);
        try stderr.flush();

        std.process.exit(1);
    }

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, input_path, allocator, .limited(16 * 1024 * 1024));
    const root_dir = try std.Io.Dir.cwd().realPathFileAlloc(init.io, ".", allocator);
    const sources = if (formatting) &.{} else try readSources(init.io, allocator, input_path, source, root_dir);
    const result = if (formatting) try compiler.format(allocator, source, input_path) else try compiler.compileProject(allocator, sources, .{ .entry = input_path, .root_dir = root_dir });

    defer result.deinit(allocator);

    switch (result) {
        .diagnostic => |issue| {
            const failed_source = if (issue.source_index) |index| sources[index].source else source;
            const failed_path = if (issue.source_index) |index| sources[index].path else input_path;
            const location = zx.source.locate(failed_source, issue.span.start);

            try stderr.print("{s}:{d}:{d}: {t}: {s}\n", .{ failed_path, location.line, location.column, issue.code, issue.message });
            try stderr.flush();

            std.process.exit(1);
        },
        .source => |text| {
            if (check) {
                if (!std.mem.eql(u8, source, text)) {
                    try stderr.print("{s}: blank lines require formatting\n", .{input_path});
                    try stderr.flush();

                    std.process.exit(1);
                }
            } else if (write or output) {
                try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = if (write) input_path else extra[1], .data = text });
            } else {
                try stdout.writeAll(text);
            }
        },
    }
}

fn usage(writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll("zxc <source.zx> [--out output.zig]\nzxc fmt <source.zx> [--check | --write]\n");
}

fn readSources(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, source: []const u8, root_dir: []const u8) ![]const compiler.project.Source {
    var sources: std.ArrayList(compiler.project.Source) = .empty;

    try sources.append(allocator, .{ .path = try std.fs.path.resolve(allocator, &.{ root_dir, entry }), .source = source });

    var index: usize = 0;

    while (index < sources.items.len) : (index += 1) {
        const item = sources.items[index];
        var parsed = try compiler.parse(allocator, item.source, item.path);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) continue;

        for (parsed.value.parsed.ast.imports) |imported| {
            var reporter: zx.Reporter = .{};

            const path = compiler.project.resolvePath(allocator, item.path, imported.path, root_dir, &reporter, imported.span) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                continue;
            };

            var found = false;

            for (sources.items) |existing| if (std.mem.eql(u8, existing.path, path)) {
                found = true;

                break;
            };

            if (found) continue;

            const text = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(16 * 1024 * 1024)) catch |err| switch (err) {
                error.FileNotFound => continue,
                else => return err,
            };

            try sources.append(allocator, .{ .path = path, .source = text });
        }
    }

    return sources.toOwnedSlice(allocator);
}
