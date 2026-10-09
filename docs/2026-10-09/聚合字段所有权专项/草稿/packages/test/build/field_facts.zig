const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-field-facts", "Validate mixed product ownership and loop fixed points");

    const case = b.createModule(.{
        .root_source_file = b.path("tests/ownership/reduce/check.zig"), .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    const analysis = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/field_facts/root.zig"), .target = target, .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "ownership_case", .module = case } },
    }) });

    analysis.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(analysis).step);

    const module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/field_facts/runtime/compile.zig"), .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    module.addAnonymousImport("library_output", .{ .root_source_file = b.path("tests/library/runtime/save.zig"), .target = target, .optimize = optimize });

    const tool = b.addExecutable(.{ .name = "compile-field-facts", .root_module = module });

    for ([_][]const u8{ "object", "tuple", "reduce", "feedback", "discard_object", "discard_tuple", "discard_optional", "discard_post" }) |kind| {
        for ([_][]const u8{ "source", "library" }) |route| {
            const generate = b.addRunArtifact(tool);

            generate.addFileArg(b.path(b.fmt("tests/ownership/field_facts/runtime/fixtures/{s}.zx", .{kind})));
            generate.addArg(route);

            const directory = generate.addOutputDirectoryArg(b.fmt("{s}-{s}", .{ kind, route }));

            generate.addFileArg(b.path("tests/ownership/field_facts/runtime/fixtures/seed_tuple.zx"));
            generate.addFileArg(b.path("tests/ownership/field_facts/runtime/fixtures/seed_optional.zx"));

            const run = b.addSystemCommand(&.{"node"});

            run.addFileArg(b.path("tests/ownership/field_facts/runtime/run_test.ts"));
            run.addArg(b.graph.zig_exe);
            run.addDirectoryArg(directory);
            run.addFileArg(b.path(if (std.mem.startsWith(u8, kind, "discard_")) "tests/ownership/field_facts/runtime/discard_test.zig" else "tests/ownership/field_facts/runtime/root.zig"));
            run.addArg(@tagName(optimize));
            run.addFileArg(b.path("tests/support/allocation_testing.zig"));
            run.addArg(kind);

            run.has_side_effects = true;

            step.dependOn(&run.step);
        }
    }

    return step;
}
