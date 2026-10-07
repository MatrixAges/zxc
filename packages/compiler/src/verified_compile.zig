const std = @import("std");
const compiler = @import("root.zig");

pub const Options = struct {
    io: std.Io,
    sources: []const compiler.project.Source,
    project: compiler.project.Options,
    parse_cache: ?*compiler.project.ParseCache = null,
    semantic_cache: ?*compiler.project.SemanticCache = null,
    generation_cache: ?*compiler.zig.GenerationCache = null,
    solver: ?[]const u8 = null,
    dependencies: ?*std.ArrayList([]const u8) = null,
    writer: *std.Io.Writer,
    type_output: ?*std.Io.Writer = null,
};

pub fn compile(allocator: std.mem.Allocator, options: Options) !compiler.Result {
    var analyzed = try analyze(allocator, options);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) return .{ .diagnostic = try analyzed.value.diagnostic.clone(allocator) };

    return render(allocator, options, analyzed.value.ir);
}

pub fn emit(allocator: std.mem.Allocator, options: Options, analyzed: *const compiler.AnalysisResult) !compiler.Result {
    if (analyzed.value == .diagnostic) return .{ .diagnostic = try analyzed.value.diagnostic.clone(allocator) };
    if (try checkProgram(allocator, options, analyzed.value.ir)) |issue| return .{ .diagnostic = try issue.clone(allocator) };

    return render(allocator, options, analyzed.value.ir);
}

fn render(allocator: std.mem.Allocator, options: Options, program: compiler.ir.Program) !compiler.Result {
    if (program.native_modules.count() != 0) {
        const writer = options.type_output orelse return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use --out or build" } };
        const bundle = try @import("genz").zx.bundle(allocator, program);

        defer allocator.free(bundle.types);
        errdefer allocator.free(bundle.source);

        const aliases = try @import("backends/zig/source_abi.zig").render(allocator, program.native_modules, options.project);

        defer allocator.free(aliases);

        try writer.writeAll(bundle.types);
        try writer.writeAll(aliases);

        return .{ .source = bundle.source };
    }

    if (requiresVerification(program, options.solver)) return .{ .source = try @import("genz").zx.emit(allocator, program) };

    return .{ .source = compiler.zig.emit(allocator, program) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidIr, error.UnverifiedContracts, error.NativeRequiresBundle => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid or unverified project IR" } },
    } };
}

pub const ModuleResult = union(enum) {
    bundle: compiler.zig.ModuleBundle,
    diagnostic: compiler.Diagnostic,
    pub fn deinit(self: *ModuleResult) void {
        switch (self.*) {
            .bundle => |*bundle| bundle.deinit(),
            .diagnostic => |issue| issue.deinit(),
        }

        self.* = undefined;
    }
};

pub const LibraryResult = union(enum) {
    bundle: compiler.zig.LibraryBundle,
    diagnostic: compiler.Diagnostic,
};

pub fn emitLibrary(allocator: std.mem.Allocator, options: Options, library: *const compiler.library.Result) !LibraryResult {
    for (library.exports, 0..) |exported, index| {
        var scoped = options;
        scoped.project.entry = exported.path;

        if (try checkProgram(allocator, scoped, try library.module(index))) |issue| return .{ .diagnostic = try issue.clone(allocator) };
    }

    return .{ .bundle = try @import("backends/zig/library.zig").createCached(allocator, library, options.generation_cache) };
}

pub fn compileModules(allocator: std.mem.Allocator, options: Options) !ModuleResult {
    var analyzed = try analyze(allocator, options);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) return .{ .diagnostic = try analyzed.value.diagnostic.clone(allocator) };

    return .{ .bundle = try @import("backends/zig/modules.zig").createCached(allocator, &analyzed, options.generation_cache) };
}

fn analyze(allocator: std.mem.Allocator, options: Options) !compiler.AnalysisResult {
    var analyzed = if (options.semantic_cache) |cache| try compiler.analyzeProjectIncremental(allocator, options.sources, options.project, cache) else if (options.parse_cache) |cache| try compiler.analyzeProjectWithCache(allocator, options.sources, options.project, cache) else try compiler.analyzeProject(allocator, options.sources, options.project);

    errdefer analyzed.deinit();

    if (analyzed.value == .diagnostic) return analyzed;
    if (try checkProgram(allocator, options, analyzed.value.ir)) |issue| analyzed.value = .{ .diagnostic = issue };

    return analyzed;
}

pub fn emitModules(allocator: std.mem.Allocator, options: Options, analyzed: *const compiler.AnalysisResult) !ModuleResult {
    if (analyzed.value == .diagnostic) return .{ .diagnostic = try analyzed.value.diagnostic.clone(allocator) };
    if (try checkProgram(allocator, options, analyzed.value.ir)) |issue| return .{ .diagnostic = try issue.clone(allocator) };

    return .{ .bundle = try @import("backends/zig/modules.zig").createCached(allocator, analyzed, options.generation_cache) };
}

fn checkProgram(allocator: std.mem.Allocator, options: Options, program: compiler.ir.Program) !?compiler.Diagnostic {
    if (try compiler.validateIr(allocator, program)) |issue| return issue;

    if (options.dependencies) |dependencies| {
        for (program.native_modules.import_names) |name| try dependencies.append(allocator, try allocator.dupe(u8, name));
    }

    if (!program.type_only and requiresVerification(program, options.solver)) {
        if (!try compiler.verification.check(options.io, allocator, program, options.sources, options.project.entry, .{ .solver = options.solver }, options.writer)) return .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "program verification did not succeed; code was not generated" };
    }

    return null;
}

fn requiresVerification(program: compiler.ir.Program, solver: ?[]const u8) bool {
    if (program.contracts.count() != 0 or solver != null) return true;

    for (0..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);

        if (function.contracts.count() != 0) return true;
    }

    return false;
}
