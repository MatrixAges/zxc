const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.option(
        std.builtin.Optimize,
        "optimize",
        "Prioritize performance, safety, or binary size",
    ) orelse .safe;

    const compiler_module = b.addModule("zxc_compiler", .{
        .root_source_file = b.path("src/compiler.zig"),
        .target = target,
        .optimize = optimize,
    });

    const executable = b.addExecutable(.{
        .name = "zxc",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "zxc_compiler", .module = compiler_module },
            },
        }),
    });
    b.installArtifact(executable);

    const run_command = b.addRunArtifact(executable);
    run_command.step.dependOn(b.getInstallStep());
    run_command.addPassthruArgs();
    const run_step = b.step("run", "Compile a ZX source file");
    run_step.dependOn(&run_command.step);

    const compile_fixture = b.addRunArtifact(executable);
    compile_fixture.addArg("tests/fixtures/order_quote.zx");
    compile_fixture.addFileInput(b.path("tests/fixtures/order_quote.zx"));
    compile_fixture.setCwd(b.path("."));
    compile_fixture.stdio = .inherit;

    const fixture_module = b.createModule(.{
        .root_source_file = b.path(".zxc/tests/fixtures/order_quote.zig"),
        .target = target,
        .optimize = optimize,
    });
    const test_module = b.createModule(.{
        .root_source_file = b.path("tests/order_quote_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "subject", .module = fixture_module },
        },
    });
    const tests = b.addTest(.{ .root_module = test_module });
    tests.step.dependOn(&compile_fixture.step);
    const run_tests = b.addRunArtifact(tests);
    const report_success = b.addSystemCommand(&.{
        "printf",
        "[PASS] 3/3 ZX compiler integration tests passed.\n",
    });
    report_success.step.dependOn(&run_tests.step);

    const test_step = b.step("test", "Compile ZX and run three Zig integration tests");
    test_step.dependOn(&report_success.step);
}
