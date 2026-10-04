const std = @import("std");
const Library = @import("../compiled.zig").Library;

pub fn scope(allocator: std.mem.Allocator, instance: []const u8, value: []const u8) std.mem.Allocator.Error![]const u8 {
    return std.fmt.allocPrint(allocator, "library:{d}:{s}:{s}", .{ instance.len, instance, value });
}

pub fn store(allocator: std.mem.Allocator, instance: []const u8, path: []const u8) std.mem.Allocator.Error![]const u8 {
    return std.fmt.allocPrint(allocator, "store.library:{d}:{s}:{s}", .{ instance.len, instance, path["store.".len..] });
}

pub fn nativeKey(allocator: std.mem.Allocator, library: Library, key: []const u8) std.mem.Allocator.Error![]const u8 {
    for (library.program.native_modules) |module| {
        if (std.mem.eql(u8, module.key(), key) and std.mem.startsWith(u8, module.specifier, "std:")) return key;
    }

    return scope(allocator, library.instance, key);
}

pub fn nativeName(allocator: std.mem.Allocator, instance: []const u8, name: []const u8) std.mem.Allocator.Error![]const u8 {
    const key = try scope(allocator, instance, name);

    defer allocator.free(key);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(key, &digest, .{});

    return std.fmt.allocPrint(allocator, "library_native_{s}", .{std.fmt.bytesToHex(digest, .lower)});
}
