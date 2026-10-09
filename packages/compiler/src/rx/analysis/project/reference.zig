const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const frontend = @import("frontend");
const target = @import("../call/target.zig");

pub const Value = union(enum) {
    module: usize,
    source: []const u8,
    compiled: frontend.project.compiled.Target,
    diagnostic: target.Diagnostic,
};

pub fn resolve(allocator: std.mem.Allocator, owner: []const u8, node: rx.ast.Node, modules: []const rx.ModuleSource, project: frontend.project.Options) std.mem.Allocator.Error!Value {
    const reference = target.optionalAttribute(node, "module");
    const attribute = reference orelse target.attribute(node, "fn");
    const from = try std.fs.path.resolve(allocator, &.{ project.root_dir, owner });
    const packages = rx.module_reference.dependencies(project, from);
    var path: []const u8 = undefined;

    if (reference != null and rx.module_reference.isPackage(attribute.value, packages)) {
        var reporter: zx.Reporter = .{};

        const resolved = frontend.project.resolveModuleTarget(allocator, from, attribute.value, project, &reporter, .{ .start = attribute.value_location.offset, .end = attribute.value_location.offset }) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return failure(allocator, owner, attribute.value_location, reporter.diagnostic.?.message);
        };

        switch (resolved) {
            .compiled => |compiled| return .{ .compiled = compiled },
            .source => |source| path = source,
        }
    } else {
        const relative = (if (reference != null)
            rx.resolveModulePath(allocator, owner, attribute.value)
        else
            rx.resolveFunctionPath(allocator, owner, attribute.value)) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return failure(allocator, owner, attribute.value_location, "Call target must name a source module inside the project root");
        };

        path = try std.fs.path.resolve(allocator, &.{ project.root_dir, relative });
    }

    if (std.mem.endsWith(u8, path, ".zx")) return .{ .source = path };

    for (modules, 0..) |module, index| {
        const registered = try std.fs.path.resolve(allocator, &.{ project.root_dir, module.path });

        if (std.mem.eql(u8, registered, path)) return .{ .module = index };
    }

    return failure(allocator, owner, attribute.value_location, "Call.module target is not registered");
}

fn failure(allocator: std.mem.Allocator, owner: []const u8, location: rx.ast.Location, message: []const u8) std.mem.Allocator.Error!Value {
    return .{ .diagnostic = .{
        .path = try allocator.dupe(u8, owner),
        .location = location,
        .code = "module",
        .message = try allocator.dupe(u8, message),
    } };
}
