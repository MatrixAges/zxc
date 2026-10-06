const std = @import("std");
const compiler = @import("compiler");
pub const Result = struct { analysis: compiler.AnalysisResult, context_digest: [32]u8 };
const source = "import type { Mode } from \"zig:choice\"\nexport type Seed = { value: u64, mode: Mode, enabled: bool }\n";

pub fn analyze(allocator: std.mem.Allocator, helper: []const u8) !Result {
    const interfaces = &.{compiler.project.NativeInterface{ .specifier = "zig:choice", .path = "choice.d.zx", .source = @embedFile("choice.d.zx"), .module = "choice" }};
    var seed = try compiler.project.analyze(allocator, &.{.{ .path = "seed.zx", .source = source }}, .{ .entry = "seed.zx", .root_dir = "/project", .native_interfaces = interfaces });

    defer seed.deinit();

    if (seed.value == .diagnostic) std.debug.print("seed diagnostic: {s}\n", .{seed.value.diagnostic.message});
    if (seed.value != .ir) return error.InvalidSeed;

    const context: compiler.Context = .{ .types = seed.value.ir.types, .nominal_types = seed.nominal_types, .native_modules = seed.value.ir.native_modules };
    const digest = try compiler.project.SemanticCache.contextDigest(allocator, context);
    const same = try compiler.project.SemanticCache.contextDigest(allocator, context);

    if (!std.mem.eql(u8, &digest, &same)) return error.NonDeterministicContextDigest;
    if (context.native_modules.len == 0) return error.MissingNativeContext;

    const changed = try allocator.dupe(compiler.ir.NativeModule, context.native_modules);

    defer allocator.free(changed);

    changed[0].import_name = "different_choice";
    var alternate = context;
    alternate.native_modules = changed;

    const different = try compiler.project.SemanticCache.contextDigest(allocator, alternate);

    if (std.mem.eql(u8, &digest, &different)) return error.MissingNativeContextDigest;

    var analysis = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = @embedFile("main.zx") },
        .{ .path = "helper.zx", .source = helper },
        .{ .path = "types.zx", .source = @embedFile("types.zx") },
    }, .{ .entry = "main.zx", .root_dir = "/project", .native_interfaces = interfaces, .context = context });

    errdefer analysis.deinit();

    if (analysis.value == .diagnostic) std.debug.print("mixed diagnostic: {s}\n", .{analysis.value.diagnostic.message});
    if (analysis.value != .ir) return error.InvalidMixedAnalysis;

    return .{ .analysis = analysis, .context_digest = digest };
}
