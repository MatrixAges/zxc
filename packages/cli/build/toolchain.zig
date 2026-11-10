const std = @import("std");
const model = @import("toolchain/manifest.zig");
/// The generated bundle module, and the official Zig archive it embeds.
pub const Bundle = struct { module: *std.Build.Module, zig_archive: std.Build.LazyPath };

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, index: std.Build.LazyPath, standard_source: std.Build.Cache.Path, metadata_tool: std.Build.LazyPath) Bundle {
    return generate(b, target, index, standard_source, metadata_tool) catch |err| std.debug.panic("unable to prepare bundled Zig: {s}", .{@errorName(err)});
}

fn generate(b: *std.Build, target: std.Build.ResolvedTarget, index: std.Build.LazyPath, standard_source: std.Build.Cache.Path, metadata_tool: std.Build.LazyPath) !Bundle {
    const archive = b.option([]const u8, "zig-archive", "Official Zig archive for the zxc host; otherwise downloaded at build time") orelse "";
    var files: std.ArrayList(model.File) = .empty;

    b.addNamedLazyPath("zig_license", b.path("build/toolchain/license.txt"));

    try files.append(b.allocator, .{ .source = try b.dependency("libyaml", .{}).builder.root.joinString(b.allocator, "License"), .destination = "licenses/libyaml.txt" });
    try @import("toolchain/files.zig").append(b, &files, try standard_source.toString(b.allocator), "standard/src");

    std.mem.sort(model.File, files.items, {}, @import("toolchain/files.zig").lessThan);

    const tool = b.addExecutable(.{ .name = "bundle-zig", .root_module = b.createModule(.{
        .root_source_file = b.path("build/toolchain/pack.zig"),
        .target = b.graph.host,
        .optimize = .small,
        .imports = &.{.{ .name = "genz", .module = b.dependency("genz", .{ .target = b.graph.host, .optimize = .fast }).module("genz") }},
    }) });

    const pack_options = b.addOptions();

    pack_options.addOption(bool, "local_archive", archive.len != 0);
    tool.root_module.addOptions("pack_options", pack_options);

    const manifest = model.Manifest{
        .host = b.fmt("{s}-{s}", .{ @tagName(target.result.cpu.arch), @tagName(target.result.os.tag) }),
        .files = files.items,
    };

    const generated = b.addWriteFiles();
    const run = b.addRunArtifact(tool);

    run.addFileArg(generated.add("bundle_manifest.json", try std.json.Stringify.valueAlloc(b.allocator, manifest, .{})));
    run.addFileArg(index);

    if (archive.len != 0) run.addFileArg(.{ .cwd_relative = archive }) else run.addArg("");
    for (files.items) |file| run.addFileInput(.{ .cwd_relative = file.source });

    const output = run.addOutputDirectoryArg("bundle");
    const metadata = b.addRunFile(metadata_tool);

    metadata.addArg("--resources");
    metadata.addFileArg(output.path(b, "resources.json"));

    const module = b.createModule(.{ .root_source_file = metadata.addOutputFileArg("resources.zig") });

    inline for (.{ "resources.tar.gz", "zig.archive", "index.json" }) |name| {
        module.addAnonymousImport(name, .{ .root_source_file = output.path(b, name) });
    }

    return .{ .module = module, .zig_archive = output.path(b, "zig.archive") };
}
