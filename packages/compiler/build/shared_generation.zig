const std = @import("std");
const compiler = @import("compiler");
const analysis = @import("rx_analysis");
const Entry = @import("entries.zig").Entry;

const Inputs = struct {
    modules: []const @import("rx").ModuleSource,
    sources: []const compiler.project.Source,
    interfaces: []const compiler.project.NativeInterface,
    packages: []const compiler.project.Package,
};

pub fn run(init: std.process.Init, entries: []const Entry, inputs: Inputs, output: []const u8, cache_path: []const u8) !void {
    const started = std.Io.Timestamp.now(init.io, .awake);
    const allocator = init.arena.allocator();
    const roots = try allocator.alloc([]const u8, entries.len);
    const exports = try allocator.alloc(analysis.project.Export, entries.len);

    for (entries, roots, exports) |entry, *root, *exported| {
        root.* = entry.path;
        exported.* = .{ .name = entry.name, .path = entry.path };
    }

    const project = compiler.project.Options{ .entry = "", .native_interfaces = inputs.interfaces, .packages = inputs.packages };
    var parse_cache = compiler.project.ParseCache{ .allocator = allocator };
    const selected = try @import("source_inputs.zig").reachable(allocator, inputs.modules, inputs.sources, roots, project, &parse_cache);

    var analyzed = try analysis.project.infer(init.gpa, .{
        .entry = roots[0],
        .exports = exports,
        .modules = selected,
        .sources = inputs.sources,
        .project = project,
        .parse_cache = &parse_cache,
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidParserSource;
    }

    const inferred = std.Io.Timestamp.now(init.io, .awake);
    const contract = analyzed.value.contract;

    const library = compiler.library.Result{
        .arena = analyzed.arena,
        .program = .{
            .file_name = "bootstrap",
            .types = contract.types,
            .input_type = @fromBackingInt(@intCast(@backingInt(compiler.ir.Scalar.void))),
            .output_type = @fromBackingInt(@intCast(@backingInt(compiler.ir.Scalar.void))),
            .symbols = .{},
            .expressions = .{},
            .body = .{},
            .functions = contract.program.functions,
            .native_modules = contract.native_modules,
            .type_only = true,
        },
        .exports = contract.exports,
        .nominal_types = contract.nominal_types,
        .store_initializers = contract.store_initializers,
    };

    const executable = try std.process.executablePathAlloc(init.io, allocator);
    const binary = try std.Io.Dir.cwd().readFileAlloc(init.io, executable, allocator, .unlimited);
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(binary, &digest, .{});

    var cache = try compiler.zig.GenerationCache.initPersistent(init.gpa, init.io, cache_path, digest);

    defer cache.deinit();

    var bundle = try compiler.zig.emitLibraryFilesCached(init.gpa, &library, &cache);

    defer bundle.deinit();

    const emitted = std.Io.Timestamp.now(init.io, .awake);

    try @import("shared_output.zig").write(init.io, allocator, output, bundle);

    const written = std.Io.Timestamp.now(init.io, .awake);

    const summary = try std.fmt.allocPrint(allocator, "bootstrap: {d} entries, {d} function files, {d} generated, {d} reused; infer {d}ms, emit {d}ms, write {d}ms\n", .{
        entries.len,
        bundle.modules.len,
        cache.generated,
        cache.reused,
        @divTrunc(started.durationTo(inferred).nanoseconds, std.time.ns_per_ms),
        @divTrunc(inferred.durationTo(emitted).nanoseconds, std.time.ns_per_ms),
        @divTrunc(emitted.durationTo(written).nanoseconds, std.time.ns_per_ms),
    });

    try std.Io.File.stdout().writeStreamingAll(init.io, summary);
}
