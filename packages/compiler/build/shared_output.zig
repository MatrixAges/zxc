const std = @import("std");
const compiler = @import("compiler");

pub fn write(io: std.Io, allocator: std.mem.Allocator, output: []const u8, bundle: compiler.zig.LibraryBundle) !void {
    var root: std.Io.Writer.Allocating = .init(allocator);

    defer root.deinit();

    try std.Io.Dir.cwd().createDirPath(io, output);
    try writeFile(io, allocator, output, "types.zig", bundle.types);
    for (bundle.modules) |module| try writeFile(io, allocator, output, module.name, module.source);

    for (bundle.public_modules) |module| {
        const name = try std.fmt.allocPrint(allocator, "{s}.zig", .{module.file.name});

        try writeFile(io, allocator, output, name, module.file.source);
        try root.writer.print("pub const {f} = @import(\"{f}\");\n", .{ std.zig.fmtId(module.name), std.zig.fmtString(name) });

        var adapter: std.Io.Writer.Allocating = .init(allocator);

        defer adapter.deinit();

        try adapter.writer.print("const entry = @import(\"generated\").{f};\n\n", .{std.zig.fmtId(module.name)});

        for ([_][]const u8{ "Input", "Output", "execute", "requires_io", "requires_process", "input_shape", "output_shape" }) |declaration| {
            try adapter.writer.print("pub const {s} = entry.{s};\n", .{ declaration, declaration });
        }

        if (module.value_entry) {
            try adapter.writer.writeAll("pub const executeValue = entry.executeValue;\n");
        }

        if (module.buffered_entry) {
            try adapter.writer.writeAll("pub const executeBuffered = entry.executeBuffered;\npub const buffer_lanes = entry.buffer_lanes;\n");
        }

        try writeFile(io, allocator, output, try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name}), adapter.written());
    }

    try writeFile(io, allocator, output, "root.zig", root.written());
}

fn writeFile(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, source: []const u8) !void {
    const path = try std.fs.path.join(allocator, &.{ directory, name });

    defer allocator.free(path);

    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = path, .data = source });
}
