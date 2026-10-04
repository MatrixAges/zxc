const std = @import("std");
const archive = @import("../archive.zig");

pub const Receipt = struct { format_version: u32 = 1, archive_sha256: []const u8, files: []const archive.File };

pub fn verify(io: std.Io, allocator: std.mem.Allocator, directory: std.Io.Dir, expected: []const u8) !void {
    if ((try directory.statFile(io, "receipt.json", .{ .follow_symlinks = false })).kind != .file) return error.InvalidPackageReceipt;

    const receipt_file = try directory.openFile(io, "receipt.json", .{ .follow_symlinks = false });

    defer receipt_file.close(io);

    var receipt_buffer: [4096]u8 = undefined;
    var receipt_reader = receipt_file.reader(io, &receipt_buffer);
    const source = try receipt_reader.interface.allocRemaining(allocator, .limited(archive.maximum_unpacked));

    defer allocator.free(source);

    const parsed = try std.json.parseFromSlice(Receipt, allocator, source, .{});

    defer parsed.deinit();

    const receipt = parsed.value;

    if (receipt.format_version != 1 or !std.mem.eql(u8, receipt.archive_sha256, expected) or receipt.files.len > archive.maximum_entries) return error.InvalidPackageReceipt;

    var names: std.StringHashMapUnmanaged(usize) = .empty;

    defer names.deinit(allocator);

    for (receipt.files, 0..) |file, index| {
        const path = try @import("../archive/path.zig").normalize(file.path, false);

        if (!std.mem.eql(u8, path, file.path) or file.sha256.len != 64) return error.InvalidPackageReceipt;

        const entry = try names.getOrPut(allocator, path);

        if (entry.found_existing) return error.InvalidPackageReceipt;

        entry.value_ptr.* = index;
    }

    var package = try directory.openDir(io, "package", .{ .iterate = true, .follow_symlinks = false });

    defer package.close(io);

    var walker = try package.walk(allocator);

    defer walker.deinit();

    var count: usize = 0;
    var visited: usize = 0;
    var total: u64 = 0;

    while (try walker.next(io)) |entry| {
        if (visited == archive.maximum_entries) return error.TooManyPackageEntries;

        visited += 1;

        if (entry.kind == .directory) continue;
        if (entry.kind != .file) return error.CorruptPackageStore;

        const path = try allocator.dupe(u8, entry.path);

        defer allocator.free(path);

        for (path) |*byte| if (byte.* == std.fs.path.sep) {
            byte.* = '/';
        };

        const index = names.get(path) orelse return error.CorruptPackageStore;
        const expected_file = receipt.files[index];
        const file = try package.openFile(io, entry.path, .{});

        defer file.close(io);

        const stat = try file.stat(io);

        if (std.Io.File.Permissions.has_executable_bit and (stat.permissions.toMode() & 0o100 != 0) != expected_file.executable) return error.CorruptPackageStore;

        var buffer: [65536]u8 = undefined;
        var reader_buffer: [65536]u8 = undefined;
        var reader = file.reader(io, &reader_buffer);
        var hash = std.crypto.hash.sha2.Sha256.init(.{});

        while (true) {
            const size = try reader.interface.readSliceShort(&buffer);

            if (size == 0) break;
            if (size > archive.maximum_unpacked - total) return error.CorruptPackageStore;

            total += size;

            hash.update(buffer[0..size]);
        }

        const actual = std.fmt.bytesToHex(hash.finalResult(), .lower);

        if (!std.mem.eql(u8, &actual, expected_file.sha256)) return error.CorruptPackageStore;

        count += 1;
    }

    if (count != receipt.files.len) return error.CorruptPackageStore;
}
