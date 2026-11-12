const std = @import("std");
const rx = @import("rx");

pub fn run(io: std.Io, allocator: std.mem.Allocator, scratch: std.mem.Allocator, paths: []const []const u8, writer: *std.Io.Writer) !bool {
    if (paths.len > 0 and std.mem.eql(u8, paths[0], "--entry")) {
        if (paths.len != 2 and (paths.len != 4 or !std.mem.eql(u8, paths[2], "--project"))) {
            try writer.writeAll("check-rx --entry requires one RX file and optional --project pkg.yaml\n");

            return false;
        }

        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        var loaded = try @import("load.zig").load(io, arena.allocator(), scratch, paths[1], if (paths.len == 4) paths[3] else null, writer) orelse return false;

        defer loaded.deinit();

        const modules = loaded.data.modules;
        var result = try rx.validateModules(allocator, modules);

        defer result.deinit();

        if (result.value == .diagnostic) {
            const diagnostic = result.value.diagnostic;

            return report(writer, modules[diagnostic.source_index].path, diagnostic.issue);
        }

        return true;
    }

    if (paths.len == 0) {
        try writer.writeAll("check-rx requires the complete set of ordinary RX module paths\n");

        return false;
    }

    const sources = try allocator.alloc(rx.TextSource, paths.len);
    var loaded: usize = 0;

    defer {
        for (sources[0..loaded]) |source| allocator.free(source.source);

        allocator.free(sources);
    }

    for (paths, sources) |path, *source| {
        const text = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(16 * 1024 * 1024)) catch |err| {
            try writer.print("{s}: {s}\n", .{ path, @errorName(err) });

            return false;
        };

        source.* = .{ .path = path, .source = text };
        loaded += 1;
    }

    return validate(allocator, sources, writer);
}

fn validate(allocator: std.mem.Allocator, sources: []const rx.TextSource, writer: *std.Io.Writer) !bool {
    var result = try rx.parseModules(allocator, sources);

    defer result.deinit();

    if (result.value == .diagnostic) {
        const diagnostic = result.value.diagnostic;

        return report(writer, sources[diagnostic.source_index].path, diagnostic.issue);
    }

    return true;
}

fn report(writer: *std.Io.Writer, path: []const u8, issue: rx.Diagnostic) !bool {
    try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ path, issue.location.line, issue.location.column, issue.code, issue.message });

    return false;
}
