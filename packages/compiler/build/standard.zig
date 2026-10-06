const std = @import("std");
const Module = struct { specifier: []const u8, path: []const u8, module: []const u8, namespace: []const []const u8, implementation_path: []const u8 };

pub fn create(b: *std.Build) *std.Build.Module {
    return generate(b) catch @panic("unable to package standard module declarations");
}

fn generate(b: *std.Build) !*std.Build.Module {
    b.dependOnFileContents(b.path("standard/modules.json"));

    const manifest_path = try b.root.joinString(b.allocator, "standard/modules.json");
    const manifest = try std.Io.Dir.cwd().readFileAlloc(b.graph.io, manifest_path, b.allocator, .limited(1024 * 1024));
    const modules = try std.json.parseFromSliceLeaky([]const Module, b.allocator, manifest, .{});
    const files = b.addWriteFiles();
    var entries: std.ArrayList(struct { specifier: []const u8, path: []const u8, source: []const u8, module: []const u8, namespace: []const []const u8, implementation_path: []const u8 }) = .empty;

    for (modules, 0..) |module, index| {
        const destination = b.fmt("interfaces/{d}.d.zx", .{index});
        _ = files.addCopyFile(b.path(b.fmt("standard/{s}", .{module.path})), destination);

        try entries.append(b.allocator, .{
            .specifier = module.specifier,
            .path = b.fmt("standard/{s}", .{module.path}),
            .source = destination,
            .module = module.module,
            .namespace = module.namespace,
            .implementation_path = module.implementation_path,
        });
    }

    const tool = b.addExecutable(.{ .name = "standard-catalog", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_catalog.zig"),
        .target = b.graph.host,
        .optimize = .fast,
        .imports = &.{.{ .name = "genz", .module = b.dependency("genz", .{ .target = b.graph.host, .optimize = .fast }).module("genz") }},
    }) });

    const inputs = b.addWriteFiles();
    const run = b.addRunArtifact(tool);

    run.addFileArg(inputs.add("catalog.json", try std.json.Stringify.valueAlloc(b.allocator, entries.items, .{})));

    const generated = run.addOutputFileArg("catalog.zig");

    return b.createModule(.{ .root_source_file = files.addCopyFile(generated, "catalog.zig") });
}
