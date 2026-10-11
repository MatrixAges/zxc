const std = @import("std");

const driver = "/usr/bin/xcrun";

/// Links a partitioned zxc with the platform toolchain when building for the macOS host. Zig 0.17's Mach-O
/// linker needs about 3 s for the partition and host objects and records the host object's debug map entry as
/// N_SO instead of N_OSO, which leaves its stack traces unsymbolized; Apple's linker, driven by clang for the
/// SDK and system library paths, links the same inputs in about 0.3 s with a correct debug map. Returns null
/// to keep Zig's linker, as on other platforms.
pub fn link(b: *std.Build, target: std.Build.ResolvedTarget, entry: *std.Build.Step.Compile, inputs: []const *std.Build.Step.Compile) ?std.Build.LazyPath {
    const host = b.graph.host.result;

    if (host.os.tag != .macos or target.result.os.tag != .macos or target.result.cpu.arch != host.cpu.arch) return null;

    std.Io.Dir.cwd().access(b.graph.io, driver, .{}) catch return null;

    const minimum = target.result.os.version_range.semver.min;
    const command = b.addSystemCommand(&.{
        driver,
        "clang",
        "-arch",
        if (target.result.cpu.arch == .aarch64) "arm64" else @tagName(target.result.cpu.arch),
        b.fmt("-mmacosx-version-min={d}.{d}", .{ minimum.major, minimum.minor }),
        "-Wl,-stack_size,0x1000000",
        "-o",
    });

    const output = command.addOutputFileArg("zxc");

    command.addArtifactArg(entry);

    for (inputs) |input| command.addArtifactArg(input);

    return output;
}
