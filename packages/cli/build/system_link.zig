const std = @import("std");

const driver = "/usr/bin/xcrun";

/// Links a partitioned zxc with the platform toolchain where `available`. Zig 0.17's Mach-O linker needs about 3 s
/// for the partition and host objects and records the host object's debug map entry as N_SO instead of N_OSO, which
/// leaves its stack traces unsymbolized; Apple's linker, driven by clang for the SDK and system library paths, links
/// the same inputs in about 0.3 s with a correct debug map. Objects from Zig's own backend place data pointers at
/// unaligned offsets, which Apple's linker reports once per pointer before falling back from chained fixups; `quiet`
/// drops those warnings.
/// `identity` becomes the `zxc_cache_identity` symbol through an assembly source the driver assembles in the same
/// command.
pub fn link(b: *std.Build, target: std.Build.ResolvedTarget, entry: *std.Build.Step.Compile, inputs: []const *std.Build.Step.Compile, identity: [32]u8, quiet: bool) std.Build.LazyPath {
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

    command.addFileArg(b.addWriteFiles().add("cache_identity.s", assembly(b, identity)));

    return output;
}

fn assembly(b: *std.Build, identity: [32]u8) []const u8 {
    var bytes: std.Io.Writer.Allocating = .init(b.allocator);

    for (identity, 0..) |byte, index| bytes.writer.print("{s}{d}", .{ if (index == 0) "" else ",", byte }) catch @panic("OOM");

    return b.fmt(".section __TEXT,__const\n.globl _zxc_cache_identity\n_zxc_cache_identity:\n.byte {s}\n", .{bytes.written()});
}

/// Whether the platform link serves this build: a macOS host building for itself with the developer tools present;
/// other builds keep Zig's linker.
pub fn available(b: *std.Build, target: std.Build.ResolvedTarget) bool {
    const host = b.graph.host.result;

    if (host.os.tag != .macos or target.result.os.tag != .macos or target.result.cpu.arch != host.cpu.arch) return false;

    std.Io.Dir.cwd().access(b.graph.io, driver, .{}) catch return false;

    return true;
}
