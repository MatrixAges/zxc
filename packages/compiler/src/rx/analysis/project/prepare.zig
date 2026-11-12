const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const target = @import("../call/target.zig");
const Store = @import("../store.zig");
const Flow = @import("flow.zig");
const zx = @import("zx");
const Graph = @import("source_graph/model.zig");
const Signatures = @import("references/signatures.zig");
const generated = @import("rx_options").generated_graph;
const Callee = union(enum) { module: usize, signature: frontend.project.signature_project.Ports };
pub const Call = struct { setter: ?target.Setter = null, getters: []const Store.Binding = &.{}, node: rx.ast.Node, edge: *const Graph.Edge, callee: Callee };
pub const Module = struct { source: rx.ModuleSource, shortcut: ?usize = null, calls: []const Call, steps: []const Flow.Step, type_imports: []const @import("zx").ir.Export = &.{}, value_imports: []const @import("zx").ir.Export = &.{} };
pub const Loaded = struct { modules: []const Module, project: frontend.project.Options };
pub const Value = union(enum) { loaded: Loaded, diagnostic: target.Diagnostic };

pub fn loadSignatures(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, registered: []const Graph.Module, initial_project: frontend.project.Options, definitions: []const Store.Definition, signatures: Signatures) std.mem.Allocator.Error!Value {
    const plans = try allocator.alloc(Module, modules.len);
    var loader = Loader{ .allocator = allocator, .modules = registered, .project = initial_project, .signatures = signatures };

    for (modules, registered, plans) |source, module, *plan| {
        loader.owner = source.path;
        loader.references = .{ .remaining = module.dependencies };
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

        const imported = try @import("type_imports.zig").collect(allocator, source, module, signatures);

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

    for (modules, signatures) |*module, signature| {
        const index = module.shortcut orelse continue;
        const calls = try allocator.dupe(Call, module.calls);
        const plan = try shorthand.lower(allocator, module.source.node, index, signature.input_type, signature.output_type);
        calls[index].node = plan.node;
        module.calls = calls;
        module.steps = plan.steps;
    }

    return .{ .modules = modules, .project = loaded.project };
}

const Loader = struct {
    allocator: std.mem.Allocator,
    modules: []const Graph.Module,
    project: frontend.project.Options,
    signatures: Signatures,
    references: Graph.References = .{ .remaining = &.{} },
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
            .module => {
                self.deferred_shortcut = index;

                return &.{};
            },
        };

        const plan = try shorthand.lower(self.allocator, node, index, ports.input_type, ports.output_type);

        self.calls.items[index].node = plan.node;

        return plan.steps;
    }
    fn steps(self: *Loader, nodes: []const rx.ast.Node) Error![]const Flow.Step {
        var result: std.ArrayList(Flow.Step) = .empty;
        var terminated = false;

        for (nodes) |node| {
            if (std.mem.eql(u8, node.name, "Import") or std.mem.eql(u8, node.name, "Store") or std.mem.eql(u8, node.name, "Type") or std.mem.eql(u8, node.name, "Args")) continue;
            if (terminated) return self.fail(node.location, "return_path", "steps after a terminating Return, Switch or If are unreachable");

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
            } else if (std.mem.eql(u8, node.name, "If")) selection: {
                const subject = target.attribute(node, "on");
                const has_else = std.mem.eql(u8, node.children[node.children.len - 1].name, "Else");
                const body = if (has_else) node.children[0 .. node.children.len - 1] else node.children;
                const cases = try self.allocator.alloc(Flow.Case, if (has_else) 2 else 1);

                cases[0] = .{ .value = .{ .name = "value", .value = "true", .kind = .expression, .location = subject.location, .value_location = subject.value_location }, .body = try self.steps(body) };

                if (has_else) cases[1] = .{ .value = null, .body = try self.steps(node.children[node.children.len - 1].children) };

                break :selection .{ .selection = .{ .subject = subject, .cases = cases } };
            } else return self.fail(node.location, "unsupported", "RX execution supports Store declarations, Call, Return, Task, Switch, If and pure Parallel branches; events require host linking");

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
        const edge = self.references.next(.call);

        const callee = switch (edge.target) {
            .source => |source| try self.sourceCallee(source, edge.location, capability.setter != null),
            .compiled => |selected| try self.compiledCallee(node, selected, capability.setter),
            .native => return self.fail(edge.location, "module", "native and standard imports must use the interface registry"),
        };

        try self.calls.append(self.allocator, .{
            .node = node,
            .setter = capability.setter,
            .getters = capability.getters,
            .edge = edge,
            .callee = callee,
        });

        return index;
    }

    fn sourceCallee(self: *Loader, source: usize, location: rx.ast.Location, setter: bool) Error!Callee {
        switch (self.signatures.graph.modules[source].source) {
            .rx => |index| return .{ .module = index },
            .store => return self.fail(location, "module", "Call.module target is not registered"),
            .zx => {},
        }

        const module = self.signatures.get(source) orelse return self.fail(location, "module", "source function signature is missing from the analyzed input set");
        const signature = module.signature;
        const forwarded = signature.deferredSource();

        return switch (routeSignature(forwarded != null, signature.type_only, setter, signature.has_store)) {
            .Function => .{ .signature = signature.ports },
            .Forward => .{ .module = self.deferredModule(forwarded.?) orelse return self.fail(location, "module", "default re-export target is missing from the RX module collection") },
            .SetterOnForward => self.fail(location, "capability", "RX module Store authorization belongs inside the module"),
            .TypeOnly => self.fail(location, "module", "Call.fn requires an executable ZX module with a default function"),
            .MissingStore => self.fail(location, "capability", "a Call.setter target must declare its second parameter as { store }"),
        };
    }
    fn compiledCallee(self: *Loader, node: rx.ast.Node, selected: frontend.project.compiled.Target, setter: ?target.Setter) Error!Callee {
        if ((target.optionalAttribute(node, "setter") != null) != (setter != null) or self.project.context.stores.len != 0) return self.fail(node.location, "capability", "Store calls require explicit per-call authorization from module declarations");

        const result = try @import("../call/compiled.zig").load(self.allocator, .{
            .owner = self.owner,
            .call = node,
            .project = self.project,
            .setter = setter,
            .selected = selected,
        });

        if (result == .diagnostic) {
            self.issue = result.diagnostic;

            return error.InvalidFlow;
        }

        const function = result.function;

        self.project.context.types = function.program.types;
        self.project.context.nominal_types = function.nominal_types;
        self.project.context.native_modules = function.program.native_modules;

        return .{ .signature = .{ .input_type = function.program.input_type, .output_type = function.program.output_type } };
    }
    fn deferredModule(self: *const Loader, path: []const u8) ?usize {
        for (self.modules) |module| {
            if (zx.bytes.equal(module.path, path)) return module.source.rx;
        }

        return null;
    }
    fn fail(self: *Loader, location: rx.ast.Location, code: []const u8, message: []const u8) Error {
        const result = try target.failure(self.allocator, .{ .path = self.owner, .location = location, .code = code, .message = message });

        self.issue = result.diagnostic;

        return error.InvalidFlow;
    }
};

const SignatureRoute = if (generated)
    @typeInfo(@TypeOf(@import("generated_rx_call_signature").executeValue(undefined, undefined))).error_union.payload

else
    enum { Function, Forward, SetterOnForward, TypeOnly, MissingStore };

fn routeSignature(forwards_rx: bool, type_only: bool, setter: bool, has_store: bool) SignatureRoute {
    if (comptime generated) {
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const rule = @import("generated_rx_call_signature");
        const input: std.meta.Child(rule.Input) = .{ .forwards_rx = forwards_rx, .type_only = type_only, .setter = setter, .has_store = has_store };

        return zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (forwards_rx) return if (setter) .SetterOnForward else .Forward;
    if (type_only) return .TypeOnly;
    if (setter and !has_store) return .MissingStore;

    return .Function;
}

pub fn find(modules: []const rx.ModuleSource, path: []const u8) ?usize {
    for (modules, 0..) |source, index| {
        if (std.mem.eql(u8, source.path, path)) return index;
    }

    return null;
}
