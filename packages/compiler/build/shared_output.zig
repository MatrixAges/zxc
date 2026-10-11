const std = @import("std");
const compiler = @import("compiler");
const layout = @import("partition/layout.zig");

/// Writes the generated tree. With `partitions` set, function files are spread over that many separately
/// compiled partitions. Only changed files are rewritten and files no longer generated are removed, so an
/// output directory reused across runs keeps unchanged files byte- and timestamp-stable for Zig's cache.
pub fn write(io: std.Io, allocator: std.mem.Allocator, output: []const u8, bundle: compiler.zig.LibraryBundle, partitions: u32) !void {
    var files: std.ArrayList(layout.File) = .empty;
    var functions: std.ArrayList(layout.File) = .empty;
    var top: std.ArrayList(layout.File) = .empty;
    var root: std.Io.Writer.Allocating = .init(allocator);

    try files.append(allocator, .{ .path = "types.zig", .source = bundle.types });

    for (bundle.modules) |module| {
        const file = layout.File{ .path = module.name, .source = module.source };

        if (std.mem.startsWith(u8, module.name, "zxc_module_")) try functions.append(allocator, file) else try top.append(allocator, file);
    }

    for (bundle.public_modules) |module| {
        const name = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.file.name});

        try top.append(allocator, .{ .path = name, .source = module.file.source });
        try root.writer.print("pub const {f} = @import(\"{f}\");\n", .{ std.zig.fmtId(module.name), std.zig.fmtString(name) });

        var adapter: std.Io.Writer.Allocating = .init(allocator);

        try adapter.writer.print("const entry = @import(\"generated\").{f};\n\n", .{std.zig.fmtId(module.name)});

        for ([_][]const u8{ "Input", "Output", "execute", "requires_io", "requires_process", "input_shape", "output_shape" }) |declaration| {
            try adapter.writer.print("pub const {s} = entry.{s};\n", .{ declaration, declaration });
        }

        if (module.value_entry) {
            try adapter.writer.writeAll("pub const executeValue = entry.executeValue;\n");
        }

        if (module.buffered_entry) {
            try adapter.writer.writeAll("pub const executeBuffered = entry.executeBuffered;\npub const buffer_lanes = entry.buffer_lanes;\n");
        }

        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name}), .source = adapter.written() });
    }

    try files.appendSlice(allocator, top.items);
    try files.append(allocator, .{ .path = "root.zig", .source = root.written() });

    if (partitions == 0) try files.appendSlice(allocator, functions.items) else try files.appendSlice(allocator, try layout.plan(allocator, functions.items, top.items, partitions));

    try mirror(io, allocator, output, files.items);
}

pub const fingerprint_name = ".zxc-inputs";

fn mirror(io: std.Io, allocator: std.mem.Allocator, output: []const u8, files: []const layout.File) !void {
    const cwd = std.Io.Dir.cwd();
    var wanted: std.StringHashMapUnmanaged(void) = .empty;

    try cwd.createDirPath(io, output);

    var directory = try cwd.openDir(io, output, .{ .iterate = true });

    defer directory.close(io);

    for (files) |file| {
        try wanted.put(allocator, file.path, {});

        if (std.fs.path.dirname(file.path)) |parent| try directory.createDirPath(io, parent);

        const current = directory.readFileAlloc(io, file.path, allocator, .limited(file.source.len + 1)) catch |err| switch (err) {
            error.FileNotFound, error.StreamTooLong => null,
            else => return err,
        };

        if (current != null and std.mem.eql(u8, current.?, file.source)) continue;

        try directory.writeFile(io, .{ .sub_path = file.path, .data = file.source });
    }

    var stale: std.ArrayList([]const u8) = .empty;
    var walker = try directory.walk(allocator);

    defer walker.deinit();

    while (try walker.next(io)) |entry| {
        if (entry.kind != .file or std.mem.eql(u8, entry.path, fingerprint_name) or wanted.contains(entry.path)) continue;

        try stale.append(allocator, try allocator.dupe(u8, entry.path));
    }

    for (stale.items) |path| try directory.deleteFile(io, path);
}
