const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const target = @import("../call/target.zig");

pub const Call = struct { node: rx.ast.Node, callee: union(enum) { function: target.Function, service: usize } };
pub const Module = struct { source: rx.ModuleSource, calls: []const Call, returned: ?rx.ast.Attribute };
pub const Loaded = struct { modules: []const Module, project: frontend.project.Options };
pub const Value = union(enum) { loaded: Loaded, diagnostic: target.Diagnostic };

pub fn load(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const frontend.project.Source, initial_project: frontend.project.Options) std.mem.Allocator.Error!Value {
    const plans = try allocator.alloc(Module, modules.len);
    var project = initial_project;

    for (modules, plans) |source, *plan| {
        var calls: std.ArrayList(Call) = .empty;
        var returned: ?rx.ast.Attribute = null;

        for (source.node.children) |node| {
            if (std.mem.eql(u8, node.name, "Import")) continue;
            if (returned != null) return failure(allocator, source.path, node.location, "return_path", "steps after Return are unreachable");

            if (std.mem.eql(u8, node.name, "Return")) {
                returned = target.attribute(node, "value");

                continue;
            }

            if (!std.mem.eql(u8, node.name, "Call")) return failure(allocator, source.path, node.location, "unsupported", "module inference currently supports sequential Call and Return steps");

            var service: ?rx.ast.Attribute = null;

            for (node.attributes) |attribute| {
                if (std.mem.eql(u8, attribute.name, "setter")) return failure(allocator, source.path, attribute.value_location, "unsupported", "Store calls require explicit Store authorization and host linking");
                if (std.mem.eql(u8, attribute.name, "service")) service = attribute;
            }

            if (service) |attribute| {
                const path = rx.resolveModulePath(allocator, source.path, attribute.value) catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;

                    return failure(allocator, source.path, attribute.value_location, "module", "Call.service must stay within the project root");
                };

                const index = find(modules, path) orelse return failure(allocator, source.path, attribute.value_location, "module", "Call.service target is not registered");

                try calls.append(allocator, .{ .node = node, .callee = .{ .service = index } });

                continue;
            }

            const result = try target.load(allocator, .{ .owner = source.path, .call = node, .sources = sources, .project = project });

            if (result.value == .diagnostic) return .{ .diagnostic = result.value.diagnostic };

            const function = result.value.function;
            project.context.types = function.program.types;
            project.context.nominal_types = function.nominal_types;

            try calls.append(allocator, .{ .node = node, .callee = .{ .function = function } });
        }

        plan.* = .{ .source = source, .calls = calls.items, .returned = returned };
    }

    return .{ .loaded = .{ .modules = plans, .project = project } };
}

pub fn find(modules: []const rx.ModuleSource, path: []const u8) ?usize {
    for (modules, 0..) |source, index| {
        if (std.mem.eql(u8, source.path, path)) return index;
    }

    return null;
}

fn failure(allocator: std.mem.Allocator, path: []const u8, location: rx.ast.Location, code: []const u8, message: []const u8) std.mem.Allocator.Error!Value {
    const result = try target.failure(allocator, .{ .path = path, .location = location, .code = code, .message = message });

    return .{ .diagnostic = result.diagnostic };
}
