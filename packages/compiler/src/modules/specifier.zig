const std = @import("std");

pub const Kind = enum { file, package, zig, c, standard, legacy_library };

pub fn classify(specifier: []const u8) error{InvalidSpecifier}!Kind {
    if (specifier.len == 0 or std.mem.indexOfAny(u8, specifier, "\\\x00\r\n\t ") != null) return error.InvalidSpecifier;

    if (std.mem.indexOfScalar(u8, specifier, ':')) |separator| {
        if (separator + 1 == specifier.len or std.mem.indexOfScalar(u8, specifier[separator + 1 ..], ':') != null) return error.InvalidSpecifier;

        const prefix = specifier[0..separator];

        if (std.mem.eql(u8, prefix, "zig")) return .zig;
        if (std.mem.eql(u8, prefix, "c")) return .c;
        if (std.mem.eql(u8, prefix, "std")) return .standard;
        if (std.mem.eql(u8, prefix, "lib")) return .legacy_library;

        return error.InvalidSpecifier;
    }

    if (std.mem.startsWith(u8, specifier, "./") or std.mem.startsWith(u8, specifier, "../") or std.mem.startsWith(u8, specifier, "@/")) return .file;
    if (specifier[0] == '/' or specifier[specifier.len - 1] == '/') return error.InvalidSpecifier;

    var segments = std.mem.splitScalar(u8, specifier, '/');

    while (segments.next()) |segment| {
        if (segment.len == 0 or std.mem.eql(u8, segment, ".") or std.mem.eql(u8, segment, "..")) return error.InvalidSpecifier;
    }

    return .package;
}
