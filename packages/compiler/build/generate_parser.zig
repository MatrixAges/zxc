const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");
const manifest = @import("generation_manifest.zig");
const Resident = @import("resident/state.zig");
const Files = @import("resident/files.zig");
const InputSnapshot = @import("input_snapshot.zig");
const fingerprint = compiler.input_fingerprint;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 2) return error.MissingCommand;

    if (std.mem.eql(u8, args[1], "--lexer")) {
        if (args.len != 5) return error.OutputCountMismatch;

        return @import("generate_lexer.zig").generate(init, args[2], args[3], args[4]);
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
        if (args.len != 3 and args.len != 6) return error.OutputCountMismatch;

        const warm: ?Request = if (args.len == 6) .{ .manifest = args[3], .output = args[4], .cache = args[2], .partitions = try std.fmt.parseInt(u32, args[5], 10), .write = false } else null;

        return @import("resident/service.zig").serve(init, args[2], warm);
    }

    return error.UnknownCommand;
}

/// One generation: the manifest naming the entries and source roots, the output tree, the cache directory and the
/// partition count. Without `write` it only analyzes, leaving the output as it is.
pub const Request = struct { manifest: []const u8, output: []const u8, cache: []const u8, partitions: u32, write: bool = true };

/// Runs `request` and returns its summary line, or nothing when the output is already current.
pub fn generate(io: std.Io, allocator: std.mem.Allocator, resident: *Resident, request: Request) ![]const u8 {
    const manifest_source = try std.Io.Dir.cwd().readFileAlloc(io, request.manifest, allocator, .unlimited);
    const project = try std.json.parseFromSliceLeaky(manifest.Project, allocator, manifest_source, .{});
    const output = request.output;
    const partitions = request.partitions;

    if (project.entries.len == 0) return error.EmptyEntrySet;

    const owned = resident.inputAllocator(allocator);
    const snapshot = if (request.write) try InputSnapshot.prepare(io, allocator, owned, &resident.files, resident.digest, project, manifest_source, partitions, request.cache) else null;

    if (snapshot) |prepared| if (try prepared.current(io, allocator)) |digest| {
        if (try current(io, allocator, output, digest)) return "";
    };

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;
    var templates: std.ArrayList(compiler.project.Resource) = .empty;

    if (snapshot) |prepared| {
        try prepared.load(io, owned, &resident.files, &sources, &modules, &templates);
    } else for (project.roots) |root| try collection.collect(io, allocator, owned, &resident.files, root.path, root.prefix, &sources, &modules, &templates);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);
    std.mem.sort(compiler.project.Resource, templates.items, {}, collection.lessResource);

    for (sources.items) |*source| source.templates = templates.items;

    const packages = try owned.alloc(compiler.project.Package, project.packages.len);

    for (project.packages, packages) |package, *target| {
        target.* = .{ .specifier = try resident.retainText(owned, package.specifier), .entry = try resident.retainText(owned, package.entry) };
    }

    for (modules.items) |*module| module.packages = packages;

    const interfaces = try owned.alloc(compiler.project.NativeInterface, project.interfaces.len);
    var interface_error: ?anyerror = null;

    for (project.interfaces, interfaces) |interface, *target| {
        const source = for (sources.items) |candidate| {
            if (std.mem.eql(u8, candidate.path, interface.path)) break candidate.source;
        } else resident.files.read(io, std.Io.Dir.cwd(), interface.path, try std.fs.path.resolve(allocator, &.{interface.path})) catch |err| unread: {
            if (interface_error == null) interface_error = err;

            break :unread "";
        };

        target.* = .{
            .specifier = try resident.retainText(owned, interface.specifier),
            .path = try resident.retainText(owned, interface.path),
            .source = source,
            .module = try resident.retainText(owned, interface.module),
        };
    }

    const rx_digests = try allocator.alloc(analysis.project.ModuleDigest, modules.items.len);

    for (modules.items, rx_digests) |module, *item| item.* = .{ .path = module.path, .digest = resident.files.digest(module.path, module.source) };

    const frame = frameDigest(&resident.digest, manifest_source, rx_digests, interfaces, true);
    const inputs_digest = outputDigest(&frame, partitions, sources.items, templates.items, &resident.files);

    // An output directory reused across runs already holds the result when nothing it depends on changed.
    if (request.write and interface_error == null and try current(io, allocator, output, inputs_digest)) {
        if (snapshot) |prepared| prepared.save(io, allocator, &resident.files, inputs_digest) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => {},
        };

        return "";
    }

    const recorded = try std.fs.path.join(allocator, &.{ output, shared_output.fingerprint_name });

    if (request.write) std.Io.Dir.cwd().deleteFile(io, recorded) catch |err| switch (err) {
        error.FileNotFound => {},
        else => return err,
    };

    const prepared_sources = switch (try compiler.project.prepareSources(owned, sources.items, .{ .entry = "" })) {
        .sources => |items| items,
        .diagnostic => |issue| {
            std.debug.print("{s}: {s}\n", .{ sources.items[issue.source_index.?].path, issue.message });

            return error.InvalidTemplateResource;
        },
    };

    const parsed = try resident.modules.parse(modules.items, packageDigest(packages));

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ modules.items[parsed.value.diagnostic.source_index].path, parsed.value.diagnostic.issue.message });

        return error.InvalidParserModule;
    }

    if (interface_error) |err| return err;

    const inputs = try owned.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.inputs) |*item, source, *module| {
        item.* = module.*;
        item.path = source.path;
        item.packages = source.packages;
    }

    const summary = try @import("shared_generation.zig").run(io, allocator, owned, resident, project.entries, .{
        .modules = inputs,
        .sources = prepared_sources,
        .interfaces = interfaces,
        .packages = packages,
        .frame = frame,
        .shape = frameDigest(&resident.digest, manifest_source, rx_digests, interfaces, false),
        .rx_digests = rx_digests,
    }, if (request.write) output else null, request.cache, partitions);

    if (request.write) {
        try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = recorded, .data = &std.fmt.bytesToHex(inputs_digest, .lower) });

        if (snapshot) |prepared| prepared.save(io, allocator, &resident.files, inputs_digest) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => {},
        };
    }

    return summary;
}

