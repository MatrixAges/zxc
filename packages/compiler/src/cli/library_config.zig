const std = @import("std");
const Config = @import("project.zig").Config;

pub fn write(output: *std.Io.Writer, config: Config) std.Io.Writer.Error!void {
    try output.writeAll("\nconst config: Config = .{\n    .native_modules = &.{\n");

    for (config.native_modules) |module| {
        try output.print("        .{{ .name = \"{f}\", .path = ", .{std.zig.fmtString(module.name)});
        try optional(output, module.path);
        try output.writeAll(", .header = ");
        try optional(output, module.header);
        try output.writeAll(", .dependencies = ");
        try strings(output, module.dependencies);
        try output.writeAll(", .bundle_files = ");
        try strings(output, module.bundle_files);
        try output.writeAll(" },\n");
    }

    try output.writeAll("    },\n    .libraries = ");
    try strings(output, config.libraries);
    try output.writeAll(",\n    .include_paths = ");
    try strings(output, config.include_paths);
    try output.writeAll(",\n    .library_paths = ");
    try strings(output, config.library_paths);
    try output.writeAll(",\n};\n");
}

fn optional(output: *std.Io.Writer, value: ?[]const u8) std.Io.Writer.Error!void {
    if (value) |text| {
        try output.print("\"{f}\"", .{std.zig.fmtString(text)});
    } else try output.writeAll("null");
}

fn strings(output: *std.Io.Writer, values: []const []const u8) std.Io.Writer.Error!void {
    try output.writeAll("&.{");
    for (values) |value| try output.print(" \"{f}\",", .{std.zig.fmtString(value)});

    try output.writeAll(" }");
}
