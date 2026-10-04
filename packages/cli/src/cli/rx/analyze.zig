const std = @import("std");
const compiler = @import("compiler");
const analysis = @import("rx_analysis");
const rx = @import("rx");
const Inputs = @import("../watch/inputs.zig");
pub const Result = struct { analysis: compiler.AnalysisResult, sources: []const compiler.project.Source };

pub const Options = struct {
    io: std.Io,
    project: compiler.project.Options,
    writer: *std.Io.Writer,
    inputs: ?*Inputs = null,
};

pub fn run(allocator: std.mem.Allocator, options: Options) !?Result {
    const io = options.io;
    const project = options.project;
    const root = try std.fs.path.resolve(allocator, &.{project.root_dir});
    const owner = try std.fs.path.relative(allocator, root, null, root, project.entry);

    if (outside(owner)) return error.RxEntryOutsideProject;
    try validatePath(allocator, options, project.entry);

    const source = try read(allocator, options, project.entry);
    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        try report(options.writer, owner, parsed.value.diagnostic);

        return null;
    }

    var checked = try rx.validate(allocator, owner, parsed.value.node);

    defer checked.deinit();

    if (checked.value == .diagnostic) {
        try report(options.writer, owner, checked.value.diagnostic);

        return null;
    }

    var cache = compiler.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    defer seen.deinit(allocator);

    for (parsed.value.node.children) |node| {
        if (!std.mem.eql(u8, node.name, "Call")) continue;

        for (node.attributes) |attribute| {
            if (!std.mem.eql(u8, attribute.name, "fn")) continue;

            const relative = rx.resolveFunctionPath(allocator, owner, attribute.value) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;
                try options.writer.print("{s}:{d}:{d}: module: Call.fn must stay within the project root\n", .{ owner, attribute.value_location.line, attribute.value_location.column });

                return null;
            };

            const path = try std.fs.path.resolve(allocator, &.{ root, relative });

            try validatePath(allocator, options, path);
            if (seen.contains(path)) continue;

            var function_project = project;
            function_project.entry = path;

            const text = try read(allocator, options, path);
            const imported = try @import("../sources.zig").readWithInputs(io, allocator, text, function_project, &cache, options.inputs);

            for (imported) |item| {
                if (project.package_scopes.len == 0) try validatePath(allocator, options, item.path);
                if ((try seen.getOrPut(allocator, item.path)).found_existing) continue;
                try sources.append(allocator, item);
            }
        }
    }

    var inferred = try analysis.module.infer(allocator, .{ .owner = owner, .module = parsed.value.node, .sources = sources.items, .project = project });

    errdefer inferred.deinit();

    if (inferred.value == .diagnostic) {
        const issue = inferred.value.diagnostic;

        try options.writer.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        inferred.deinit();

        return null;
    }

    const contract = inferred.value.contract;

    return .{ .analysis = .{ .arena = inferred.arena, .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types }, .sources = sources.items };
}

fn read(allocator: std.mem.Allocator, options: Options, path: []const u8) ![]const u8 {
    if (options.inputs) |inputs| try inputs.add(options.io, path);

    const source = try std.Io.Dir.cwd().readFileAlloc(options.io, path, allocator, .limited(16 * 1024 * 1024));

    if (options.inputs) |inputs| try inputs.record(options.io, path, source);

    return source;
}

fn validatePath(allocator: std.mem.Allocator, options: Options, path: []const u8) !void {
    if (options.inputs) |inputs| try inputs.add(options.io, path);

    const root = try std.Io.Dir.cwd().realPathFileAlloc(options.io, options.project.root_dir, allocator);
    const real = try std.Io.Dir.cwd().realPathFileAlloc(options.io, path, allocator);
    const relative = try std.fs.path.relative(allocator, root, null, root, real);

    if (outside(relative)) return error.RxSourceOutsideProject;
    try @import("../../package/source.zig").validateWithInputs(options.io, allocator, path, options.project.package_scopes, options.inputs);
}

fn outside(path: []const u8) bool {
    return std.fs.path.isAbsolute(path) or std.mem.eql(u8, path, "..") or std.mem.startsWith(u8, path, "../") or std.mem.startsWith(u8, path, "..\\");
}

fn report(writer: *std.Io.Writer, path: []const u8, issue: rx.Diagnostic) !void {
    try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ path, issue.location.line, issue.location.column, issue.code, issue.message });
}
