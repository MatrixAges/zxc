const std = @import("std");
const model = @import("model.zig");

pub fn write(output: *std.Io.Writer, data: model.Manifest) std.Io.Writer.Error!void {
    try field(output, "name", data.name);
    try field(output, "version", data.version);
    if (data.entry) |entry| try field(output, "entry", entry);

    if (data.exports.len != 0) {
        try output.writeAll("exports:\n");

        for (data.exports) |item| {
            try output.writeAll("  ");
            try field(output, item.path, item.source);
        }
    }

    if (data.private) try output.writeAll("private: true\n");
    try dependencies(output, "dependencies", data.dependencies);
    try dependencies(output, "dev_dependencies", data.dev_dependencies);

    if (data.workspace) |workspace| {
        try output.writeAll("workspace:\n  packages: ");
        try std.json.Stringify.value(workspace.packages, .{}, output);
        try output.writeByte('\n');
    }

    try records(output, "native_interfaces", data.native_interfaces);
    try records(output, "externals", data.externals);
    try records(output, "native_modules", data.native_modules);
    try records(output, "libraries", data.libraries);
    try records(output, "include_paths", data.include_paths);
    try records(output, "library_paths", data.library_paths);
}

fn field(output: *std.Io.Writer, key: []const u8, value: []const u8) std.Io.Writer.Error!void {
    try output.print("{s}: ", .{key});
    try std.json.Stringify.value(value, .{}, output);
    try output.writeByte('\n');
}

fn dependencies(output: *std.Io.Writer, key: []const u8, values: []const model.Dependency) std.Io.Writer.Error!void {
    if (values.len == 0) return;
    try output.print("{s}:\n", .{key});

    for (values) |value| {
        try output.writeAll("  ");
        try std.json.Stringify.value(value.name, .{}, output);
        try output.writeAll(": ");
        try std.json.Stringify.value(value.requirement, .{}, output);
        try output.writeByte('\n');
    }
}

fn records(output: *std.Io.Writer, key: []const u8, values: anytype) std.Io.Writer.Error!void {
    if (values.len == 0) return;
    try output.print("{s}:\n", .{key});

    for (values) |value| {
        try output.writeAll("  - ");
        try std.json.Stringify.value(value, .{ .emit_null_optional_fields = false }, output);
        try output.writeByte('\n');
    }
}
