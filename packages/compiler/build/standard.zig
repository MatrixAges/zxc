const std = @import("std");
const Module = struct { specifier: []const u8, path: []const u8, module: []const u8, namespace: []const []const u8, implementation_path: []const u8 };

pub fn create(b: *std.Build) *std.Build.Module {
    return generate(b) catch @panic("unable to package standard module declarations");
}

fn generate(b: *std.Build) !*std.Build.Module {
    const manifest = try b.build_root.handle.readFileAlloc(b.graph.io, "standard/modules.json", b.allocator, .limited(1024 * 1024));
    const modules = try std.json.parseFromSliceLeaky([]const Module, b.allocator, manifest, .{});
    const files = b.addWriteFiles();
    var output: std.Io.Writer.Allocating = .init(b.allocator);
    const writer = &output.writer;

    try writer.writeAll("pub const Source = struct { specifier: []const u8, path: []const u8, source: []const u8, module: []const u8, namespace: []const []const u8, implementation_path: []const u8 };\npub const modules: []const Source = &.{\n");

    for (modules, 0..) |module, index| {
        const destination = b.fmt("interfaces/{d}.d.zx", .{index});
        _ = files.addCopyFile(b.path(b.fmt("standard/{s}", .{module.path})), destination);

        try writer.print(".{{ .specifier = \"{f}\", .path = \"standard/{f}\", .source = @embedFile(\"{f}\"), .module = \"{f}\", .namespace = &.{{", .{ std.zig.fmtString(module.specifier), std.zig.fmtString(module.path), std.zig.fmtString(destination), std.zig.fmtString(module.module) });
        for (module.namespace) |part| try writer.print("\"{f}\",", .{std.zig.fmtString(part)});
        try writer.print("}}, .implementation_path = \"{f}\" }},\n", .{std.zig.fmtString(module.implementation_path)});
    }

    try writer.writeAll("};\n");

    return b.createModule(.{ .root_source_file = files.add("catalog.zig", output.written()) });
}
