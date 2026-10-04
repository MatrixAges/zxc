const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const artifacts = @import("artifacts.zig");

pub fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, sources: []const compiler.project.Source, project: compiler.project.Options, cache: *compiler.project.ParseCache) !void {
    for (sources, 0..) |source, index| {
        const canonical_path = try std.fs.path.resolve(allocator, &.{ project.root_dir, source.path });

        defer allocator.free(canonical_path);

        const parsed = try cache.get(source.source, canonical_path);

        if (parsed.value == .diagnostic) return error.InvalidLibrarySource;

        var buffer: std.Io.Writer.Allocating = .init(allocator);
        const writer = &buffer.writer;
        var offset: usize = 0;

        for (parsed.value.parsed.ast.imports) |imported| {
            const kind = try compiler.project.specifier.classify(imported.path);

            const replacement = if (kind == .file or kind == .package) file: {
                var reporter: zx.Reporter = .{};
                const path = try compiler.project.resolveImport(allocator, source.path, imported.path, project, &reporter, imported.span);

                for (sources, 0..) |candidate, candidate_index| {
                    if (std.mem.eql(u8, candidate.path, path)) break :file try std.fmt.allocPrint(allocator, "./module_{d}.zx", .{candidate_index});
                }

                return error.MissingLibrarySource;
            } else native: {
                for (compiler.project.package_scope.nativeInterfaces(project.package_scopes, canonical_path, project.native_interfaces)) |entry| {
                    if (std.mem.eql(u8, entry.specifier, imported.path)) break :native entry.key();
                }

                const owner = compiler.project.package_scope.owner(project.package_scopes, canonical_path) orelse continue;

                for (project.package_scopes[owner].externals) |entry| {
                    if (std.mem.eql(u8, entry.specifier, imported.path)) break :native try @import("project/identity.zig").declaration(allocator, project.package_scopes[owner].root, entry.specifier);
                }

                continue;
            };

            try writer.writeAll(source.source[offset..imported.span.start]);
            try writer.writeAll(if (imported.kind == .type_only) "import type " else "import ");
            if (imported.kind != .function) try writer.writeAll("{ ");

            for (imported.names, 0..) |name, name_index| {
                if (name_index != 0) try writer.writeAll(", ");
                try writer.writeAll(name.text);
            }

            if (imported.kind != .function) try writer.writeAll(" }");
            try writer.print(" from \"{f}\"", .{std.zig.fmtString(replacement)});

            offset = imported.span.end;
        }

        try writer.writeAll(source.source[offset..]);
        try artifacts.write(io, try std.fmt.allocPrint(allocator, "{s}/source/module_{d}.zx", .{ directory, index }), buffer.written());
    }
}
