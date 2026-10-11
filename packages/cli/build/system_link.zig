const std = @import("std");

const driver = "/usr/bin/xcrun";

/// Links a partitioned zxc with the platform toolchain where `available`. Zig 0.17's Mach-O linker needs about 3 s
/// for the partition and host objects and records the host object's debug map entry as N_SO instead of N_OSO, which
/// leaves its stack traces unsymbolized; Apple's linker, driven by clang for the SDK and system library paths, links
/// the same inputs in about 0.3 s with a correct debug map. Objects from Zig's own backend place data pointers at
/// unaligned offsets, which Apple's linker reports once per pointer before falling back from chained fixups; `quiet`
/// drops those warnings.
/// `identity` is an assembly source defining the `zxc_cache_identity` symbol, which the driver assembles in the same
/// command.
pub fn link(b: *std.Build, target: std.Build.ResolvedTarget, entry: *std.Build.Step.Compile, inputs: []const *std.Build.Step.Compile, objects: []const std.Build.LazyPath, identity: std.Build.LazyPath, quiet: bool) std.Build.LazyPath {
    const minimum = target.result.os.version_range.semver.min;
    const command = b.addSystemCommand(&.{
        driver,
        "clang",
        "-arch",
        if (target.result.cpu.arch == .aarch64) "arm64" else @tagName(target.result.cpu.arch),
        b.fmt("-mmacosx-version-min={d}.{d}", .{ minimum.major, minimum.minor }),
        "-Wl,-stack_size,0x1000000",
    });

    if (quiet) command.addArg("-Wl,-w");

    command.addArg("-o");

    const output = command.addOutputFileArg("zxc");

    command.addArtifactArg(entry);

    for (inputs) |input| command.addArtifactArg(input);
    for (objects) |object| command.addFileArg(object);

    command.addFileArg(identity);

    return output;
}

/// Whether the platform link serves this build: a macOS host building for itself with the developer tools present;
/// other builds keep Zig's linker.
pub fn available(b: *std.Build, target: std.Build.ResolvedTarget) bool {
    const host = b.graph.host.result;

    if (host.os.tag != .macos or target.result.os.tag != .macos or target.result.cpu.arch != host.cpu.arch) return false;

    std.Io.Dir.cwd().access(b.graph.io, driver, .{}) catch return false;

    return true;
}
