const std = @import("std");

pub const Inputs = struct {
    host: *std.Build.Module,
    yaml: *std.Build.Step.Compile,
    cache_identity: @import("cache_identity.zig").Identity,
    /// The module carrying the generated partition objects, or null when generated code is one unit.
    partitions: ?*std.Build.Module,
    /// The directory of the same partitions' objects from Zig's own backend, when the compiler package offers them.
    self_hosted_partitions: ?std.Build.LazyPath = null,
    partition_count: u32 = 0,
};

/// The zxc executable: a Zig artifact, or a file linked by the platform toolchain.
pub const Binary = union(enum) {
    artifact: *std.Build.Step.Compile,
    file: std.Build.LazyPath,

    pub fn path(self: Binary) std.Build.LazyPath {
        return switch (self) {
            .artifact => |artifact| artifact.getEmittedBin(),
            .file => |file| file,
        };
    }

    pub fn install(self: Binary, b: *std.Build) void {
        switch (self) {
            .artifact => |artifact| b.installArtifact(artifact),
            .file => |file| b.getInstallStep().dependOn(&b.addInstallBinFile(file, "zxc").step),
        }
    }

    pub fn run(self: Binary, b: *std.Build) *std.Build.Step.Run {
        return switch (self) {
            .artifact => |artifact| b.addRunArtifact(artifact),
            .file => |file| command: {
                const command = std.Build.Step.Run.create(b, "run zxc");

                command.addFileArg(file);

                break :command command;
            },
        };
    }
};

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, inputs: Inputs) Binary {
    const llvm_objects = inputs.partitions orelse {
        inputs.host.linkLibrary(inputs.yaml);

        return .{ .artifact = b.addExecutable(.{ .name = "zxc", .root_module = inputs.host }) };
    };

    // Zig's own backend needs Apple's linker for a runnable result, and the host object calling into its partitions
    // must come from the same backend. The entry library stays on LLVM: it only exports C symbols, and Apple's linker
    // rejects Zig's own archives.
    const system_link = @import("system_link.zig");
    const self_hosted = inputs.self_hosted_partitions != null and system_link.available(b, target);

    // With partitioned generated code the CLI is its own object as well, so a changed partition only relinks.
    const host = b.addObject(.{ .name = "zxc_host", .use_llvm = if (self_hosted) false else null, .root_module = b.createModule(.{
        .root_source_file = b.path("src/host/export.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "main", .module = inputs.host }},
    }) });

    const start = b.createModule(.{ .root_source_file = b.path("src/host/start.zig"), .target = target, .optimize = optimize, .link_libc = true });

    // The platform link defines the identity in an object of its own, so the entry unit stays cached across edits.
    start.addOptions("cache_identity", if (system_link.available(b, target)) b.addOptions() else inputs.cache_identity.options);

    const entry = b.addLibrary(.{ .name = "zxc_start", .linkage = .static, .root_module = start });
    var linked: std.ArrayList(*std.Build.Step.Compile) = .empty;

    // The platform link gets the runtimes Zig adds to its own executables from the entry library: compiler_rt,
    // and the sanitizer runtime the bundled C sources call in Debug.
    entry.bundle_compiler_rt = true;
    entry.bundle_ubsan_rt = true;
    var files: std.ArrayList(std.Build.LazyPath) = .empty;

    linked.append(b.allocator, host) catch @panic("OOM");

    if (self_hosted) {
        for (0..inputs.partition_count) |index| files.append(b.allocator, inputs.self_hosted_partitions.?.path(b, b.fmt("zxc_partition_{d}.o", .{index}))) catch @panic("OOM");
    } else for (llvm_objects.link_objects.items) |item| switch (item) {
        .other_step => |partition| linked.append(b.allocator, partition) catch @panic("OOM"),
        else => {},
    };

    linked.append(b.allocator, inputs.yaml) catch @panic("OOM");

    if (system_link.available(b, target)) return .{ .file = system_link.link(b, target, entry, linked.items, files.items, inputs.cache_identity.digest, self_hosted) };

    start.addObject(host);
    start.linkLibrary(inputs.yaml);
    start.addImport("zxc_generated_objects", llvm_objects);

    return .{ .artifact = b.addExecutable(.{ .name = "zxc", .root_module = start }) };
}
