const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const target = @import("../call/target.zig");
const Store = @import("../store.zig");
const Flow = @import("flow.zig");
pub const Call = struct { setter: ?target.Setter = null, getters: []const Store.Binding = &.{}, node: rx.ast.Node, callee: union(enum) { function: target.Function, module: usize, signature: frontend.project.signature_project.Ports } };
pub const Module = struct { source: rx.ModuleSource, shortcut: ?usize = null, calls: []const Call, steps: []const Flow.Step, type_imports: []const @import("zx").ir.Export = &.{}, value_imports: []const @import("zx").ir.Export = &.{} };
pub const Loaded = struct { modules: []const Module, project: frontend.project.Options };
pub const Value = union(enum) { loaded: Loaded, diagnostic: target.Diagnostic };

pub fn load(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const frontend.project.Source, initial_project: frontend.project.Options, definitions: []const Store.Definition) std.mem.Allocator.Error!Value {
    return loadWithSignatures(allocator, modules, sources, initial_project, definitions, null);
}

pub fn loadSignatures(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const frontend.project.Source, initial_project: frontend.project.Options, definitions: []const Store.Definition, signatures: frontend.project.signature_project.Data) std.mem.Allocator.Error!Value {
    return loadWithSignatures(allocator, modules, sources, initial_project, definitions, signatures);
}

fn loadWithSignatures(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const frontend.project.Source, initial_project: frontend.project.Options, definitions: []const Store.Definition, signatures: ?frontend.project.signature_project.Data) std.mem.Allocator.Error!Value {
    const plans = try allocator.alloc(Module, modules.len);
    var loader = Loader{ .allocator = allocator, .modules = modules, .sources = sources, .project = initial_project, .signatures = signatures };

    for (modules, plans) |source, *plan| {
        loader.owner = source.path;
        loader.calls = .empty;
        loader.task_count = 0;
        loader.deferred_shortcut = null;

        const references = try @import("../store/references.zig").resolve(allocator, source, definitions);

        if (references == .diagnostic) return .{ .diagnostic = references.diagnostic };

        loader.stores = references.bindings;

        const steps = (if (target.optionalAttribute(source.node, "fn") != null)
            loader.shortcut(source.node)
        else
            loader.steps(source.node.children)) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return .{ .diagnostic = loader.issue.? };
        };

        const imported: @import("type_imports.zig").Value = if (signatures) |signed| try @import("type_imports.zig").collect(allocator, source, loader.project, signed) else .{ .imports = &.{} };

        if (imported == .diagnostic) return .{ .diagnostic = imported.diagnostic };

        plan.* = .{ .source = source, .shortcut = loader.deferred_shortcut, .calls = loader.calls.items, .steps = steps, .type_imports = imported.imports, .value_imports = try @import("type_imports.zig").values(allocator, loader.project.context.types, imported.imports) };
    }

    return .{ .loaded = .{ .modules = plans, .project = loader.project } };
}

pub fn completeShortcuts(allocator: std.mem.Allocator, loaded: Loaded, signatures: []const @import("signatures.zig").Signature) std.mem.Allocator.Error!Loaded {
    const pending = for (loaded.modules) |module| {
        if (module.shortcut != null) break true;
    } else false;

    if (!pending) return loaded;

    const modules = try allocator.dupe(Module, loaded.modules);
    const shorthand = @import("shorthand.zig");
    const void_type = @import("frontend").types.scalarId(.void);

    for (modules, signatures) |*module, signature| {
        const index = module.shortcut orelse continue;
        const calls = try allocator.dupe(Call, module.calls);
        const node = try shorthand.call(allocator, module.source.node, signature.input_type != void_type);
        const steps = try allocator.alloc(Flow.Step, if (signature.output_type == void_type) 1 else 2);

        calls[index].node = node;
        steps[0] = .{ .value = .{ .call = index } };

        if (steps.len == 2) steps[1] = .{ .value = .{ .result = try shorthand.result(allocator, node) } };

        module.calls = calls;
        module.steps = steps;
    }

    return .{ .modules = modules, .project = loaded.project };
}

