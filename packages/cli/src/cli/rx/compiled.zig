const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const zx = @import("zx");
const Libraries = @import("../library/inputs.zig");
const Inputs = @import("../watch/inputs.zig");

pub const Options = struct {
    io: std.Io,
    modules: []const rx.ModuleSource,
    project: compiler.project.Options,
    libraries: *Libraries,
    inputs: ?*Inputs,
    writer: *std.Io.Writer,
};

pub fn collect(allocator: std.mem.Allocator, options: Options) !bool {
    for (options.modules) |*module| {
        const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, module.path });
        const packages = rx.module_reference.dependencies(options.project, owner);

        for (module.indexedReferences() orelse unreachable) |reference| {
            if (reference.role != .Call or reference.target != .Module) continue;

            const attribute = reference.attribute orelse unreachable;

            if (!rx.module_reference.isPackage(attribute.value, packages)) continue;

            var reporter: zx.Reporter = .{};

            const resolved = compiler.project.resolveModuleTarget(allocator, owner, attribute.value, options.project, &reporter, .{ .start = 0, .end = 0 }) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;
                try options.writer.print("{s}:{d}:{d}: module: {s}\n", .{ module.path, attribute.value_location.line, attribute.value_location.column, reporter.diagnostic.?.message });

                return false;
            };

            if (resolved == .source) continue;
            try options.libraries.add(options.io, resolved.compiled, options.project, options.inputs);

            for (options.libraries.libraries.items) |library| {
                if (!std.mem.eql(u8, library.instance, resolved.compiled.instance)) continue;

                for (library.exports) |exported| {
                    if (!std.mem.eql(u8, exported.name, resolved.compiled.name)) continue;
                    if (exported.function != null) break;
                    try options.writer.print("{s}:{d}:{d}: module: Call.module requires an executable public module\n", .{ module.path, attribute.value_location.line, attribute.value_location.column });

                    return false;
                }
            }
        }
    }

    return true;
}
