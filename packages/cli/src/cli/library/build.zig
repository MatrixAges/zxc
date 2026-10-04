const std = @import("std");
const compiler = @import("compiler");
const Compile = @import("../compile.zig");
const Loaded = @import("../project.zig").Loaded;
const Inputs = @import("../watch/inputs.zig");

pub fn run(context: Compile.Context, loaded: Loaded, inputs: *Inputs) !Compile.Status {
    const allocator = context.allocator;
    var analyzed = (try @import("analyze.zig").run(allocator, .{ .io = context.io, .loaded = loaded, .writer = context.stderr, .inputs = inputs })) orelse return .failed;

    defer analyzed.deinit();

    var library = try analyzed.link(allocator);

    defer library.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;

    for (analyzed.modules) |module| try sources.appendSlice(allocator, module.sources);

    var cache = try @import("../generation_cache.zig").init(context.io, allocator, loaded.project.root_dir);

    defer cache.deinit();

    var dependencies: std.ArrayList([]const u8) = .empty;

    const emitted = try compiler.emitLibraryVerified(allocator, .{
        .io = context.io,
        .sources = sources.items,
        .project = loaded.project,
        .generation_cache = if (context.options.cache) &cache else null,
        .solver = context.options.solver,
        .writer = context.stderr,
        .dependencies = &dependencies,
    }, &library);

    var bundle = switch (emitted) {
        .bundle => |value| value,
        .diagnostic => |issue| {
            defer issue.deinit();

            try context.stderr.print("{s}: {t}: {s}\n", .{ context.options.input, issue.code, issue.message });

            return .failed;
        },
    };

    defer bundle.deinit();

    try @import("../generation_cache.zig").report(&cache, context.options, context.stderr);

    const toolchain = try @import("../toolchain.zig").resolve(context.io, allocator, context.environment);
    const native_project = try @import("../standard.zig").resolve(allocator, loaded, dependencies.items, toolchain.standard);
    var random: [16]u8 = undefined;

    std.Io.random(context.io, &random);

    const name = std.fmt.bytesToHex(random, .lower);
    const staging = try std.fs.path.resolve(allocator, &.{ inputs.cwd, ".zxc", "build", "library", &name });

    try std.Io.Dir.cwd().createDirPath(context.io, staging);

    defer std.Io.Dir.cwd().deleteTree(context.io, staging) catch {};

    try @import("publish.zig").write(context.io, allocator, staging, &library, bundle, native_project, inputs);

    if (!try @import("../watch/library.zig").publish(context.io, allocator, staging, context.options.output.?, inputs)) {
        if (context.watch != null) return .retry;

        return error.LibraryInputsChanged;
    }

    return .success;
}
