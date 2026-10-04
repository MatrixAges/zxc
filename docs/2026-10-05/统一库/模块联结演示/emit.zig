const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedLibraryAndOutput;

    var bundle = block: {
        var library = library_block: {
            const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(64 * 1024 * 1024));

            defer std.heap.page_allocator.free(bytes);

            break :library_block try compiler.library.codec.decode(std.heap.page_allocator, bytes);
        };

        defer library.deinit();

        break :block try compiler.zig.emitLibrary(allocator, &library);
    };

    defer bundle.deinit();

    const Module = struct { name: []const u8, path: []const u8, imports: []const []const u8 };
    var modules: std.ArrayList(Module) = .empty;

    for (bundle.public_modules) |public_module| {
        const file = public_module.file;
        const public_path = try std.fmt.allocPrint(allocator, "{s}.zig", .{file.name});

        try write(init.io, allocator, args[2], public_path, file.source);
        try modules.append(allocator, .{ .name = public_module.name, .path = public_path, .imports = file.imports });
    }

    for (bundle.modules) |file| {
        const module_path = try std.fmt.allocPrint(allocator, "{s}.zig", .{file.name});

        try write(init.io, allocator, args[2], module_path, file.source);
        try modules.append(allocator, .{ .name = file.name, .path = module_path, .imports = file.imports });
    }

    try write(init.io, allocator, args[2], "abi.zig", bundle.types);
    try write(init.io, allocator, args[2], "modules.json", try std.json.Stringify.valueAlloc(allocator, modules.items, .{ .whitespace = .indent_2 }));

    std.debug.print("public={d} internal={d}\n", .{ bundle.public_modules.len, bundle.modules.len });
}

fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, text: []const u8) !void {
    const path = try std.fs.path.join(allocator, &.{ directory, name });
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, text);
    try file.replace(io);
}
