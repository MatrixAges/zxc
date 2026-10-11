const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");
const manifest = @import("generation_manifest.zig");
const Resident = @import("resident/state.zig");

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

        const partitions = if (args.len == 7) try std.fmt.parseInt(u32, args[6], 10) else 0;

        return @import("resident/service.zig").run(init, .{ .manifest = args[2], .output = args[3], .cache = args[4], .partitions = partitions });
    }

    if (std.mem.eql(u8, args[1], "--serve")) {
        if (args.len != 3) return error.OutputCountMismatch;

        return @import("resident/service.zig").serve(init, args[2]);
    }

    return error.UnknownCommand;
}

/// One generation: the manifest naming the entries and source roots, the output tree, the cache directory and the
/// partition count.
pub const Request = struct { manifest: []const u8, output: []const u8, cache: []const u8, partitions: u32 };

/// Runs `request` and returns its summary line, or nothing when the output is already current. `allocator` is an arena
/// owning everything read for the request; the analysis `resident` keeps may point into it.
pub fn generate(io: std.Io, allocator: std.mem.Allocator, resident: *Resident, request: Request) ![]const u8 {
    const manifest_source = try std.Io.Dir.cwd().readFileAlloc(io, request.manifest, allocator, .unlimited);
    const project = try std.json.parseFromSliceLeaky(manifest.Project, allocator, manifest_source, .{});
    const output = request.output;
    const partitions = request.partitions;

    if (project.entries.len == 0) return error.EmptyEntrySet;

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;

    for (project.roots) |root| try collection.collect(io, allocator, &resident.files, root.path, root.prefix, &sources, &modules);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);

    const parsed = try rx.parseModules(allocator, modules.items);

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
        } else try std.Io.Dir.cwd().readFileAlloc(io, interface.path, allocator, .unlimited);

        target.* = .{ .specifier = interface.specifier, .path = interface.path, .source = source, .module = interface.module };
    }

    const packages = try allocator.alloc(compiler.project.Package, project.packages.len);

    for (project.packages, packages) |package, *target| target.* = .{ .specifier = package.specifier, .entry = package.entry };

    const frame = frameDigest(resident.digest, manifest_source, modules.items, interfaces);
    const inputs_digest = fingerprint(frame, partitions, sources.items);

    // An output directory reused across runs already holds the result when nothing it depends on changed.
    if (try current(io, allocator, output, inputs_digest)) return "";

    const recorded = try std.fs.path.join(allocator, &.{ output, shared_output.fingerprint_name });

    std.Io.Dir.cwd().deleteFile(io, recorded) catch |err| switch (err) {
        error.FileNotFound => {},
        else => return err,
    };

    const summary = try @import("shared_generation.zig").run(io, allocator, resident, project.entries, .{
        .modules = inputs,
        .sources = sources.items,
        .interfaces = interfaces,
        .packages = packages,
        .frame = frame,
    }, output, request.cache, partitions);

    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = recorded, .data = &std.fmt.bytesToHex(inputs_digest, .lower) });

    return summary;
}

const shared_output = @import("shared_output.zig");

/// Everything a generation reads besides the ZX sources.
fn frameDigest(generator: [32]u8, manifest_source: []const u8, modules: []const rx.TextSource, interfaces: []const compiler.project.NativeInterface) [32]u8 {
    var hash = std.crypto.hash.Blake3.init(.{});

    hash.update(&generator);
    field(&hash, manifest_source);

    for (modules) |module| {
        field(&hash, module.path);
        field(&hash, module.source);
    }

    for (interfaces) |interface| field(&hash, interface.source);

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    return digest;
}

fn fingerprint(frame: [32]u8, partitions: u32, sources: []const compiler.project.Source) [32]u8 {
    var hash = std.crypto.hash.Blake3.init(.{});

    hash.update(&frame);
    hash.update(std.mem.asBytes(&partitions));

    for (sources) |source| {
        field(&hash, source.path);
        field(&hash, source.source);
    }

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
