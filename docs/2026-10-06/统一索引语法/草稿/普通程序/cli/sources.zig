const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const Inputs = @import("watch/inputs.zig");
const Libraries = @import("library/inputs.zig");

pub fn read(io: std.Io, allocator: std.mem.Allocator, source: []const u8, project: compiler.project.Options, cache: *compiler.project.ParseCache) ![]const compiler.project.Source {
    return readWithInputs(io, allocator, source, project, cache, null);
}

pub fn readWithInputs(io: std.Io, allocator: std.mem.Allocator, source: []const u8, project: compiler.project.Options, cache: *compiler.project.ParseCache, inputs: ?*Inputs) ![]const compiler.project.Source {
    return readWithLibraries(io, allocator, source, project, cache, inputs, null);
}

pub fn readWithLibraries(io: std.Io, allocator: std.mem.Allocator, source: []const u8, project: compiler.project.Options, cache: *compiler.project.ParseCache, inputs: ?*Inputs, libraries: ?*Libraries) ![]const compiler.project.Source {
    var sources: std.ArrayList(compiler.project.Source) = .empty;

    if (inputs) |observed| try observed.add(io, project.entry);
    try @import("../package/source.zig").validateWithInputs(io, allocator, project.entry, project.package_scopes, inputs);
    if (inputs) |observed| try observed.record(io, project.entry, source);
    try sources.append(allocator, .{ .path = project.entry, .source = source });

    var index: usize = 0;

    while (index < sources.items.len) : (index += 1) {
        const item = sources.items[index];
        const canonical_path = try std.fs.path.resolve(allocator, &.{ project.root_dir, item.path });

        defer allocator.free(canonical_path);

        const parsed = try cache.getModule(item.source, canonical_path);

        if (parsed.diagnostic() != null) continue;

        const context = ImportContext{ .io = io, .allocator = allocator, .owner = item.path, .project = project, .sources = &sources, .inputs = inputs, .libraries = libraries };

        switch (parsed.*) {
            .native => |result| try readImports(zx.syntax.header.Native{ .program = result.value.parsed.ast }, context),
            .indexed => |*result| if (compiler.project.ParseCache.indexed_enabled) try readImports(result.header(), context) else unreachable,
        }
    }

    return sources.toOwnedSlice(allocator);
}

const ImportContext = struct {
    io: std.Io,
    allocator: std.mem.Allocator,
    owner: []const u8,
    project: compiler.project.Options,
    sources: *std.ArrayList(compiler.project.Source),
    inputs: ?*Inputs,
    libraries: ?*Libraries,
};

fn readImports(header: anytype, context: ImportContext) !void {
    for (0..header.importCount()) |index| {
        const imported = header.importAt(index);
        var reporter: zx.Reporter = .{};

        const target = compiler.project.resolveTarget(context.allocator, context.owner, imported.path, context.project, &reporter, imported.span) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            continue;
        };

        const path = switch (target) {
            .source => |path| path,
            .compiled => |compiled| {
                const collection = context.libraries orelse return error.CompiledLibraryLoaderRequired;

                try collection.add(context.io, compiled, context.project, context.inputs);

                continue;
            },
        };

        if (context.inputs) |observed| try observed.add(context.io, path);

        var found = false;

        for (context.sources.items) |existing| if (std.mem.eql(u8, existing.path, path)) {
            found = true;

            break;
        };

        if (found) continue;

        @import("../package/source.zig").validateWithInputs(context.io, context.allocator, path, context.project.package_scopes, context.inputs) catch |err| switch (err) {
            error.FileNotFound => continue,
            else => return err,
        };

        const text = std.Io.Dir.cwd().readFileAlloc(context.io, path, context.allocator, .limited(16 * 1024 * 1024)) catch |err| switch (err) {
            error.FileNotFound => continue,
            else => return err,
        };

        if (context.inputs) |observed| try observed.record(context.io, path, text);
        try context.sources.append(context.allocator, .{ .path = path, .source = text });
    }
}
