const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const Loaded = @import("../project.zig").Loaded;
const Inputs = @import("../watch/inputs.zig");

pub const Module = struct {
    name: []const u8,
    analysis: compiler.AnalysisResult,
    sources: []const compiler.project.Source,
    store_definitions: []const @import("rx_analysis").store.Definition = &.{},
};

pub const Result = struct {
    arena: *std.heap.ArenaAllocator,
    modules: []Module,
    compiled: ?compiler.library.Result = null,
    legacy_single: bool = false,
    pub fn deinit(self: *Result) void {
        for (self.modules) |*module| module.analysis.deinit();
        if (self.compiled) |*library| library.deinit();

        const allocator = self.arena.child_allocator;

        self.arena.deinit();
        allocator.destroy(self.arena);

        self.* = undefined;
    }

    pub fn link(self: *Result, allocator: std.mem.Allocator) !compiler.library.Result {
        if (self.compiled) |library| {
            self.compiled = null;

            return library;
        }

        var temporary = std.heap.ArenaAllocator.init(allocator);

        defer temporary.deinit();

        const scratch = temporary.allocator();
        const inputs = try scratch.alloc(compiler.library.Input, self.modules.len);

        for (self.modules, inputs) |*module, *input| {
            if (module.analysis.value != .ir) return error.InvalidAnalysis;

            var initializers: std.ArrayList(compiler.library.Initializer) = .empty;

            for (module.store_definitions) |definition| for (definition.objects) |object| {
                const identity = try std.fmt.allocPrint(scratch, "store.{s}:{s}", .{ definition.source_path, object.name });

                const needed = for (module.analysis.value.ir.stores.paths) |path| {
                    if (std.mem.eql(u8, path, identity)) break true;
                } else false;

                if (needed) try initializers.append(scratch, .{ .identity = identity, .schema_version = definition.version, .program = object.initial });
            };

            input.* = .{ .name = module.name, .analysis = &module.analysis, .initializers = initializers.items };
        }

        return compiler.library.link(allocator, inputs);
    }
};

pub const Options = struct { io: std.Io, loaded: Loaded, writer: *std.Io.Writer, inputs: ?*Inputs = null, preserve_zig_entry: bool = false };

pub fn run(allocator: std.mem.Allocator, options: Options) !?Result {
    if (options.loaded.config.exports.len == 0) return error.MissingPublicModules;
    if (options.loaded.config.library != null) return try @import("compiled.zig").load(allocator, options);

    const arena = try allocator.create(std.heap.ArenaAllocator);
    arena.* = std.heap.ArenaAllocator.init(allocator);

    var transferred = false;
    var count: usize = 0;
    const owned = arena.allocator();
    var modules: []Module = &.{};

    defer if (!transferred) {
        for (modules[0..count]) |*module| module.analysis.deinit();

        arena.deinit();
        allocator.destroy(arena);
    };

    modules = try owned.alloc(Module, options.loaded.config.exports.len);

    var cache = compiler.project.ParseCache{ .allocator = owned };

    defer cache.deinit();

    var libraries = @import("inputs.zig"){ .allocator = owned };

    defer libraries.deinit();

    for (options.loaded.config.exports, modules) |exported, *module| {
        var project = options.loaded.project;

        project.entry = try std.fs.path.resolve(owned, &.{ project.root_dir, exported.source });

        if (std.mem.endsWith(u8, project.entry, ".rx")) {
            const prepared = try @import("../rx/analyze.zig").run(owned, .{ .io = options.io, .project = project, .writer = options.writer, .inputs = options.inputs }) orelse return null;
            module.* = .{ .name = exported.path, .analysis = prepared.analysis, .sources = prepared.sources, .store_definitions = prepared.store_definitions };
        } else {
            const source = try std.Io.Dir.cwd().readFileAlloc(options.io, project.entry, owned, .limited(16 * 1024 * 1024));
            const sources = try @import("../sources.zig").readWithLibraries(options.io, owned, source, project, &cache, options.inputs, &libraries);
            project.compiled_libraries = libraries.libraries.items;

            const analyzed = try compiler.analyzeProjectWithCache(owned, sources, project, &cache);
            module.* = .{ .name = exported.path, .analysis = analyzed, .sources = sources };
        }

        count += 1;
        module.name = try owned.dupe(u8, module.name);

        if (module.analysis.value == .diagnostic) {
            const issue = module.analysis.value.diagnostic;
            const source = module.sources[issue.source_index orelse 0];
            const location = zx.source.locate(source.source, issue.span.start);

            try options.writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ source.path, location.line, location.column, issue.code, issue.message });

            return null;
        }
    }

    transferred = true;

    return .{ .arena = arena, .modules = modules };
}
