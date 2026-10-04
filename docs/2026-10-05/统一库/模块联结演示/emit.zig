const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedLibraryAndOutput;

    var library = block: {
        const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(64 * 1024 * 1024));

        defer std.heap.page_allocator.free(bytes);

        break :block try compiler.library.codec.decode(allocator, bytes);
    };

    defer library.deinit();

    const Module = struct { name: []const u8, path: []const u8, imports: []const []const u8 };
    var modules: std.ArrayList(Module) = .empty;

    for (library.exports, 0..) |exported, index| {
        var analyzed = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = try library.module(index) }, .nominal_types = library.nominal_types };

        defer analyzed.deinit();

        var bundle = try compiler.zig.emitModules(allocator, &analyzed);

        defer bundle.deinit();

        const public_path = try std.fmt.allocPrint(allocator, "public_{d}.zig", .{index});

        try write(init.io, allocator, args[2], public_path, bundle.entry.source);
        try modules.append(allocator, .{ .name = exported.name, .path = public_path, .imports = try copy(allocator, bundle.entry.imports) });

        for (bundle.modules) |module| {
            var found = false;

            for (modules.items) |existing| if (std.mem.eql(u8, existing.name, module.name)) {
                found = true;

                break;
            };

            if (found) continue;

            const module_path = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name});

            try write(init.io, allocator, args[2], module_path, module.source);
            try modules.append(allocator, .{ .name = try allocator.dupe(u8, module.name), .path = module_path, .imports = try copy(allocator, module.imports) });
        }

        try write(init.io, allocator, args[2], "abi.zig", bundle.types);
    }

    try write(init.io, allocator, args[2], "modules.json", try std.json.Stringify.valueAlloc(allocator, modules.items, .{ .whitespace = .indent_2 }));
    try write(init.io, allocator, args[2], "exports.json", try std.json.Stringify.valueAlloc(allocator, library.exports, .{ .whitespace = .indent_2 }));

    std.debug.print("exports={d} types={d} functions={d}\n", .{ library.exports.len, library.program.types.len, library.program.functions.len });
}

fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, text: []const u8) !void {
    const path = try std.fs.path.join(allocator, &.{ directory, name });
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, text);
    try file.replace(io);
}

fn copy(allocator: std.mem.Allocator, items: []const []const u8) ![]const []const u8 {
    const result = try allocator.alloc([]const u8, items.len);

    for (items, result) |item, *owned| owned.* = try allocator.dupe(u8, item);

    return result;
}
