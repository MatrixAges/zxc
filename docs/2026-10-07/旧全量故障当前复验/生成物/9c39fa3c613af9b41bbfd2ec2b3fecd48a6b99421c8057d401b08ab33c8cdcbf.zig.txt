const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    var directory = try std.Io.Dir.cwd().openDir(init.io, args[1], .{ .iterate = true });

    defer directory.close(init.io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;

    while (try walker.next(init.io)) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.path, ".zx")) continue;

        const path = try allocator.dupe(u8, entry.path);

        if (std.fs.path.sep == '\\') for (path) |*byte| if (byte.* == '\\') {
            byte.* = '/';
        };

        try sources.append(allocator, .{ .path = path, .source = try directory.readFileAlloc(init.io, entry.path, allocator, .unlimited) });
    }

    std.mem.sort(compiler.project.Source, sources.items, {}, lessThan);

    var analyzed = try compiler.analyzeProject(allocator, sources.items, .{ .entry = "scan.zx" });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

        return error.InvalidLexerSource;
    }

    const output = try compiler.zig.emit(allocator, analyzed.value.ir);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = output });
}

fn lessThan(_: void, left: compiler.project.Source, right: compiler.project.Source) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}
