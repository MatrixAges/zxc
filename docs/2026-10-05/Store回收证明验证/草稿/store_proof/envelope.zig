const std = @import("std");
const compiler = @import("compiler");

pub fn create(allocator: std.mem.Allocator, library: *const compiler.library.Result, marker: []const u8) ![]u8 {
    const payload = try std.json.Stringify.valueAlloc(allocator, .{
        .ir_version = library.program.version,
        .program = library.program,
        .exports = library.exports,
        .nominal_types = library.nominal_types,
        .store_initializers = library.store_initializers,
    }, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, "{s}{s}\n{s}", .{ marker, std.fmt.bytesToHex(digest, .lower), payload });
}
