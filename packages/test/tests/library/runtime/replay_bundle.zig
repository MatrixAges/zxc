const std = @import("std");
const compiler = @import("compiler");
const save = @import("save.zig");
const Module = struct { name: []const u8, path: []const u8, imports: []const []const u8 };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedArtifactAndDirectory;

    var bundle = block: {
        const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(16 * 1024 * 1024));

        defer std.heap.page_allocator.free(bytes);

        var library = try compiler.library.codec.decode(std.heap.page_allocator, bytes);

        defer library.deinit();
        @memset(bytes, 0);

        break :block try compiler.zig.emitLibrary(allocator, &library);
    };

    defer bundle.deinit();

    var output = save.Output{ .io = init.io, .allocator = allocator, .directory = args[2] };
    var modules: std.ArrayList(Module) = .empty;

    for (bundle.public_modules) |public| {
        const path = try std.fmt.allocPrint(allocator, "{s}.zig", .{public.file.name});

        try output.file(path, public.file.source);
        try modules.append(allocator, .{ .name = public.name, .path = path, .imports = public.file.imports });
    }

    for (bundle.modules) |module| {
        const path = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name});

        try output.file(path, module.source);
        try modules.append(allocator, .{ .name = module.name, .path = path, .imports = module.imports });
    }

    try output.file("native.json", try std.json.Stringify.valueAlloc(allocator, bundle.native_modules.jsonRows(), .{ .whitespace = .indent_2 }));
    try output.file("types.zig", bundle.types);
    try output.file("modules.json", try std.json.Stringify.valueAlloc(allocator, modules.items, .{ .whitespace = .indent_2 }));
}
