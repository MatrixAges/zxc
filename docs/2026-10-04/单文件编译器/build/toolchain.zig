const std = @import("std");
const model = @import("toolchain/manifest.zig");

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, index: std.Build.LazyPath) *std.Build.Module {
    return generate(b, target, index) catch |err| std.debug.panic("unable to prepare bundled Zig: {s}", .{@errorName(err)});
}

fn generate(b: *std.Build, target: std.Build.ResolvedTarget, index: std.Build.LazyPath) !*std.Build.Module {
    const archive = b.option([]const u8, "zig-archive", "Official Zig archive for the zxc host; otherwise downloaded at build time");
    var files: std.ArrayList(model.File) = .empty;

    b.addNamedLazyPath("zig_license", b.path("build/toolchain/license.txt"));

    try files.append(b.allocator, .{ .source = b.dependency("libyaml", .{}).path("License").getPath(b), .destination = "licenses/libyaml.txt" });
    try @import("toolchain/files.zig").append(b, &files, b.path("standard/src").getPath(b), "standard/src");

    std.mem.sort(model.File, files.items, {}, @import("toolchain/files.zig").lessThan);

    const tool = b.addExecutable(.{ .name = "bundle-zig", .root_module = b.createModule(.{
        .root_source_file = b.path("build/toolchain/pack.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseFast,
    }) });

    const manifest = model.Manifest{
        .host = b.fmt("{s}-{s}", .{ @tagName(target.result.cpu.arch), @tagName(target.result.os.tag) }),
        .files = files.items,
    };

    const generated = b.addWriteFiles();
    const run = b.addRunArtifact(tool);

    run.addFileArg(generated.add("bundle_manifest.json", try std.json.Stringify.valueAlloc(b.allocator, manifest, .{})));
    run.addFileArg(index);

    if (archive) |path| run.addFileArg(.{ .cwd_relative = path }) else run.addArg("");
    for (files.items) |file| run.addFileInput(.{ .cwd_relative = file.source });

    const output = run.addOutputDirectoryArg("bundle");

    return b.createModule(.{ .root_source_file = output.path(b, "resources.zig") });
}
