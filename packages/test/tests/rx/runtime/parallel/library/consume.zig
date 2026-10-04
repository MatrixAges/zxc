const std = @import("std");
const compiler = @import("compiler");
const importer = @import("import.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 5) return error.ExpectedArtifactExportLanguageAndOutput;

    const language = std.meta.stringToEnum(importer.Language, args[3]) orelse return error.InvalidLanguage;

    var imported = block: {
        var library = decoded: {
            const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(16 * 1024 * 1024));

            defer std.heap.page_allocator.free(bytes);

            const result = try compiler.library.codec.decode(std.heap.page_allocator, bytes);

            @memset(bytes, 0);

            break :decoded result;
        };

        defer library.deinit();

        break :block try importer.link(allocator, &library, args[2], language);
    };

    defer imported.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &imported);

    defer allocator.free(bytes);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4], .data = bytes });
}
