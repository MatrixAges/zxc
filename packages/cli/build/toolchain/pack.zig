const std = @import("std");
const model = @import("manifest.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 5) return error.InvalidArguments;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const manifest = try std.json.parseFromSliceLeaky(model.Manifest, allocator, source, .{});
    const official = try @import("archive.zig").find(allocator, manifest.host);
    const release = official.release;
    const output_directory = args[4];

    try std.Io.Dir.cwd().createDirPath(init.io, output_directory);
    try @import("archive.zig").prepare(init.io, allocator, release, args[3], try std.fs.path.join(allocator, &.{ output_directory, "zig.archive" }));

    const archive_path = try std.fs.path.join(allocator, &.{ output_directory, "resources.tar.gz" });
    const file = try std.Io.Dir.cwd().createFile(init.io, archive_path, .{});

    defer file.close(init.io);

    var output_buffer: [65536]u8 = undefined;
    var hash_buffer: [65536]u8 = undefined;
    var output = file.writer(init.io, &output_buffer);
    var hashed = std.Io.Writer.Hashed(std.crypto.hash.sha2.Sha256).initHasher(&output.interface, .init(.{}), &hash_buffer);
    const compression_buffer = try allocator.alloc(u8, std.compress.flate.max_window_len);
    var compressed = try std.compress.flate.Compress.init(&hashed.writer, compression_buffer, .gzip, .default);
    var archive = std.tar.Writer{ .underlying_writer = &compressed.writer };

    for (manifest.files) |entry| {
        const input = try std.Io.Dir.cwd().openFile(init.io, entry.source, .{});

        defer input.close(init.io);

        var input_buffer: [65536]u8 = undefined;
        var reader = input.reader(init.io, &input_buffer);

        try archive.writeFileStream(entry.destination, try reader.getSize(), &reader.interface, .{ .mode = 0o644, .mtime = 0 });
    }

    try archive.finishPedantically();
    try compressed.finish();
    try hashed.writer.flush();
    try output.interface.flush();

    const resources_digest = std.fmt.bytesToHex(hashed.hasher.finalResult(), .lower);
    var identity = std.crypto.hash.sha2.Sha256.init(.{});

    identity.update("zxc-toolchain-v1");
    identity.update(release.archive_sha256);
    identity.update(&resources_digest);

    const digest = std.fmt.bytesToHex(identity.finalResult(), .lower);
    const filename = std.fs.path.basename(release.archive);
    const is_zip = std.mem.endsWith(u8, filename, ".zip");
    const directory = filename[0 .. filename.len - @as(usize, if (is_zip) 4 else 7)];
    const index = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], allocator, .limited(16 * 1024 * 1024));

    try write(init.io, allocator, output_directory, "index.json", index);

    const resources = try @import("genz").host.resources.render(allocator, .{
        .digest = &digest,
        .resources_digest = &resources_digest,
        .zig_digest = release.archive_sha256,
        .zig_version = official.version,
        .zig_host = release.host,
        .zig_directory = directory,
        .zig_format = if (is_zip) .zip else .xz,
    });

    try write(init.io, allocator, output_directory, "resources.zig", resources);
}

fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, bytes: []const u8) !void {
    const file = try std.Io.Dir.cwd().createFile(io, try std.fs.path.join(allocator, &.{ directory, name }), .{});

    defer file.close(io);

    try file.writeStreamingAll(io, bytes);
}
