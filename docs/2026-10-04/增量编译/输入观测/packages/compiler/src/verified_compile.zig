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

    const program = analyzed.value.ir;

    if (program.native_modules.len != 0) {
        const writer = options.type_output orelse return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use --out or build" } };
        const bundle = try @import("genz").zx.bundle(allocator, program);

        defer allocator.free(bundle.types);
        errdefer allocator.free(bundle.source);

        try writer.writeAll(bundle.types);

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

    const program = analyzed.value.ir;

    if (try compiler.validateIr(allocator, program)) |issue| {
        analyzed.value = .{ .diagnostic = issue };

        return analyzed;
    }

    if (options.dependencies) |dependencies| {
        for (program.native_modules) |module| try dependencies.append(allocator, try allocator.dupe(u8, module.import_name));
    }

    if (requiresVerification(program, options.solver)) {
        if (!try compiler.verification.check(options.io, allocator, program, options.sources, options.project.entry, .{ .solver = options.solver }, options.writer)) {
            analyzed.value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "program verification did not succeed; code was not generated" } };

            return analyzed;
        }
    }

    return analyzed;
}

fn requiresVerification(program: compiler.ir.Program, solver: ?[]const u8) bool {
    if (program.contracts.len != 0 or solver != null) return true;
    for (program.functions) |function| if (function.contracts.len != 0) return true;

    return false;
}
