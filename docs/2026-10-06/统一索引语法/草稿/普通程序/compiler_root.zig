const std = @import("std");
const zx = @import("zx");
const lint = @import("lint");
const frontend = @import("frontend");
pub const ir = zx.ir;
pub const parse = frontend.parse;
pub const ParseResult = frontend.ParseResult;
pub const parseExpression = frontend.parseExpression;
pub const ExpressionParseResult = frontend.ExpressionParseResult;
pub const expressions = frontend.expressions;
pub const analyze = frontend.analyze;
pub const Context = frontend.Context;
pub const analyzeWithContext = frontend.analyzeWithContext;
pub const AnalysisResult = frontend.AnalysisResult;
pub const library = @import("library/root.zig");
pub const zig = @import("backends/zig.zig");
pub const Diagnostic = zx.Diagnostic;
pub const validateIr = frontend.validateIr;
pub const verification = @import("verification/root.zig");
pub const hardware = @import("backends/hardware/root.zig");
pub const verilog = @import("backends/verilog/root.zig");
pub const compileProjectVerified = @import("verified_compile.zig").compile;
pub const emitProgramVerified = @import("verified_compile.zig").emit;
pub const emitLibraryVerified = @import("verified_compile.zig").emitLibrary;
pub const emitModulesVerified = @import("verified_compile.zig").emitModules;
pub const compileProjectModulesVerified = @import("verified_compile.zig").compileModules;
pub const CompileOptions = @import("verified_compile.zig").Options;

pub const Result = union(enum) {
    source: []u8,
    diagnostic: Diagnostic,
    pub fn deinit(self: Result, allocator: std.mem.Allocator) void {
        switch (self) {
            .source => |source| allocator.free(source),
            .diagnostic => |issue| issue.deinit(),
        }
    }
};

pub fn compile(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!Result {
    return compileWithContext(allocator, source, file_name, .{});
}

pub fn compileWithContext(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8, context: Context) std.mem.Allocator.Error!Result {
    var parsed = try frontend.parseModule(allocator, source, file_name);

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| return .{ .diagnostic = try issue.clone(allocator) };
    if (try parsed.check(allocator)) |issue| return .{ .diagnostic = issue };

    var analyzed = try frontend.analyzeModule(allocator, &parsed, context);

    defer analyzed.deinit();

    return switch (analyzed.value) {
        .diagnostic => |issue| .{ .diagnostic = try issue.clone(allocator) },
        .ir => |program| .{ .source = zig.emit(allocator, program) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.InvalidIr => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "internal compiler error: generated invalid IR" } },
            error.NativeRequiresBundle => return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use analyzeProject with zig.emitBundle" } },
            error.UnverifiedContracts => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "formal contract verification is required before code generation" } },
        } },
    };
}

pub fn format(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!Result {
    if (std.mem.endsWith(u8, file_name, ".rx")) {
        var parsed = try frontend.parseExpressionXml(allocator, source);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) {
            const issue = parsed.value.diagnostic;
            const diagnostic = Diagnostic{ .code = .syntax, .span = .{ .start = issue.location.offset, .end = issue.location.offset }, .message = issue.message };

            return .{ .diagnostic = try diagnostic.clone(allocator) };
        }

        return .{ .source = try lint.rx.format(allocator, source, parsed.value.node) };
    }

    var parsed = try parse(allocator, source, file_name);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) return .{ .diagnostic = try parsed.value.diagnostic.clone(allocator) };

    const input = parsed.value.parsed;

    return .{ .source = try lint.source.format(allocator, .{ .source = input.source, .comments = input.lexed.comments, .program = input.ast }) };
}

pub const project = frontend.project;

pub fn analyzeProject(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options) std.mem.Allocator.Error!AnalysisResult {
    var cache = project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    return analyzeProjectWithCache(allocator, sources, options, &cache);
}

pub fn analyzeProjectWithCache(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options, cache: *project.ParseCache) std.mem.Allocator.Error!AnalysisResult {
    if (try checkProjectSources(allocator, sources, options, cache)) |issue| return analysisDiagnostic(allocator, issue);

    return project.analyzeWithCache(allocator, sources, options, cache);
}

pub fn analyzeProjectIncremental(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options, cache: *project.SemanticCache) std.mem.Allocator.Error!AnalysisResult {
    if (try checkProjectSources(allocator, sources, options, &cache.parse_cache)) |issue| return analysisDiagnostic(allocator, issue);

    return project.analyzeIncremental(allocator, sources, options, cache);
}

fn analysisDiagnostic(allocator: std.mem.Allocator, issue: Diagnostic) std.mem.Allocator.Error!AnalysisResult {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var owned = issue;
    owned.message = try arena.allocator().dupe(u8, issue.message);
    owned.message_allocator = null;

    return .{ .arena = arena, .value = .{ .diagnostic = owned } };
}

fn checkProjectSources(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options, cache: *project.ParseCache) std.mem.Allocator.Error!?Diagnostic {
    for (sources, 0..) |source, index| {
        const path = try std.fs.path.resolve(allocator, &.{ options.root_dir, source.path });

        defer allocator.free(path);

        const parsed = try cache.getModule(source.source, path);
        var issue = try parsed.check(allocator);

        if (issue) |*diagnostic| {
            diagnostic.source_index = index;

            return diagnostic.*;
        }
    }

    return null;
}

pub fn compileProject(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options) std.mem.Allocator.Error!Result {
    var analyzed = try analyzeProject(allocator, sources, options);

    defer analyzed.deinit();

    return switch (analyzed.value) {
        .diagnostic => |issue| .{ .diagnostic = try issue.clone(allocator) },
        .ir => |program| .{ .source = zig.emit(allocator, program) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.InvalidIr => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid project IR" } },
            error.NativeRequiresBundle => return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use analyzeProject with zig.emitBundle" } },
            error.UnverifiedContracts => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "formal contract verification is required before code generation" } },
        } },
    };
}