const shared_output = @import("shared_output.zig");

/// Everything a generation reads besides the ZX sources; RX sources enter by their digests, or by their paths alone for
/// the shape an analysis reuses RX modules within.
fn frameDigest(generator: *const fingerprint.Digest, manifest_source: []const u8, modules: []const analysis.project.ModuleDigest, interfaces: []const compiler.project.NativeInterface, texts: bool) fingerprint.Digest {
    var buffer: [1024]u8 = undefined;
    var hash = fingerprint.Hash.init(&buffer);

    fingerprint.frame(&hash, generator, manifest_source, texts, modules, interfaces);

    return hash.finish();
}

/// The frame and raw ZX/template inputs; a matching output needs no template expansion or RX parsing.
fn outputDigest(frame: *const fingerprint.Digest, partitions: u32, sources: []const compiler.project.Source, templates: []const compiler.project.Resource, files: *Files) fingerprint.Digest {
    var buffer: [1024]u8 = undefined;
    var hash = fingerprint.Hash.init(&buffer);

    fingerprint.output(&hash, frame, partitions);
    writeDigests(&hash, files, sources);
    writeDigests(&hash, files, templates);

    return hash.finish();
}

fn writeDigests(hash: *fingerprint.Hash, files: *Files, inputs: anytype) void {
    const batch_size = fingerprint.batch_size;
    var paths: [batch_size][]const u8 = undefined;
    var digests: [batch_size]fingerprint.Digest = undefined;
    var views: [batch_size][]const u8 = undefined;
    var remaining = inputs;

    while (remaining.len != 0) {
        const count = @min(batch_size, remaining.len);

        for (remaining[0..count], paths[0..count], digests[0..count], views[0..count]) |*input, *path, *digest, *view| {
            path.* = input.path;
            digest.* = files.digest(input.path, input.source);
            view.* = digest;
        }

        fingerprint.files(hash, paths[0..count], views[0..count]);

        remaining = remaining[count..];
    }
}

fn packageDigest(packages: []const compiler.project.Package) fingerprint.Digest {
    var buffer: [1024]u8 = undefined;
    var hash = fingerprint.Hash.init(&buffer);
    var fields: [fingerprint.batch_size][]const u8 = undefined;
    var remaining = packages;

    while (remaining.len != 0) {
        const count = @min(fields.len / 2, remaining.len);

        for (remaining[0..count], 0..) |package, index| {
            fields[2 * index] = package.specifier;
            fields[2 * index + 1] = package.entry;
        }

        fingerprint.files(&hash, fields[0 .. 2 * count], &.{});

        remaining = remaining[count..];
    }

    return hash.finish();
}

fn current(io: std.Io, allocator: std.mem.Allocator, output: []const u8, digest: [32]u8) !bool {
    const path = try std.fs.path.join(allocator, &.{ output, shared_output.fingerprint_name });

    const recorded = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(65)) catch |err| switch (err) {
        error.FileNotFound, error.StreamTooLong => return false,
        else => return err,
    };

    return std.mem.eql(u8, recorded, &std.fmt.bytesToHex(digest, .lower));
}
