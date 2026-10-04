const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const Manifest = struct { entry: []const u8, modules: []const []const u8, stores: []const []const u8, functions: []const []const u8 };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedManifestAndOutputDirectory;

    const root = std.fs.path.dirname(args[1]) orelse ".";
    const text = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));
    const manifest = try std.json.parseFromSliceLeaky(Manifest, allocator, text, .{});
    var source_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const sources_allocator = source_arena.allocator();
    const modules = try loadXml(init.io, sources_allocator, root, manifest.modules);
    const stores = try loadXml(init.io, sources_allocator, root, manifest.stores);
    const functions = try sources_allocator.alloc(compiler.project.Source, manifest.functions.len);

    for (manifest.functions, functions) |path, *source| source.* = .{ .path = path, .source = try read(init.io, sources_allocator, root, path) };

    var inferred = try analysis.project.infer(std.heap.page_allocator, .{ .entry = manifest.entry, .modules = modules, .stores = stores, .sources = functions });

    source_arena.deinit();
    defer inferred.deinit();

    if (inferred.value == .diagnostic) {
        const issue = inferred.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidProject;
    }

    const contract = inferred.value.contract;
    var bundle = try compiler.zig.emitBundle(allocator, contract.program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().createDirPath(init.io, args[2]);
    try write(init.io, allocator, args[2], "application.zig", bundle.source);
    try write(init.io, allocator, args[2], "types.zig", bundle.types);
    try write(init.io, allocator, args[2], "slots.json", try std.json.Stringify.valueAlloc(allocator, contract.program.stores, .{ .whitespace = .indent_2 }));

    var index: usize = 0;

    for (contract.store_definitions) |definition| for (definition.objects) |object| {
        var initial = try compiler.zig.emitBundle(allocator, object.initial);

        defer initial.deinit(allocator);

        try write(init.io, allocator, args[2], try std.fmt.allocPrint(allocator, "initial_{d}.zig", .{index}), initial.source);

        index += 1;
    };
}

fn read(io: std.Io, allocator: std.mem.Allocator, root: []const u8, path: []const u8) ![]const u8 {
    return std.Io.Dir.cwd().readFileAlloc(io, try std.fs.path.join(allocator, &.{ root, path }), allocator, .limited(1024 * 1024));
}

fn loadXml(io: std.Io, allocator: std.mem.Allocator, root: []const u8, paths: []const []const u8) ![]const rx.ModuleSource {
    const sources = try allocator.alloc(rx.ModuleSource, paths.len);

    for (paths, sources) |path, *source| {
        const parsed = try rx.parseXml(allocator, try read(io, allocator, root, path));

        if (parsed.value == .diagnostic) return error.InvalidXml;

        source.* = .{ .path = path, .node = parsed.value.node };
    }

    return sources;
}

fn write(io: std.Io, allocator: std.mem.Allocator, root: []const u8, name: []const u8, source: []const u8) !void {
    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = try std.fs.path.join(allocator, &.{ root, name }), .data = source });
}
