const std = @import("std");
const zx = @import("zx");
const lint = @import("lint");
const frontend = @import("frontend");
pub const ir = zx.ir;
pub const parse = frontend.parse;
pub const ParseResult = frontend.ParseResult;
pub const analyze = frontend.analyze;
pub const Context = frontend.Context;
pub const analyzeWithContext = frontend.analyzeWithContext;
pub const AnalysisResult = frontend.AnalysisResult;
pub const zig = @import("backends/zig/root.zig");
pub const Diagnostic = zx.Diagnostic;
pub const validateIr = frontend.validateIr;
pub const verification = @import("verification/root.zig");
pub const hardware = @import("backends/hardware/root.zig");
pub const verilog = @import("backends/verilog/root.zig");
pub const compileProjectVerified = @import("verified_compile.zig").compile;

pub const Result = union(enum) {
    source: []u8,
    diagnostic: Diagnostic,
    pub fn deinit(self: Result, allocator: std.mem.Allocator) void {
        if (self == .source) allocator.free(self.source);
    }
};

pub fn compile(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!Result {
    return compileWithContext(allocator, source, file_name, .{});
}

pub fn compileWithContext(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8, context: Context) std.mem.Allocator.Error!Result {
    var parsed = try parse(allocator, source, file_name);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) return .{ .diagnostic = parsed.value.diagnostic };

    const input = parsed.value.parsed;

    if (lint.checkNames(input.ast)) |issue| return .{ .diagnostic = issue };

    const changes = try lint.spacing.edits(allocator, input.source, input.lexed.comments, input.ast);

    defer allocator.free(changes);

    if (changes.len != 0) return .{ .diagnostic = .{ .code = .spacing, .span = changes[0].span, .message = "blank lines do not match AST grouping; run zxc fmt" } };

    var analyzed = try analyzeWithContext(allocator, input, context);

    defer analyzed.deinit();

    return switch (analyzed.value) {
        .diagnostic => |issue| .{ .diagnostic = issue },
        .ir => |program| .{ .source = zig.emit(allocator, program) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.InvalidIr => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "internal compiler error: generated invalid IR" } },
            error.NativeRequiresBundle => return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use analyzeProject with zig.emitBundle" } },
            error.UnverifiedContracts => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "formal contract verification is required before code generation" } },
        } },
    };
}

pub fn format(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!Result {
    var parsed = try parse(allocator, source, file_name);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) return .{ .diagnostic = parsed.value.diagnostic };

    const input = parsed.value.parsed;
    const changes = try lint.spacing.edits(allocator, input.source, input.lexed.comments, input.ast);

    defer allocator.free(changes);

    return .{ .source = try lint.spacing.format(allocator, source, changes) };
}

pub const project = frontend.project;

pub fn analyzeProject(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options) std.mem.Allocator.Error!AnalysisResult {
    for (sources, 0..) |source, index| {
        var parsed = try parse(allocator, source.source, source.path);

        defer parsed.deinit();

        var issue: ?Diagnostic = null;

        if (parsed.value == .diagnostic) issue = parsed.value.diagnostic else {
            const input = parsed.value.parsed;

            issue = lint.checkNames(input.ast);

            if (issue == null) {
                const changes = try lint.spacing.edits(allocator, input.source, input.lexed.comments, input.ast);

                defer allocator.free(changes);

                if (changes.len != 0) issue = .{ .code = .spacing, .span = changes[0].span, .message = "blank lines do not match AST grouping; run zxc fmt" };
            }
        }

        if (issue) |*diagnostic| {
            diagnostic.source_index = index;

            return .{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .diagnostic = diagnostic.* } };
        }
    }

    return project.analyze(allocator, sources, options);
}

pub fn compileProject(allocator: std.mem.Allocator, sources: []const project.Source, options: project.Options) std.mem.Allocator.Error!Result {
    var analyzed = try analyzeProject(allocator, sources, options);

    defer analyzed.deinit();

    return switch (analyzed.value) {
        .diagnostic => |issue| .{ .diagnostic = issue },
        .ir => |program| .{ .source = zig.emit(allocator, program) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.InvalidIr => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid project IR" } },
            error.NativeRequiresBundle => return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use analyzeProject with zig.emitBundle" } },
            error.UnverifiedContracts => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "formal contract verification is required before code generation" } },
        } },
    };
}
