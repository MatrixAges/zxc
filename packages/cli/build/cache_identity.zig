const std = @import("std");

/// The directory holding the identity as `digest.zig` and `cache_identity.s` (see `cache_identity/digest.zig`).
pub const Identity = struct {
    directory: std.Build.LazyPath,

    /// A module declaring `digest`, for units that embed the identity.
    pub fn module(self: Identity, b: *std.Build) *std.Build.Module {
        return b.createModule(.{ .root_source_file = self.directory.path(b, "digest.zig") });
    }

    /// An assembly source defining the `zxc_cache_identity` symbol, for a platform link.
    pub fn assembly(self: Identity, b: *std.Build) std.Build.LazyPath {
        return self.directory.path(b, "cache_identity.s");
    }
};

/// Fingerprints the compiler sources in a build step, so editing them leaves the build configuration cached.
pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, compiler: *std.Build.Dependency) Identity {
    const tool = b.addExecutable(.{ .name = "cache-identity", .root_module = b.createModule(.{
        .root_source_file = b.path("build/cache_identity/digest.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseFast,
    }) });

    const run = b.addRunArtifact(tool);
    const directory = run.addOutputDirectoryArg("identity");

    run.addArgs(&.{ "text", @import("builtin").zig_version_string, "text", target.result.zigTriple(b.allocator) catch @panic("out of memory"), "text", @tagName(optimize) });

    source(run, "directory", "cli", b.path("src"));
    source(run, "directory", "cli-build", b.path("build"));
    source(run, "file", "cli/build.zig", b.path("build.zig"));
    source(run, "file", "cli/build.zig.zon", b.path("build.zig.zon"));
    source(run, "file", "standard/modules.json", compiler.path("standard/modules.json"));
    source(run, "directory", "standard/interfaces", compiler.path("standard/interfaces"));

    for ([_][]const u8{ "compiler", "core", "dsl", "lint", "genz", "pkgs", "napi" }) |name| {
        const dependency = if (std.mem.eql(u8, name, "compiler")) compiler else if (std.mem.eql(u8, name, "lint"))
            b.dependency("lint", .{ .target = target, .optimize = optimize, .generated_name = compiler.namedLazyPath("naming") })
        else
            b.dependency(name, .{ .target = target, .optimize = optimize });

        source(run, "directory", name, dependency.path("src"));
        source(run, "file", b.fmt("{s}/build.zig", .{name}), dependency.path("build.zig"));
        source(run, "file", b.fmt("{s}/build.zig.zon", .{name}), dependency.path("build.zig.zon"));

        if (std.mem.eql(u8, name, "lint")) source(run, "directory", "lint-bootstrap", dependency.path("bootstrap"));

        if (std.mem.eql(u8, name, "compiler")) {
            source(run, "directory", "compiler-build", dependency.path("build"));
            source(run, "directory", "compiler-bootstrap", dependency.path("bootstrap"));
        }
    }

    // The tool reads the sources itself on every build; hashing about 10 MB on every core takes milliseconds.
    run.has_side_effects = true;

    return .{ .directory = directory };
}

fn source(run: *std.Build.Step.Run, kind: []const u8, name: []const u8, path: std.Build.LazyPath) void {
    run.addArgs(&.{ kind, name });

    if (std.mem.eql(u8, kind, "directory")) run.addDirectoryArg(path) else run.addFileArg(path);
}
