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
        if (args.len != 5 and !(args.len == 7 and std.mem.eql(u8, args[5], "--partitions"))) return error.OutputCountMismatch;

        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], allocator, .unlimited);
        const project = try std.json.parseFromSliceLeaky(manifest.Project, allocator, source, .{});
        const partitions = if (args.len == 7) try std.fmt.parseInt(u32, args[6], 10) else 0;

        return generate(init, project, source, args[3], args[4], partitions);
    }

    return error.UnknownCommand;
}

fn generate(init: std.process.Init, project: manifest.Project, manifest_source: []const u8, output: []const u8, cache: []const u8, partitions: u32) !void {
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

    const generator = try @import("generator_digest.zig").create(init.io, allocator);
    const inputs_digest = fingerprint(generator, manifest_source, partitions, sources.items, modules.items, interfaces);

    // An output directory reused across runs already holds the result when nothing it depends on changed.
    if (try current(init.io, allocator, output, inputs_digest)) return;

    const recorded = try std.fs.path.join(allocator, &.{ output, shared_output.fingerprint_name });

    std.Io.Dir.cwd().deleteFile(init.io, recorded) catch |err| switch (err) {
        error.FileNotFound => {},
        else => return err,
    };

    try @import("shared_generation.zig").run(init, project.entries, .{
        .modules = inputs,
        .sources = sources.items,
        .interfaces = interfaces,
        .packages = packages,
    }, output, cache, generator, partitions);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = recorded, .data = &std.fmt.bytesToHex(inputs_digest, .lower) });
}

const shared_output = @import("shared_output.zig");

fn fingerprint(generator: [32]u8, manifest_source: []const u8, partitions: u32, sources: []const compiler.project.Source, modules: []const rx.TextSource, interfaces: []const compiler.project.NativeInterface) [32]u8 {
    var hash = std.crypto.hash.Blake3.init(.{});

    hash.update(&generator);
    field(&hash, manifest_source);
    hash.update(std.mem.asBytes(&partitions));

    for (sources) |source| {
        field(&hash, source.path);
        field(&hash, source.source);
    }

    for (modules) |module| {
        field(&hash, module.path);
        field(&hash, module.source);
    }

    for (interfaces) |interface| field(&hash, interface.source);

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    return digest;
}

fn field(hash: *std.crypto.hash.Blake3, bytes: []const u8) void {
    hash.update(std.mem.asBytes(&bytes.len));
    hash.update(bytes);
}

fn current(io: std.Io, allocator: std.mem.Allocator, output: []const u8, digest: [32]u8) !bool {
    const path = try std.fs.path.join(allocator, &.{ output, shared_output.fingerprint_name });
    const recorded = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(65)) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => return err,
    };

    return std.mem.eql(u8, recorded, &std.fmt.bytesToHex(digest, .lower));
}
