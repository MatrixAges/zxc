const std = @import("std");

pub fn create(b: *std.Build, optimize: std.builtin.OptimizeMode) *std.Build.Step.Compile {
    const target = b.graph.host;
    const generator_optimize: std.builtin.OptimizeMode = if (optimize == .debug) .fast else optimize;
    const core = b.dependency("core", .{ .target = target, .optimize = generator_optimize }).module("core");
    const lint = b.dependency("lint", .{ .target = target, .optimize = generator_optimize, .seed = true }).module("lint");

    const lexer = b.createModule(.{
        .root_source_file = b.path("bootstrap/lexer/lex.zig"),
        .target = target,
        .optimize = generator_optimize,
        .imports = &.{.{ .name = "zx", .module = core }},
    });

    const seed = @import("compiler.zig").create(b, target, generator_optimize, lexer, null, lint);
    const flow = @import("seed_rx.zig").create(b, target, generator_optimize, seed.frontend, lint);
    // The root module selects LLVM's pipeline for the whole tool; small compiles it much faster, while every
    // imported module keeps safe so the compiler code still runs with its runtime safety checks.
    const generator_root: std.builtin.OptimizeMode = if (optimize == .debug or optimize == .safe) .small else optimize;

    const executable = b.addExecutable(.{
        .name = "generate-parser",
        .root_module = b.createModule(.{
            .root_source_file = b.path("build/generate_parser.zig"),
            .target = target,
            .optimize = generator_root,
            // Keep symbols for debugging and profiling outside ReleaseSmall.
            .strip = optimize == .small,
            .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = flow.syntax }, .{ .name = "rx_analysis", .module = flow.analysis } },
        }),
    });

    @import("compiler_rt.zig").configure(b, executable);

    return executable;
}
