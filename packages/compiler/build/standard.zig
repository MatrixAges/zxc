const std = @import("std");
const Module = struct { specifier: []const u8, path: []const u8, fragments: []const []const u8 = &.{}, module: []const u8, namespace: []const []const u8, implementation_path: []const u8 };

pub fn create(b: *std.Build) *std.Build.Module {
    return generate(b) catch @panic("unable to package standard module declarations");
}

fn generate(b: *std.Build) !*std.Build.Module {
    b.dependOnFileContents(b.path("standard/modules.json"));

    const manifest_path = try b.root.joinString(b.allocator, "standard/modules.json");
    const manifest = try std.Io.Dir.cwd().readFileAlloc(b.graph.io, manifest_path, b.allocator, .limited(1024 * 1024));
    const modules = try std.json.parseFromSliceLeaky([]const Module, b.allocator, manifest, .{});
    const files = b.addWriteFiles();
    var entries: std.ArrayList(struct { specifier: []const u8, path: []const u8, source: []const u8, text: ?[]const u8 = null, module: []const u8, namespace: []const []const u8, implementation_path: []const u8 }) = .empty;

    for (modules, 0..) |module, index| {
        const destination = b.fmt("interfaces/{d}.d.zx", .{index});
        const text = try fragments(b, module);

        if (text == null) _ = files.addCopyFile(b.path(b.fmt("standard/{s}", .{module.path})), destination);

        try entries.append(b.allocator, .{
            .specifier = module.specifier,
            .path = if (text == null) b.fmt("standard/{s}", .{module.path}) else module.specifier,
            .source = destination,
            .text = text,
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

fn fragments(b: *std.Build, module: Module) !?[]const u8 {
    if (module.fragments.len == 0) return null;

    var source: std.ArrayList(u8) = .empty;
    const paths = try b.allocator.alloc([]const u8, module.fragments.len + 1);

    paths[0] = module.path;

    @memcpy(paths[1..], module.fragments);

    for (paths) |path| {
        const relative = b.fmt("standard/{s}", .{path});

        b.dependOnFileContents(b.path(relative));

        const absolute = try b.root.joinString(b.allocator, relative);
        const bytes = try std.Io.Dir.cwd().readFileAlloc(b.graph.io, absolute, b.allocator, .unlimited);

        try source.appendSlice(b.allocator, bytes);
        try source.append(b.allocator, '\n');
    }

    return try source.toOwnedSlice(b.allocator);
}
