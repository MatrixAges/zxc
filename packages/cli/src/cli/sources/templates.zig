const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const Inputs = @import("../watch/inputs.zig");

pub fn prepare(io: std.Io, allocator: std.mem.Allocator, source: compiler.project.Source, project: compiler.project.Options, inputs: ?*Inputs) !compiler.project.Source {
    var reporter: zx.Reporter = .{};

    const references = compiler.project.resources.references(allocator, source.source, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return source;
    };

    if (references.len == 0) return source;

    var resources: std.ArrayList(compiler.project.Resource) = .empty;
    const owner = try std.fs.path.resolve(allocator, &.{ project.root_dir, source.path });

    for (references) |reference| {
        const path = compiler.project.resources.resolve(allocator, owner, reference, project, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            continue;
        };

        var found = false;

        for (resources.items) |resource| if (std.mem.eql(u8, resource.path, path)) {
            found = true;

            break;
        };

        if (found) continue;
        if (inputs) |observed| try observed.add(io, path);

        @import("../../package/source.zig").validateWithInputs(io, allocator, path, project.package_scopes, inputs) catch |err| switch (err) {
            error.FileNotFound => continue,
            else => return err,
        };

        const text = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(16 * 1024 * 1024)) catch |err| switch (err) {
            error.FileNotFound => continue,
            else => return err,
        };

        if (inputs) |observed| try observed.record(io, path, text);
        try resources.append(allocator, .{ .path = path, .source = text });
    }

    var input = source;

    input.templates = resources.items;

    return compiler.project.resources.expandReferences(allocator, input, references, project, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return input;
    };
}
