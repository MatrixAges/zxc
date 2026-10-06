const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub const Options = struct {
    digest: []const u8,
    resources_digest: []const u8,
    zig_digest: []const u8,
    zig_version: []const u8,
    zig_host: []const u8,
    zig_directory: []const u8,
    zig_format: enum { zip, xz },
};

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    var declarations: std.ArrayList(node.Declaration) = .empty;

    for ([_]struct { name: []const u8, file: []const u8 }{
        .{ .name = "archive", .file = "resources.tar.gz" },
        .{ .name = "zig_archive", .file = "zig.archive" },
        .{ .name = "index", .file = "index.json" },
    }) |entry| {
        try declarations.append(builder.allocator, .{ .constant = .{ .name = entry.name, .value = try builder.builtin(.embedFile, &.{try builder.string(entry.file)}), .exported = true } });
    }

    inline for (.{ "digest", "resources_digest", "zig_digest", "zig_version", "zig_host", "zig_directory" }) |name| {
        try declarations.append(builder.allocator, .{ .constant = .{ .name = name, .value = try builder.string(@field(options, name)), .exported = true } });
    }

    try declarations.append(builder.allocator, .{ .constant = .{ .name = "zig_format", .value = try builder.expression(.{ .enum_literal = @tagName(options.zig_format) }), .exported = true } });

    return @import("../render.zig").render(allocator, declarations.items);
}
