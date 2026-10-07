const std = @import("std");

pub fn build(b: *(std).Build) void {
    const target = (b).standardTargetOptions(.{ });
    const optimize = (b).standardOptimizeOption(.{ });
    const abi = (b).createModule(.{ .root_source_file = (b).path("abi.zig"), .target = target, .optimize = optimize, });
    const native_0 = (b).createModule(.{ .root_source_file = (b).path("native/rx_ast/source/native.zig"), .target = target, .optimize = optimize, .link_libc = false, });
    const view_0 = (b).createModule(.{ .root_source_file = (b).path("abi_views/zxc_abi_view_rx_ast.zig"), .target = target, .optimize = optimize, });

    (view_0).addImport("zxc_abi_canonical", abi);
    (native_0).addImport("zxc_abi", view_0);

    const native_1 = (b).createModule(.{ .root_source_file = (b).path("native/dsl/source/root.zig"), .target = target, .optimize = optimize, .link_libc = false, });
    const view_1 = (b).createModule(.{ .root_source_file = (b).path("abi_views/zxc_abi_view_dsl.zig"), .target = target, .optimize = optimize, });

    (view_1).addImport("zxc_abi_canonical", abi);
    (native_1).addImport("zxc_abi", view_1);
    const generated_0 = (b).createModule(.{ .root_source_file = (b).path("modules/zxc_module_a9b705cba4ccfbc708476a1e82b8520cc22e737ef551a3e19489e429698328e0.zig"), .target = target, .optimize = optimize, });

    (generated_0).addImport("zxc_abi", abi);
    const generated_1 = (b).createModule(.{ .root_source_file = (b).path("modules/zxc_module_95cbeec76a97291d65f33889795ab6606b1ed785867a8e05643f6a2e92135a87.zig"), .target = target, .optimize = optimize, });

    (generated_1).addImport("zxc_abi", abi);
    const generated_2 = (b).createModule(.{ .root_source_file = (b).path("modules/zxc_module_5a81e1912231a71f1b90f905e933faf58698ff17d6743a9c7b7d83dce4c8856c.zig"), .target = target, .optimize = optimize, });
    (generated_2).addImport("zxc_abi", abi);
    (generated_0).addImport("rx_ast", native_0);
    (generated_2).addImport("zxc_module_95cbeec76a97291d65f33889795ab6606b1ed785867a8e05643f6a2e92135a87", generated_1);
    (generated_2).addImport("zxc_module_a9b705cba4ccfbc708476a1e82b8520cc22e737ef551a3e19489e429698328e0", generated_0);
    (native_0).addImport("dsl", native_1);

    const public_0 = (b).addModule("library", .{ .root_source_file = (b).path("root.zig"), .target = target, .optimize = optimize, });

    (public_0).addImport("zxc_abi", abi);
    (public_0).addImport("zxc_module_5a81e1912231a71f1b90f905e933faf58698ff17d6743a9c7b7d83dce4c8856c", generated_2);
}

