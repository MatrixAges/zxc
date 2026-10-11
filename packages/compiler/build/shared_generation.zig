const std = @import("std");
const compiler = @import("compiler");
const analysis = @import("rx_analysis");
const Entry = @import("entries.zig").Entry;
const Resident = @import("resident/state.zig");

const Inputs = struct {
    modules: []const @import("rx").ModuleSource,
    sources: []const compiler.project.Source,
    interfaces: []const compiler.project.NativeInterface,
    packages: []const compiler.project.Package,
    /// Identifies every input besides the ZX sources.
    frame: [32]u8,
};

/// Generates the tree for `entries` into `output`, unless it is null, and returns its summary line. Parsed modules,
/// cached sources and the previous analysis come from `resident`, which keeps them for later requests.
pub fn run(io: std.Io, allocator: std.mem.Allocator, resident: *Resident, entries: []const Entry, inputs: Inputs, output: ?[]const u8, cache_path: []const u8, partitions: u32) ![]const u8 {
    const started = std.Io.Timestamp.now(io, .awake);
    const roots = try allocator.alloc([]const u8, entries.len);
    const exports = try allocator.alloc(analysis.project.Export, entries.len);

    for (entries, roots, exports) |entry, *root, *exported| {
        root.* = entry.path;
        exported.* = .{ .name = entry.name, .path = entry.path };
    }

    const project = compiler.project.Options{ .entry = "", .native_interfaces = inputs.interfaces, .packages = inputs.packages };
    const parse_cache = &resident.parse_cache;
    const history = resident.startAnalysis(inputs.frame);

    // When only function bodies changed, the earlier analysis already found the reachable modules.
    history.bodies_only = try history.bodiesOnly(inputs.sources, parse_cache);

    const selected = if (history.bodies_only) history.previous.?.modules else try @import("source_inputs.zig").reachable(allocator, inputs.modules, inputs.sources, roots, project, parse_cache);

    var analyzed = try analysis.project.infer(resident.gpa, .{
        .entry = roots[0],
        .exports = exports,
        .modules = selected,
        .sources = inputs.sources,
        .project = project,
        .parse_cache = parse_cache,
        .history = history,
    });

    var kept = false;

    defer if (!kept) analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidParserSource;
    }

    const inferred = std.Io.Timestamp.now(io, .awake);
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

    const cache = try resident.generationCache(io, cache_path);
    const generated = cache.generated;
    const reused = cache.reused;
    const bundle = try compiler.zig.emitLibraryFilesCached(resident.gpa, &library, cache);

    defer resident.discard(bundle.arena);
    // The generated sources reach the cache directory while the output is written and Zig compiles it.
    cache.startWriting();

    const emitted = std.Io.Timestamp.now(io, .awake);

    if (output) |path| try @import("shared_output.zig").write(io, allocator, path, bundle, partitions);

    const written = std.Io.Timestamp.now(io, .awake);
    const modules_reused = history.reused;
    const modules_analyzed = history.analyzed;
    const frame_reused = history.bodies_only;

    kept = true;

    try resident.keepAnalysis(analyzed.arena);

    return std.fmt.allocPrint(allocator, "bootstrap: {d} entries, {d} modules analyzed, {d} reused{s}, {d} function files, {d} generated, {d} reused; infer {d}ms, emit {d}ms, write {d}ms\n", .{
        entries.len,
        modules_analyzed,
        modules_reused,
        if (frame_reused) " (bodies only)" else "",
        bundle.modules.len,
        cache.generated - generated,
        cache.reused - reused,
        @divTrunc(started.durationTo(inferred).nanoseconds, std.time.ns_per_ms),
        @divTrunc(inferred.durationTo(emitted).nanoseconds, std.time.ns_per_ms),
        @divTrunc(emitted.durationTo(written).nanoseconds, std.time.ns_per_ms),
    });
}