const Loader = struct {
    allocator: std.mem.Allocator,
    modules: []const rx.ModuleSource,
    sources: []const frontend.project.Source,
    project: frontend.project.Options,
    signatures: ?frontend.project.signature_project.Data = null,
    owner: []const u8 = "",
    stores: []const Store.Binding = &.{},
    calls: std.ArrayList(Call) = .empty,
    task_count: usize = 0,
    deferred_shortcut: ?usize = null,
    issue: ?target.Diagnostic = null,
    const Error = std.mem.Allocator.Error || error{InvalidFlow};

    fn shortcut(self: *Loader, node: rx.ast.Node) Error![]const Flow.Step {
        const shorthand = @import("shorthand.zig");
        const index = try self.call(try shorthand.call(self.allocator, node, false));
        const callee = self.calls.items[index].callee;

        const ports = switch (callee) {
            .signature => |signature| signature,
            .function => |function| frontend.project.signature_project.Ports{ .input_type = function.program.input_type, .output_type = function.program.output_type },
            .module => {
                self.deferred_shortcut = index;

                return &.{};
            },
        };

        const void_type = frontend.types.scalarId(.void);
        const invocation = try shorthand.call(self.allocator, node, ports.input_type != void_type);
        const sequence = try self.allocator.alloc(Flow.Step, if (ports.output_type == void_type) 1 else 2);

        self.calls.items[index].node = invocation;
        sequence[0] = .{ .value = .{ .call = index } };

        if (sequence.len == 2) sequence[1] = .{ .value = .{ .result = try shorthand.result(self.allocator, invocation) } };

        return sequence;
    }
    fn steps(self: *Loader, nodes: []const rx.ast.Node) Error![]const Flow.Step {
        var result: std.ArrayList(Flow.Step) = .empty;
        var terminated = false;

        for (nodes) |node| {
            if (std.mem.eql(u8, node.name, "Import") or std.mem.eql(u8, node.name, "Store") or std.mem.eql(u8, node.name, "Type") or std.mem.eql(u8, node.name, "Args")) continue;
            if (terminated) return self.fail(node.location, "return_path", "steps after a terminating Return or Switch are unreachable");

            const value: @FieldType(Flow.Step, "value") = if (std.mem.eql(u8, node.name, "Return"))
                .{ .result = target.attribute(node, "value") }

            else if (std.mem.eql(u8, node.name, "Call"))
                .{ .call = try self.call(node) }
            else if (std.mem.eql(u8, node.name, "Task"))
                .{ .task = .{ .node = node, .body = try self.taskBody(node, false) } }
            else if (std.mem.eql(u8, node.name, "Parallel")) parallel: {
                const branches = try self.allocator.alloc(Flow.Branch, node.children.len);

                for (node.children, branches) |child, *branch| {
                    branch.* = if (std.mem.eql(u8, child.name, "Call"))
                        .{ .call = try self.call(child) }

                    else task: {
                        const id = self.task_count;

                        self.task_count += 1;

                        break :task .{ .task = .{ .id = id, .node = child, .body = try self.taskBody(child, true) } };
                    };
                }

                break :parallel .{ .parallel = branches };
            } else if (std.mem.eql(u8, node.name, "Switch")) selection: {
                const cases = try self.allocator.alloc(Flow.Case, node.children.len);

                for (node.children, cases) |child, *case| {
                    case.* = .{ .value = if (std.mem.eql(u8, child.name, "Case")) target.attribute(child, "value") else null, .body = try self.steps(child.children) };
                }

                break :selection .{ .selection = .{ .subject = target.attribute(node, "on"), .cases = cases } };
            } else return self.fail(node.location, "unsupported", "RX execution supports Store declarations, Call, Return, Task, Switch and pure Parallel branches; events require host linking");

            try result.append(self.allocator, .{ .value = value });

            terminated = Flow.terminates(result.items);
        }

        return result.items;
    }
    fn taskBody(self: *Loader, node: rx.ast.Node, parallel: bool) Error![]const Flow.Step {
        const body = try self.steps(node.children);
        const output = target.optionalAttribute(node, "out") orelse return body;

        if (Flow.returns(body)) return self.fail(output.value_location, "return_path", "Task.out and Return cannot both define the same task output");
        if (!parallel) return body;

        const result = try self.allocator.alloc(Flow.Step, body.len + 1);

        @memcpy(result[0..body.len], body);

        result[body.len] = .{ .value = .{ .result = output } };

        return result;
    }
    fn call(self: *Loader, node: rx.ast.Node) Error!usize {
        const index = self.calls.items.len;
        const authorized = try @import("../store/call.zig").analyze(self.allocator, self.owner, node, self.stores);

        if (authorized == .diagnostic) {
            self.issue = authorized.diagnostic;

            return error.InvalidFlow;
        }

        const capability = authorized.authorized;
        const reference = try @import("reference.zig").resolve(self.allocator, self.owner, node, self.modules, self.project);

        if (reference == .diagnostic) {
            self.issue = reference.diagnostic;

            return error.InvalidFlow;
        }

        if (reference == .module) {
            try self.calls.append(self.allocator, .{ .node = node, .setter = capability.setter, .getters = capability.getters, .callee = .{ .module = reference.module } });
        } else if (self.signatures != null and reference == .source) {
            const attribute = target.optionalAttribute(node, "module") orelse target.attribute(node, "fn");
            const path = reference.source;
            var found = false;

            for (self.signatures.?.modules) |module| {
                if (!std.mem.eql(u8, module.path, path)) continue;

                if (module.signature.deferredSource()) |source| {
                    if (capability.setter != null) return self.fail(attribute.value_location, "capability", "RX module Store authorization belongs inside the module");

                    const module_index = try self.deferredModule(source) orelse return self.fail(attribute.value_location, "module", "default re-export target is missing from the RX module collection");

                    try self.calls.append(self.allocator, .{ .node = node, .getters = capability.getters, .callee = .{ .module = module_index } });

                    found = true;

                    break;
                }

                if (module.signature.type_only) return self.fail(attribute.value_location, "module", "Call.fn requires an executable ZX module with a default function");
                if (capability.setter != null and !module.signature.has_store) return self.fail(attribute.value_location, "capability", "a Call.setter target must declare its second parameter as { store }");
                try self.calls.append(self.allocator, .{ .node = node, .setter = capability.setter, .getters = capability.getters, .callee = .{ .signature = module.signature.ports } });

                found = true;

                break;
            }

            if (!found) return self.fail(attribute.value_location, "module", "source function signature is missing from the analyzed input set");
        } else {
            const result = try target.load(self.allocator, .{ .owner = self.owner, .call = node, .sources = self.sources, .project = self.project, .setter = capability.setter });

            if (result.value == .diagnostic) {
                self.issue = result.value.diagnostic;

                return error.InvalidFlow;
            }

            const function = result.value.function;

            self.project.context.types = function.program.types;
            self.project.context.nominal_types = function.nominal_types;
            self.project.context.native_modules = function.program.native_modules;

            try self.calls.append(self.allocator, .{ .node = node, .setter = capability.setter, .getters = capability.getters, .callee = .{ .function = function } });
        }

        return index;
    }
    fn deferredModule(self: *Loader, path: []const u8) Error!?usize {
        for (self.modules, 0..) |module, index| {
            const absolute = try std.fs.path.resolve(self.allocator, &.{ self.project.root_dir, module.path });

            defer self.allocator.free(absolute);

            if (std.mem.eql(u8, absolute, path)) return index;
        }

        return null;
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
