const std = @import("std");
const compiler = @import("compiler");
const Options = @import("options.zig").Options;

pub fn run(io: std.Io, allocator: std.mem.Allocator, sources: []const compiler.project.Source, project: compiler.project.Options, options: Options, writer: *std.Io.Writer, cache: *compiler.project.ParseCache) !bool {
    var analyzed = try compiler.analyzeProjectWithCache(allocator, sources, project, cache);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        try writer.print("verification: {s}\n", .{analyzed.value.diagnostic.message});

        return false;
    }

    return compiler.verification.check(io, allocator, analyzed.value.ir, sources, project.entry, .{ .solver = options.solver, .output = options.output }, writer);
}
