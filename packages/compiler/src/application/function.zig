const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const project = @import("../cli/project.zig");
const sources = @import("../cli/sources.zig");

pub fn validate(io: std.Io, allocator: std.mem.Allocator, path: []const u8, source: []const u8, config_path: ?[]const u8, writer: *std.Io.Writer) !bool {
    const loaded = project.load(io, allocator, path, config_path) catch |err| {
        if (err == error.OutOfMemory) return err;

        try writer.print("{s}: {s}\n", .{ config_path orelse "pkg.yaml", @errorName(err) });

        return false;
    };

    if (loaded.diagnostic) |message| {
        try writer.print("{s}\n", .{message});

        return false;
    }

    const inputs = sources.read(io, allocator, source, loaded.project) catch |err| {
        if (err == error.OutOfMemory) return err;
        try writer.print("{s}: source loading: {s}\n", .{ path, @errorName(err) });

        return false;
    };

    var analyzed = try compiler.analyzeProject(allocator, inputs, loaded.project);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;
        const index = issue.source_index orelse 0;
        const location = zx.source.locate(inputs[index].source, issue.span.start);

        try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ inputs[index].path, location.line, location.column, issue.code, issue.message });

        return false;
    }

    if (analyzed.value.ir.type_only) {
        try writer.print("{s}: Call.fn requires an executable ZX module with a default function\n", .{path});

        return false;
    }

    return true;
}
