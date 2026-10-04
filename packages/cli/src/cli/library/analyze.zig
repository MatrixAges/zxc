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
    pub fn deinit(self: *Result) void {
        for (self.modules) |*module| module.analysis.deinit();

        const allocator = self.arena.child_allocator;

        self.arena.deinit();
        allocator.destroy(self.arena);

        self.* = undefined;
    }

    pub fn link(self: *const Result, allocator: std.mem.Allocator) !compiler.library.Result {
        const inputs = try allocator.alloc(compiler.library.Input, self.modules.len);

        defer allocator.free(inputs);

        for (self.modules, inputs) |*module, *input| input.* = .{ .name = module.name, .analysis = &module.analysis };

        return compiler.library.link(allocator, inputs);
    }
};

pub const Options = struct { io: std.Io, loaded: Loaded, writer: *std.Io.Writer, inputs: ?*Inputs = null };

pub fn run(allocator: std.mem.Allocator, options: Options) !?Result {
    if (options.loaded.config.exports.len == 0) return error.MissingPublicModules;

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

    for (options.loaded.config.exports, modules) |exported, *module| {
        var project = options.loaded.project;

        project.entry = try std.fs.path.resolve(owned, &.{ project.root_dir, exported.source });

        if (std.mem.endsWith(u8, project.entry, ".rx")) {
            const prepared = try @import("../rx/analyze.zig").run(owned, .{ .io = options.io, .project = project, .writer = options.writer, .inputs = options.inputs }) orelse return null;
            module.* = .{ .name = exported.path, .analysis = prepared.analysis, .sources = prepared.sources, .store_definitions = prepared.store_definitions };
        } else {
            const source = try std.Io.Dir.cwd().readFileAlloc(options.io, project.entry, owned, .limited(16 * 1024 * 1024));
            const sources = try @import("../sources.zig").readWithInputs(options.io, owned, source, project, &cache, options.inputs);
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
