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
    var nodes: std.ArrayList(rx.ast.Node) = .empty;

    defer nodes.deinit(allocator);

    for (options.modules) |module| {
        const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, module.path });

        try nodes.append(allocator, module.node);

        while (nodes.pop()) |node| {
            if (std.mem.eql(u8, node.name, "Call")) for (node.attributes) |attribute| {
                if (!std.mem.eql(u8, attribute.name, "module")) continue;

                var reporter: zx.Reporter = .{};

                const resolved = compiler.project.resolveTarget(allocator, owner, attribute.value, options.project, &reporter, .{ .start = 0, .end = 0 }) catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;
                    try options.writer.print("{s}:{d}:{d}: module: {s}\n", .{ module.path, attribute.value_location.line, attribute.value_location.column, reporter.diagnostic.?.message });

                    return false;
                };

                if (resolved != .compiled) {
                    try options.writer.print("{s}:{d}:{d}: module: Call.module requires a public compiled package module\n", .{ module.path, attribute.value_location.line, attribute.value_location.column });

                    return false;
                }

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
            };

            try nodes.appendSlice(allocator, node.children);
        }
    }

    return true;
}

pub fn hasReference(node: rx.ast.Node) bool {
    if (std.mem.eql(u8, node.name, "Call")) for (node.attributes) |attribute| {
        if (std.mem.eql(u8, attribute.name, "module")) return true;
    };

    for (node.children) |child| if (hasReference(child)) return true;

    return false;
}
