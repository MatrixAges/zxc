const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const project = @import("../project.zig");
const sources = @import("../sources.zig");

pub fn validate(io: std.Io, allocator: std.mem.Allocator, path: []const u8, source: []const u8, config_path: ?[]const u8, modules: []const @import("rx").ModuleSource, writer: *std.Io.Writer) !bool {
    var loaded = project.load(io, allocator, path, config_path) catch |err| {
        if (err == error.OutOfMemory) return err;

        try writer.print("{s}: {s}\n", .{ config_path orelse "pkg.yaml", @errorName(err) });

        return false;
    };

    if (loaded.diagnostic) |message| {
        try writer.print("{s}\n", .{message});

        return false;
    }

    var parse_cache = compiler.project.ParseCache{ .allocator = allocator };

    defer parse_cache.deinit();

    var libraries = @import("../library/inputs.zig"){ .allocator = allocator };

    defer libraries.deinit();

    const detected = sources.readDetectingRx(io, allocator, source, loaded.project, &parse_cache, null, &libraries) catch |err| {
        if (err == error.OutOfMemory) return err;

        try writer.print("{s}: source loading: {s}\n", .{ path, @errorName(err) });

        return false;
    };

    const inputs = detected.sources;
    loaded.project.compiled_libraries = libraries.libraries.items;

    const executable = try called(io, allocator, path, loaded.project.root_dir, modules);

    if (!executable or detected.has_rx) {
        var signed = try compiler.project.analyzeSignaturesWithCache(allocator, inputs, &.{path}, loaded.project, &parse_cache);

        defer signed.deinit();

        if (signed.value == .diagnostic) return report(writer, inputs, signed.value.diagnostic);
        if (!executable) return true;

        for (signed.value.data.modules) |module| {
            const delegated = module.signature.deferredSource() orelse continue;

            const registered = for (modules) |source_module| {
                const absolute = try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, source_module.path });

                defer allocator.free(absolute);

                if (std.mem.eql(u8, delegated, absolute)) break true;
            } else false;

            if (!registered) {
                try writer.print("{s}: default re-export target is missing from the RX module collection\n", .{path});
            }

            return registered;
        }
    }

    var analyzed = try compiler.analyzeProjectWithCache(allocator, inputs, loaded.project, &parse_cache);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) return report(writer, inputs, analyzed.value.diagnostic);

    if (analyzed.value.ir.type_only) {
        try writer.print("{s}: Call.fn requires an executable ZX module with a default function\n", .{path});

        return false;
    }

    return true;
}

fn report(writer: *std.Io.Writer, inputs: []const compiler.project.Source, issue: anytype) !bool {
    const index = issue.source_index orelse 0;
    const location = zx.source.locate(inputs[index].original orelse inputs[index].source, issue.span.start);

    try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ inputs[index].path, location.line, location.column, issue.code, issue.message });

    return false;
}

fn called(io: std.Io, allocator: std.mem.Allocator, path: []const u8, root: []const u8, modules: []const @import("rx").ModuleSource) !bool {
    var pending: std.ArrayList(struct { owner: []const u8, node: @import("rx").ast.Node }) = .empty;

    defer pending.deinit(allocator);

    for (modules) |module| try pending.append(allocator, .{ .owner = module.path, .node = module.node });

    while (pending.pop()) |item| {
        if (std.mem.eql(u8, item.node.name, "Call") or std.mem.eql(u8, item.node.name, "Module")) {
            for (item.node.attributes) |attribute| {
                if (!std.mem.eql(u8, attribute.name, "fn")) continue;

                const relative = try @import("rx").resolveFunctionPath(allocator, item.owner, attribute.value);
                const candidate = try std.fs.path.resolve(allocator, &.{ root, relative });
                const resolved = try @import("../sources/module_path.zig").select(io, allocator, candidate, null);

                if (std.mem.eql(u8, path, resolved)) return true;
            }
        }

        for (item.node.children) |node| try pending.append(allocator, .{ .owner = item.owner, .node = node });
    }

    return false;
}
