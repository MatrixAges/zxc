const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");
const manifest = @import("generation_manifest.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 2) return error.MissingCommand;

    if (std.mem.eql(u8, args[1], "--lexer")) {
        if (args.len != 4) return error.OutputCountMismatch;

        return @import("generate_lexer.zig").generate(init, args[2], args[3]);
    }

    if (std.mem.eql(u8, args[1], "--standard-abi")) {
        if (args.len != 3) return error.OutputCountMismatch;

        return @import("generate_types.zig").generate(init, args[2]);
    }

    if (std.mem.eql(u8, args[1], "--manifest")) {
        if (args.len != 5) return error.OutputCountMismatch;

        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], allocator, .unlimited);
        const project = try std.json.parseFromSliceLeaky(manifest.Project, allocator, source, .{});

        return generate(init, project, args[3], args[4]);
    }

    return error.UnknownCommand;
}

fn generate(init: std.process.Init, project: manifest.Project, output: []const u8, cache: []const u8) !void {
    if (project.entries.len == 0) return error.EmptyEntrySet;

    const allocator = init.arena.allocator();
    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;

    for (project.roots) |root| try collection.collect(init.io, allocator, root.path, root.prefix, &sources, &modules);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);

    var parsed = try rx.parseModules(allocator, modules.items);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ modules.items[parsed.value.diagnostic.source_index].path, parsed.value.diagnostic.issue.message });

        return error.InvalidParserModule;
    }

    const inputs = try allocator.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.parsed) |*item, source, module| item.* = .{ .path = source.path, .node = module.value.node };

    const interfaces = try allocator.alloc(compiler.project.NativeInterface, project.interfaces.len);

    for (project.interfaces, interfaces) |interface, *target| {
        const source = for (sources.items) |candidate| {
            if (std.mem.eql(u8, candidate.path, interface.path)) break candidate.source;
        } else try std.Io.Dir.cwd().readFileAlloc(init.io, interface.path, allocator, .unlimited);

        target.* = .{ .specifier = interface.specifier, .path = interface.path, .source = source, .module = interface.module };
    }

    const packages = try allocator.alloc(compiler.project.Package, project.packages.len);

    for (project.packages, packages) |package, *target| target.* = .{ .specifier = package.specifier, .entry = package.entry };

    try @import("shared_generation.zig").run(init, project.entries, .{
        .modules = inputs,
        .sources = sources.items,
        .interfaces = interfaces,
        .packages = packages,
    }, output, cache);
}
