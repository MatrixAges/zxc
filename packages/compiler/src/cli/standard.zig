const std = @import("std");
const compiler = @import("compiler");
const project = @import("project.zig");

pub fn resolve(allocator: std.mem.Allocator, loaded: project.Loaded, dependencies: []const []const u8, standard_root: []const u8) !project.Loaded {
    var modules: std.ArrayList(project.NativeModule) = .empty;

    try modules.appendSlice(allocator, loaded.config.native_modules);

    for (compiler.project.standard) |standard| {
        var required = false;

        for (dependencies) |dependency| {
            if (std.mem.eql(u8, dependency, standard.module)) required = true;
        }

        for (modules.items) |module| {
            if (std.mem.eql(u8, module.name, standard.module)) required = false;
        }

        if (!required) continue;

        const path = try std.fs.path.resolve(allocator, &.{ standard_root, standard.implementation_path });

        try modules.append(allocator, .{ .name = standard.module, .path = path });
    }

    var result = loaded;

    result.config.native_modules = modules.items;

    return result;
}
