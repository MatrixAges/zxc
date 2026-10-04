const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 5) return error.ExpectedArtifactSourcesAndOutput;

    var analyzed = block: {
        const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(64 * 1024 * 1024));
        var library = try compiler.library.codec.decode(std.heap.page_allocator, bytes);

        defer library.deinit();

        const packages = try allocator.alloc(compiler.project.Package, library.exports.len);

        for (library.exports, packages) |exported, *package| package.* = .{
            .specifier = try std.fmt.allocPrint(allocator, "workflow/{s}", .{exported.name}),
            .compiled = .{ .instance = "workflow@1.0.0", .artifact = args[1], .name = exported.name },
        };

        const sources = [_]compiler.project.Source{
            .{ .path = args[2], .source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], allocator, .limited(1024 * 1024)) },
            .{ .path = try std.fs.path.join(allocator, &.{ std.fs.path.dirname(args[2]).?, "types.zx" }), .source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[3], allocator, .limited(1024 * 1024)) },
        };

        break :block try compiler.analyzeProject(allocator, &sources, .{
            .entry = args[2],
            .packages = packages,
            .compiled_libraries = &.{.{ .instance = "workflow@1.0.0", .artifact = args[1], .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types }},
        });
    };

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ analyzed.value.diagnostic.code, analyzed.value.diagnostic.message });

        return error.InvalidConsumer;
    }

    var bundle = try compiler.zig.emitModules(allocator, &analyzed);

    defer bundle.deinit();

    const Module = struct { name: []const u8, path: []const u8, imports: []const []const u8 };
    var modules: std.ArrayList(Module) = .empty;

    try write(init.io, allocator, args[4], "root.zig", bundle.entry.source);
    try write(init.io, allocator, args[4], "abi.zig", bundle.types);
    try modules.append(allocator, .{ .name = "library", .path = "root.zig", .imports = bundle.entry.imports });

    for (bundle.modules) |module| {
        const path = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name});

        try write(init.io, allocator, args[4], path, module.source);
        try modules.append(allocator, .{ .name = module.name, .path = path, .imports = module.imports });
    }

    try write(init.io, allocator, args[4], "modules.json", try std.json.Stringify.valueAlloc(allocator, modules.items, .{ .whitespace = .indent_2 }));

    std.debug.print("linked functions={d} generated modules={d}\n", .{ analyzed.value.ir.functions.len, bundle.modules.len });
}

fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, text: []const u8) !void {
    const path = try std.fs.path.join(allocator, &.{ directory, name });
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, text);
    try file.replace(io);
}
