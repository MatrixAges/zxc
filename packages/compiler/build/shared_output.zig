const std = @import("std");
const compiler = @import("compiler");
const layout = @import("partition/layout.zig");
const parallel = @import("parallel.zig");

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

        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name}), .source = adapter.written() });
    }

    try files.appendSlice(allocator, top.items);

    // Partitions forward their panics to a handler the shared top level defines.
    if (partitions != 0) try root.writer.writeAll("\ncomptime {\n    @import(\"zxc_bridge\").exportPanic();\n}\n");
    try files.append(allocator, .{ .path = "root.zig", .source = root.written() });
    if (partitions == 0) try files.appendSlice(allocator, functions.items) else try files.appendSlice(allocator, try layout.plan(io, allocator, functions.items, top.items, partitions));
    try mirror(io, allocator, output, files.items);
}

pub const fingerprint_name = ".zxc-inputs";
const file_manifest = @import("partition/file_manifest.zig");
const manifest_name = file_manifest.name;

/// Records the content hash of every written file in a manifest, so a later run compares hashes instead of
/// reading files back, and removes exactly the files the previous run wrote and this one does not. Without a
/// manifest the directory is walked once and every file not generated now is removed.
fn mirror(io: std.Io, allocator: std.mem.Allocator, output: []const u8, files: []const layout.File) !void {
    const cwd = std.Io.Dir.cwd();

    try cwd.createDirPath(io, output);

    var directory = try cwd.openDir(io, output, .{ .iterate = true });

    defer directory.close(io);

    const previous = try recorded(io, allocator, directory);
    var manifest: std.Io.Writer.Allocating = .init(allocator);
    var parents: compiler.bytes.Map(void) = .empty;
    // Runs list the same files in the same order, so the previous hash is usually found at the same position;
    // paths are looked up only when the lists differ.
    var aligned = if (previous) |known| known.paths.len == files.len else false;
    var by_path: ?compiler.bytes.Map(u64) = null;

    try remove(io, directory, manifest_name);

    const arenas = try parallel.Arenas.init(io, allocator, files.len);

    defer arenas.deinit();

    const hashing = Hashing{ .files = files, .hashes = try allocator.alloc(u64, files.len) };

    try parallel.each(arenas, files.len, &hashing);
    try manifest.writer.ensureUnusedCapacity(files.len * 64);

    for (files, hashing.hashes, 0..) |file, hash, index| {
        try manifest.writer.print("{x:0>16} {s}\n", .{ hash, file.path });

        if (previous) |known| {
            const before = if (index < known.paths.len and compiler.bytes.equal(known.paths[index], file.path)) known.hashes[index] else found: {
                aligned = false;

                if (by_path == null) by_path = try byPath(allocator, known);

                break :found by_path.?.get(file.path);
            };

            if (before == hash) continue;
        }

        if (std.fs.path.dirname(file.path)) |parent| {
            if (!(try parents.getOrPut(allocator, parent)).found_existing) try directory.createDirPath(io, parent);
        }

        try directory.writeFile(io, .{ .sub_path = file.path, .data = file.source });
    }

    var stale: std.ArrayList([]const u8) = .empty;

    if (previous) |known| {
        if (!aligned) {
            const wanted = try generated(allocator, files);

            for (known.paths) |path| if (!wanted.contains(path)) try stale.append(allocator, path);
        }
    } else {
        const wanted = try generated(allocator, files);
        var walker = try directory.walk(allocator);

        defer walker.deinit();

        while (try walker.next(io)) |entry| {
            if (entry.kind != .file or std.mem.eql(u8, entry.path, fingerprint_name) or wanted.contains(entry.path)) continue;
            try stale.append(allocator, try allocator.dupe(u8, entry.path));
        }
    }

    for (stale.items) |path| try remove(io, directory, path);
    try directory.writeFile(io, .{ .sub_path = manifest_name, .data = manifest.written() });
}

/// The content hash of every file, computed on all cores.
const Hashing = struct {
    files: []const layout.File,
    hashes: []u64,
    pub fn step(self: *const Hashing, _: std.mem.Allocator, index: usize) !void {
        self.hashes[index] = compiler.bytes.hash(0, self.files[index].source);
    }
};

fn recorded(io: std.Io, allocator: std.mem.Allocator, directory: std.Io.Dir) !?file_manifest.Listed {
    const text = directory.readFileAlloc(io, manifest_name, allocator, .unlimited) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };

    return try file_manifest.list(allocator, text);
}

fn byPath(allocator: std.mem.Allocator, listed: file_manifest.Listed) !compiler.bytes.Map(u64) {
    var result: compiler.bytes.Map(u64) = .empty;

    try result.ensureTotalCapacity(allocator, @intCast(listed.paths.len));
    for (listed.paths, listed.hashes) |path, hash| result.putAssumeCapacity(path, hash);

    return result;
}

fn generated(allocator: std.mem.Allocator, files: []const layout.File) !compiler.bytes.Map(void) {
    var result: compiler.bytes.Map(void) = .empty;

    try result.ensureTotalCapacity(allocator, @intCast(files.len));
    for (files) |file| result.putAssumeCapacity(file.path, {});

    return result;
}

fn remove(io: std.Io, directory: std.Io.Dir, path: []const u8) !void {
    directory.deleteFile(io, path) catch |err| switch (err) {
        error.FileNotFound => {},
        else => return err,
    };
}
