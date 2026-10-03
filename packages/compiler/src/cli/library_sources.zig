const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const artifacts = @import("artifacts.zig");

pub fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, sources: []const compiler.project.Source, project: compiler.project.Options) !void {
    for (sources, 0..) |source, index| {
        var parsed = try compiler.parse(allocator, source.source, source.path);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) return error.InvalidLibrarySource;

        var buffer: std.Io.Writer.Allocating = .init(allocator);
        const writer = &buffer.writer;
        var offset: usize = 0;

        for (parsed.value.parsed.ast.imports) |imported| {
            const kind = try compiler.project.specifier.classify(imported.path);

            if (kind != .file and kind != .package) continue;

            var reporter: zx.Reporter = .{};
            const path = try compiler.project.resolveImport(allocator, source.path, imported.path, project, &reporter, imported.span);
            var target: ?usize = null;

            for (sources, 0..) |candidate, candidate_index| {
                if (std.mem.eql(u8, candidate.path, path)) {
                    target = candidate_index;

                    break;
                }
            }

            const target_index = target orelse return error.MissingLibrarySource;

            try writer.writeAll(source.source[offset..imported.span.start]);
            try writer.writeAll(if (imported.kind == .type_only) "import type " else "import ");
            if (imported.kind != .function) try writer.writeAll("{ ");

            for (imported.names, 0..) |name, name_index| {
                if (name_index != 0) try writer.writeAll(", ");
                try writer.writeAll(name.text);
            }

            if (imported.kind != .function) try writer.writeAll(" }");
            try writer.print(" from \"./module_{d}.zx\";", .{target_index});

            offset = imported.span.end;
        }

        try writer.writeAll(source.source[offset..]);
        try artifacts.write(io, try std.fmt.allocPrint(allocator, "{s}/source/module_{d}.zx", .{ directory, index }), buffer.written());
    }
}
