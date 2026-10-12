const std = @import("std");
const model = @import("../../library/root.zig");
const validation = @import("../../library/validate.zig");
const modules = @import("modules.zig");
const names = @import("names.zig");
const references = @import("references.zig");
const Cache = @import("cache.zig");
pub const Error = modules.Error || validation.Error || error{InvalidModule};
pub const PublicModule = struct { name: []const u8, file: modules.File, value_entry: bool = false, allocator_entry: bool = false };

pub const Bundle = struct {
    arena: std.heap.ArenaAllocator,
    public_modules: []const PublicModule,
    types: []const u8,
    modules: []const modules.File,
    type_names: []const []const u8,
    native_modules: @import("zx").ir.NativeModuleTable,
    store_initializers: []const modules.StoreInitializer = &.{},
    pub fn deinit(self: *Bundle) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn createCached(allocator: std.mem.Allocator, library: *const model.Result, cache: ?*Cache) Error!Bundle {
    return create(allocator, allocator, library, cache, false);
}

/// A bundle of files that import each other, held in memory from `output`; what building it needs only meanwhile
/// comes from `allocator`.
pub fn createFilesCached(allocator: std.mem.Allocator, output: std.mem.Allocator, library: *const model.Result, cache: ?*Cache) Error!Bundle {
    return create(allocator, output, library, cache, true);
}

fn create(allocator: std.mem.Allocator, output: std.mem.Allocator, library: *const model.Result, cache: ?*Cache, file_imports: bool) Error!Bundle {
    if (@import("frontend").checks_internal_ir) try validation.validate(allocator, library);

    var arena = std.heap.ArenaAllocator.init(output);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const program = try @import("genz").zx.prepare(owned, library.program);
    const needed = try owned.alloc(bool, program.functions.count());
    const public_modules = try owned.alloc(PublicModule, library.exports.len);
    const exported_functions = try owned.alloc(@import("zx").ir.FunctionId, library.exports.len);
    var exported_count: usize = 0;

    for (library.exports) |exported| if (exported.function) |id| {
        exported_functions[exported_count] = id;
        exported_count += 1;
    };

    const memos = @import("uniqueness_memo.zig");
    const keeps_memo = if (cache) |store| store.keeps_memo else false;
    var loaded = if (keeps_memo) null else try memos.load(allocator, cache);

    defer if (loaded) |*value| value.deinit();

    const memo = if (loaded) |*value| value else if (keeps_memo) try memos.kept(cache.?) else null;
    var analysis = try @import("genz").zx.modules.Analysis.createRemembered(allocator, program, exported_functions[0..exported_count], memo);

    // Names take the capabilities the analysis already found instead of tracing the call graph again.
    var identities = names.createWith(owned, program, library.nominal_types, .{ .io = analysis.value.io, .process = analysis.value.process }) catch |err| {
        analysis.deinit();

        return err;
    };

    if (file_imports) {
        const functions = try owned.alloc([]const u8, identities.functions.len);

        for (identities.functions, functions) |name, *path| path.* = try std.fmt.allocPrint(owned, "{s}.zig", .{name});

        identities.functions = functions;
    }

    var batch = modules.Batch.fromAnalysis(allocator, program, identities, cache, analysis);

    defer batch.deinit();

    if (loaded) |*value| try memos.save(allocator, cache, value);

    var prepared_library = library.*;

    prepared_library.program = program;

    @memset(needed, false);

    // Each export reenters the analysis with its own entry plan; their entries, the types and every needed function
    // are then generated together on all cores.
    const public_batches = try owned.alloc(modules.Batch, library.exports.len);

    for (library.exports, public_modules, public_batches, 0..) |exported, *public_module, *public_batch, index| {
        const view = if (file_imports)
            try @import("library_entry.zig").create(owned, &prepared_library, index)
        else
            try prepared_library.module(index);

        references.markRoot(needed, view);

        var digest: [32]u8 = undefined;

        @import("zx").Sha256.hash(exported.name, &digest, .{});
        public_batch.* = batch;
        public_batch.program = view;

        try public_batch.analysis.value.reentry(owned, allocator, view);

        public_module.* = .{
            .name = try owned.dupe(u8, exported.name),
            .value_entry = public_batch.analysis.value.hasValueEntry(view),
            .allocator_entry = public_batch.analysis.value.hasAllocatorEntry(view),
            .file = .{
                .name = try std.fmt.allocPrint(owned, "public_{s}", .{std.fmt.bytesToHex(digest, .lower)}),
                .source = &.{},
                .imports = try references.imports(owned, view.expressions, view.contracts, identities.functions),
            },
        };
    }

    references.close(needed, program.functions);

    const units = try modules.functionUnits(owned, needed);
    const Job = @import("function_sources.zig").Job;
    const jobs = try owned.alloc(Job, public_batches.len + 1 + units.len);

    for (jobs[0..public_batches.len], public_batches) |*job, *public_batch| job.* = .{ .batch = public_batch, .unit = .entry };

    jobs[public_batches.len] = .{ .batch = &batch, .unit = .types };

    for (jobs[public_batches.len + 1 ..], units) |*job, unit| job.* = .{ .batch = &batch, .unit = unit };

    const generated = try @import("function_sources.zig").createJobs(owned, allocator, jobs);

    for (public_modules, generated[0..public_batches.len]) |*public_module, source| public_module.file.source = source;

    const type_source = generated[public_batches.len];
    const initializers = try @import("library_initializers.zig").createBacked(owned, allocator, library, identities, cache);
    const roots = try owned.alloc([]const u8, public_modules.len + initializers.files.len);

    for (roots[0..public_modules.len], public_modules) |*root, public_module| root.* = public_module.file.source;
    for (roots[public_modules.len..], initializers.files) |*root, file| root.* = file.source;

    const functions = try modules.functionFilesFrom(owned, &batch, units, generated[public_batches.len + 1 ..], roots);
    const files = try std.mem.concat(owned, modules.File, &.{ functions, initializers.files });
    const type_names = try modules.typeNamesAnalyzed(owned, program, identities, batch.analysis.value.value.state);
    const native_modules = try modules.nativeModules(owned, program);

    return .{
        .arena = arena,
        .public_modules = public_modules,
        .types = type_source,
        .modules = files,
        .type_names = type_names,
        .native_modules = native_modules,
        .store_initializers = initializers.entries,
    };
}
