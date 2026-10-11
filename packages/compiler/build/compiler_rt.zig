const std = @import("std");

pub fn configure(b: *std.Build, executable: *std.Build.Step.Compile) void {
    const root = executable.root_module;

    if (root.optimize != .small) return;

    const object = b.addObject(.{
        .name = "host-compiler-rt",
        .root_module = b.createModule(.{
            .root_source_file = std.Build.LazyPath.zig_lib.path(b, "compiler_rt.zig"),
            .target = root.resolved_target.?,
            .optimize = .fast,
            .no_builtin = true,
            .link_libc = root.link_libc,
            .pic = root.pic,
        }),
        .use_llvm = true,
    });

    object.bundle_compiler_rt = false;
    executable.bundle_compiler_rt = false;

    root.addObject(object);
}
