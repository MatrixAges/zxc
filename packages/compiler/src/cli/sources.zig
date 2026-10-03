const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");

pub fn read(io: std.Io, allocator: std.mem.Allocator, source: []const u8, project: compiler.project.Options) ![]const compiler.project.Source {
    var sources: std.ArrayList(compiler.project.Source) = .empty;

    try sources.append(allocator, .{ .path = project.entry, .source = source });

    var index: usize = 0;

    while (index < sources.items.len) : (index += 1) {
        const item = sources.items[index];
        var parsed = try compiler.parse(allocator, item.source, item.path);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) continue;

        for (parsed.value.parsed.ast.imports) |imported| {
            var reporter: zx.Reporter = .{};

            const path = compiler.project.resolveImport(allocator, item.path, imported.path, project, &reporter, imported.span) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                continue;
            };

            var found = false;

            for (sources.items) |existing| if (std.mem.eql(u8, existing.path, path)) {
                found = true;

                break;
            };

            if (found) continue;

            const text = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(16 * 1024 * 1024)) catch |err| switch (err) {
                error.FileNotFound => continue,
                else => return err,
            };

            try sources.append(allocator, .{ .path = path, .source = text });
        }
    }

    return sources.toOwnedSlice(allocator);
}
