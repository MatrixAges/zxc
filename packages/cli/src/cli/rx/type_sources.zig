const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const zx = @import("zx");
const Inputs = @import("../watch/inputs.zig");

pub const Options = struct {
    io: std.Io,
    project: compiler.project.Options,
    modules: []const rx.ModuleSource,
    stores: []const rx.ModuleSource = &.{},
    functions: []const rx.TextSource,
    writer: *std.Io.Writer,
    inputs: ?*Inputs = null,
};

pub fn collect(allocator: std.mem.Allocator, options: Options) !?[]const rx.TextSource {
    var result: std.ArrayList(rx.TextSource) = .empty;
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    defer seen.deinit(allocator);

    try result.appendSlice(allocator, options.functions);

    for (options.functions) |source| {
        try seen.put(allocator, try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source.path }), {});
    }

    for (0..options.modules.len + options.stores.len) |index| {
        const module = if (index < options.modules.len) &options.modules[index] else &options.stores[index - options.modules.len];
        const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, module.path });
        const packages = rx.module_reference.dependencies(options.project, owner);
        const references = module.indexedReferences() orelse unreachable;
        var end = references.len;

        while (end != 0) {
            end -= 1;
            const reference = references[end];

            if (reference.role != .TypeImport) continue;

            const from = (reference.attribute orelse unreachable).*;

            if (!rx.module_reference.isPackage(from.value, packages)) continue;

            var reporter: zx.Reporter = .{};

            const target = compiler.project.resolveModuleTarget(allocator, owner, from.value, options.project, &reporter, .{ .start = from.value_location.offset, .end = from.value_location.offset }) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;
                try report(options.writer, module.path, from, reporter.diagnostic.?.message);

                return null;
            };

            if (target != .source or !std.mem.endsWith(u8, target.source, ".zx")) {
                try report(options.writer, module.path, from, "Type requires a ZX source module");

                return null;
            }

            const path = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, target.source });

            if (seen.contains(path)) continue;
            if (options.inputs) |inputs| try inputs.add(options.io, path);
            try @import("../../package/source.zig").validateWithInputs(options.io, allocator, path, options.project.package_scopes, options.inputs);

            if (options.project.package_scopes.len == 0) {
                const root = try std.Io.Dir.cwd().realPathFileAlloc(options.io, options.project.root_dir, allocator);
                const real = try std.Io.Dir.cwd().realPathFileAlloc(options.io, path, allocator);
                const relative = try std.fs.path.relative(allocator, root, null, root, real);

                if (@import("collection.zig").outside(relative)) return error.RxSourceOutsideProject;
            }

            const source = std.Io.Dir.cwd().readFileAlloc(options.io, path, allocator, .limited(16 * 1024 * 1024)) catch |err| {
                if (err == error.OutOfMemory or err == error.Canceled) return err;
                try options.writer.print("{s}:{d}:{d}: module: {s}\n", .{ module.path, from.value_location.line, from.value_location.column, @errorName(err) });

                return null;
            };

            if (options.inputs) |inputs| try inputs.record(options.io, path, source);
            try seen.put(allocator, path, {});
            try result.append(allocator, .{ .path = path, .source = source });
        }
    }

    return result.items;
}

fn report(writer: *std.Io.Writer, path: []const u8, from: rx.ast.Attribute, message: []const u8) !void {
    try writer.print("{s}:{d}:{d}: module: {s}\n", .{ path, from.value_location.line, from.value_location.column, message });
}
