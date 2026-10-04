const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const target = @import("../call/target.zig");
const Flow = @import("flow.zig");
pub const Call = struct { node: rx.ast.Node, callee: union(enum) { function: target.Function, service: usize } };
pub const Module = struct { source: rx.ModuleSource, calls: []const Call, steps: []const Flow.Step };
pub const Loaded = struct { modules: []const Module, project: frontend.project.Options };
pub const Value = union(enum) { loaded: Loaded, diagnostic: target.Diagnostic };

pub fn load(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const frontend.project.Source, initial_project: frontend.project.Options) std.mem.Allocator.Error!Value {
    const plans = try allocator.alloc(Module, modules.len);
    var loader = Loader{ .allocator = allocator, .modules = modules, .sources = sources, .project = initial_project };

    for (modules, plans) |source, *plan| {
        loader.owner = source.path;
        loader.calls = .empty;

        const steps = loader.steps(source.node.children) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return .{ .diagnostic = loader.issue.? };
        };

        plan.* = .{ .source = source, .calls = loader.calls.items, .steps = steps };
    }

    return .{ .loaded = .{ .modules = plans, .project = loader.project } };
}

const Loader = struct {
    allocator: std.mem.Allocator,
    modules: []const rx.ModuleSource,
    sources: []const frontend.project.Source,
    project: frontend.project.Options,
    owner: []const u8 = "",
    calls: std.ArrayList(Call) = .empty,
    issue: ?target.Diagnostic = null,
    const Error = std.mem.Allocator.Error || error{InvalidFlow};

    fn steps(self: *Loader, nodes: []const rx.ast.Node) Error![]const Flow.Step {
        var result: std.ArrayList(Flow.Step) = .empty;
        var terminated = false;

        for (nodes) |node| {
            if (std.mem.eql(u8, node.name, "Import")) continue;
            if (terminated) return self.fail(node.location, "return_path", "steps after a terminating Return or Switch are unreachable");

            const value: @FieldType(Flow.Step, "value") = if (std.mem.eql(u8, node.name, "Return"))
                .{ .result = target.attribute(node, "value") }

            else if (std.mem.eql(u8, node.name, "Call"))
                .{ .call = try self.call(node) }
            else if (std.mem.eql(u8, node.name, "Task"))
                .{ .task = try self.steps(node.children) }
            else if (std.mem.eql(u8, node.name, "Switch")) selection: {
                const cases = try self.allocator.alloc(Flow.Case, node.children.len);

                for (node.children, cases) |child, *case| {
                    case.* = .{ .value = if (std.mem.eql(u8, child.name, "Case")) target.attribute(child, "value") else null, .body = try self.steps(child.children) };
                }

                break :selection .{ .selection = .{ .subject = target.attribute(node, "on"), .cases = cases } };
            } else return self.fail(node.location, "unsupported", "RX execution supports Call, Return, Task and Switch; Store, Parallel and events require host linking");

            try result.append(self.allocator, .{ .value = value });

            terminated = Flow.terminates(result.items);
        }

        return result.items;
    }
    fn call(self: *Loader, node: rx.ast.Node) Error!usize {
        const index = self.calls.items.len;
        var service: ?rx.ast.Attribute = null;

        for (node.attributes) |attribute| {
            if (std.mem.eql(u8, attribute.name, "setter")) return self.fail(attribute.value_location, "unsupported", "Store calls require explicit Store authorization and host linking");
            if (std.mem.eql(u8, attribute.name, "service")) service = attribute;
        }

        if (service) |attribute| {
            const path = rx.resolveModulePath(self.allocator, self.owner, attribute.value) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return self.fail(attribute.value_location, "module", "Call.service must stay within the project root");
            };

            const service_index = find(self.modules, path) orelse return self.fail(attribute.value_location, "module", "Call.service target is not registered");

            try self.calls.append(self.allocator, .{ .node = node, .callee = .{ .service = service_index } });
        } else {
            const result = try target.load(self.allocator, .{ .owner = self.owner, .call = node, .sources = self.sources, .project = self.project });

            if (result.value == .diagnostic) {
                self.issue = result.value.diagnostic;

                return error.InvalidFlow;
            }

            const function = result.value.function;
            self.project.context.types = function.program.types;
            self.project.context.nominal_types = function.nominal_types;

            try self.calls.append(self.allocator, .{ .node = node, .callee = .{ .function = function } });
        }

        return index;
    }
    fn fail(self: *Loader, location: rx.ast.Location, code: []const u8, message: []const u8) Error {
        const result = try target.failure(self.allocator, .{ .path = self.owner, .location = location, .code = code, .message = message });

        self.issue = result.diagnostic;

        return error.InvalidFlow;
    }
};

pub fn find(modules: []const rx.ModuleSource, path: []const u8) ?usize {
    for (modules, 0..) |source, index| {
        if (std.mem.eql(u8, source.path, path)) return index;
    }

    return null;
}
