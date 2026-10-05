const std = @import("std");
const Compile = @import("../compile.zig");

pub fn run(context: Compile.Context) !Compile.Status {
    return execute(context) catch |err| {
        if (err == error.OutOfMemory or err == error.Canceled) return err;
        try context.stderr.print("{s}: workspace lint: {s}\n", .{ context.options.input, @errorName(err) });

        return .failed;
    };
}

fn execute(context: Compile.Context) !Compile.Status {
    const path = context.options.input;

    if (!std.mem.eql(u8, std.fs.path.basename(path), "pkg.yaml")) return error.WorkspaceManifestRequired;

    var workspace = try @import("../../package/workspace.zig").load(context.io, context.allocator, path);

    defer workspace.deinit();

    if (workspace.diagnostic) |message| {
        try context.stderr.print("{s}\n", .{message});

        return .failed;
    }

    var graph = try @import("../../package/graph.zig").load(context.io, context.allocator, path);

    defer graph.deinit();

    if (graph.diagnostic) |message| {
        try context.stderr.print("{s}\n", .{message});

        return .failed;
    }

    const root_manifest = try std.Io.Dir.cwd().realPathFileAlloc(context.io, path, context.allocator);

    defer context.allocator.free(root_manifest);

    var succeeded = true;

    for (workspace.packages) |package| {
        const member = try std.fs.path.resolve(context.allocator, &.{ graph.root, package.path, "pkg.yaml" });

        defer context.allocator.free(member);

        var selected = context;

        selected.options.input = member;
        selected.options.project = root_manifest;
        selected.options.workspace_lint = false;
        selected.options.semantic_lint = true;

        const status = if (package.manifest.entry != null or package.manifest.exports.len != 0)
            try @import("semantic.zig").run(selected)
        else
            try @import("../configuration/root.zig").run(selected);

        succeeded = status == .success and succeeded;
    }

    return if (succeeded) .success else .failed;
}
