const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const target = @import("../call/target.zig");
const Libraries = @import("../call/library_bindings.zig");
const Inputs = @import("call_inputs.zig");
const Store = @import("../store.zig");
const Flow = @import("flow.zig");
const Action = rx.IndexedFlow.Operation;
const zx = @import("zx");
const Graph = @import("source_graph/model.zig");
const Signatures = @import("references/signatures.zig");
const generated = @import("rx_options").generated_graph;
const Callee = union(enum) { module: usize, signature: frontend.project.signature_project.Ports };
pub const Call = struct { setter: ?target.Setter = null, getters: []const Store.Binding = &.{}, node: rx.ast.Node, edge: *const Graph.Edge, callee: Callee };
pub const Module = struct { source: rx.ModuleSource, shortcut: ?usize = null, calls: []const Call, steps: []const Flow.Step, type_imports: []const @import("zx").ir.Export = &.{}, value_imports: []const @import("zx").ir.Export = &.{} };
pub const Loaded = struct { modules: []const Module, project: frontend.project.Options };
pub const Value = union(enum) { loaded: Loaded, diagnostic: target.Diagnostic };

pub fn loadSignatures(allocator: std.mem.Allocator, backing: std.mem.Allocator, modules: []const rx.ModuleSource, registered: []const Graph.Module, initial_project: frontend.project.Options, definitions: []const Store.Definition, signatures: Signatures, inputs: *Inputs) std.mem.Allocator.Error!Value {
    const plans = try allocator.alloc(Module, modules.len);

    var loader = Loader{
        .allocator = allocator,
        .backing = backing,
        .project = initial_project,
        .signatures = signatures,
        .inputs = inputs,
        .libraries = .{ .allocator = allocator, .scratch = std.heap.ArenaAllocator.init(backing) },
    };

    defer loader.libraries.scratch.deinit();

    for (modules, registered, plans, 0..) |source, module, *plan, index| {
        loader.owner = source.path;
        loader.references = .{ .remaining = module.dependencies };
        loader.calls = .empty;
        loader.arguments = .empty;
        loader.task_count = 0;
        loader.deferred_shortcut = null;

        const references = try @import("../store/references.zig").resolve(allocator, source, module.dependencies, signatures.graph.modules, definitions);

        if (references == .diagnostic) return .{ .diagnostic = references.diagnostic };

        loader.stores = references.bindings;
        loader.flow = source.indexedFlow();

        const steps = loader.moduleBody(source.node) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return .{ .diagnostic = loader.issue.? };
        };

        const imported = try @import("type_imports.zig").collect(allocator, source, module, signatures);

        if (imported == .diagnostic) return .{ .diagnostic = imported.diagnostic };
        try inputs.publish(modules.len, index, loader.arguments.items);

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
    backing: std.mem.Allocator,
    project: frontend.project.Options,
    signatures: Signatures,
    libraries: Libraries,
    inputs: *Inputs,
    arguments: std.ArrayList(?*const frontend.ExpressionInput.Result) = .empty,
    references: Graph.References = .{ .remaining = &.{} },
    owner: []const u8 = "",
    flow: ?rx.IndexedFlow = null,
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
    fn moduleBody(self: *Loader, node: rx.ast.Node) Error![]const Flow.Step {
        if (target.optionalAttribute(node, "fn") != null) return self.shortcut(node);

        const count = if (self.flow) |flow| flow.module_steps else node.children.len;

        return (try self.steps(node.children, count)).steps.items;
    }
    fn steps(self: *Loader, nodes: []const rx.ast.Node, count: usize) Error!Flow.Sequence {
        var sequence: Flow.Sequence = .{};

        if (self.flow != null) sequence.steps = try std.ArrayList(Flow.Step).initCapacity(self.allocator, count);

        for (nodes) |*node| {
            const flags = if (self.flow) |flow| flow.get(node) else null;
            const action = if (flags) |fact| fact.action else seedAction(node.name);

            if (action == .declaration) continue;

            const unreachable_step = if (flags) |fact| fact.unreachable_step else sequence.exits.terminates;

            if (unreachable_step) return self.fail(node.location, "return_path", "steps after a terminating Return, Switch or If are unreachable");

            var exits: Flow.Exits = .{};

            const value: @FieldType(Flow.Step, "value") = switch (action) {
                .result => result: {
                    exits = Flow.Exits.returned;

                    break :result .{ .result = target.attribute(node.*, "value") };
                },
                .call => .{ .call = try self.call(node.*) },
                .task => task: {
                    const body = try self.taskBody(node, false);

                    exits = body.exits;

                    break :task .{ .task = .{ .node = node.*, .body = body.steps.items } };
                },
                .parallel => .{ .parallel = try self.parallel(node.*) },
                .switch_flow, .if_flow => selection: {
                    const subject = target.attribute(node.*, "on");
                    var branches: Flow.BranchExits = .{};
                    const cases = if (action == .switch_flow) try self.switchCases(node.*, &branches) else try self.ifCases(node.*, subject, &branches);

                    exits = branches.finish();

                    break :selection .{ .selection = .{ .subject = subject, .cases = cases } };
                },
                else => return self.fail(node.location, "unsupported", "RX execution supports Store declarations, Call, Return, Task, Switch, If and pure Parallel branches; events require host linking"),
            };

            if (flags == null) {
                try sequence.append(self.allocator, value, exits);
            } else {
                sequence.steps.appendAssumeCapacity(.{ .value = value });
            }
        }

        return sequence;
    }
    fn switchCases(self: *Loader, node: rx.ast.Node, exits: *Flow.BranchExits) Error![]const Flow.Case {
        const cases = try self.allocator.alloc(Flow.Case, node.children.len);

        for (node.children, cases) |*child, *case| {
            const default = if (self.flow) |flow| flow.get(child).alternate else rx.execution.admit(child.name, .Any) == .Default;
            const value = if (default) null else target.attribute(child.*, "value");

            case.* = try self.selectionCase(value, child.children, exits);
        }

        return cases;
    }
    fn ifCases(self: *Loader, node: rx.ast.Node, subject: rx.ast.Attribute, exits: *Flow.BranchExits) Error![]const Flow.Case {
        const last = &node.children[node.children.len - 1];
        const has_else = if (self.flow) |flow| flow.get(last).alternate else rx.execution.admit(last.name, .Any) == .Else;
        const body = if (has_else) node.children[0 .. node.children.len - 1] else node.children;
        const cases = try self.allocator.alloc(Flow.Case, if (has_else) 2 else 1);
        const value = rx.ast.Attribute{ .name = "value", .value = "true", .kind = .expression, .location = subject.location, .value_location = subject.value_location };
        cases[0] = try self.selectionCase(value, body, exits);

        if (has_else) cases[1] = try self.selectionCase(null, last.children, exits);

        return cases;
    }
    fn selectionCase(self: *Loader, value: ?rx.ast.Attribute, nodes: []const rx.ast.Node, exits: *Flow.BranchExits) Error!Flow.Case {
        const body = try self.steps(nodes, nodes.len);

        if (self.flow == null) exits.add(value == null, body.exits);

        return .{ .value = value, .body = body.steps.items };
    }
    fn parallel(self: *Loader, node: rx.ast.Node) Error![]const Flow.Branch {
        const branches = try self.allocator.alloc(Flow.Branch, node.children.len);

        for (node.children, branches) |*child, *branch| {
            const flags = if (self.flow) |flow| flow.get(child) else null;
            const action = if (flags) |fact| fact.action else seedAction(child.name);

            if (action == .call) {
                branch.* = .{ .call = try self.call(child.*) };

                continue;
            }

            const id = if (self.flow) |flow|
                flow.taskId(flags.?) orelse self.nextTaskId()

            else
                self.nextTaskId();

            const body = try self.taskBody(child, true);

            branch.* = .{ .task = .{ .id = id, .node = child.*, .body = body.steps.items } };
        }

        return branches;
    }
    fn nextTaskId(self: *Loader) usize {
        const id = self.task_count;

        self.task_count += 1;

        return id;
    }
    fn taskBody(self: *Loader, node: *const rx.ast.Node, parallel_task: bool) Error!Flow.Sequence {
        const output = target.optionalAttribute(node.*, "out");
        const count = node.children.len + @intFromBool(parallel_task and output != null);
        var body = try self.steps(node.children, count);
        const attribute = output orelse return body;
        const returns = if (self.flow) |flow| flow.get(node).returns else body.exits.returns;

        if (returns) return self.fail(attribute.value_location, "return_path", "Task.out and Return cannot both define the same task output");
        if (parallel_task) try body.append(self.allocator, .{ .result = attribute }, Flow.Exits.returned);

        return body;
    }
    fn call(self: *Loader, node: rx.ast.Node) Error!usize {
        const index = self.calls.items.len;
        const input = if (target.optionalAttribute(node, "in")) |value| try self.inputs.parse(value, self.owner) else null;
        const authorized = try @import("../store/call.zig").analyze(self.allocator, self.backing, self.owner, node, self.stores, input);

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

        if (input) |parsed| {
            const first = self.arguments.items.len;

            try self.arguments.resize(self.inputs.arena.allocator(), index + 1);

            @memset(self.arguments.items[first..index], null);

            self.arguments.items[index] = parsed;
        }

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
        const forwarded = self.signatures.forwarded(source);

        return switch (routeSignature(forwarded != .none, signature.type_only, setter, signature.has_store)) {
            .Function => .{ .signature = signature.ports },
            .Forward => if (forwarded == .module) .{ .module = forwarded.module } else self.fail(location, "module", "default re-export target is missing from the RX module collection"),
            .SetterOnForward => self.fail(location, "capability", "RX module Store authorization belongs inside the module"),
            .TypeOnly => self.fail(location, "module", "Call.fn requires an executable ZX module with a default function"),
            .MissingStore => self.fail(location, "capability", "a Call.setter target must declare its second parameter as { store }"),
        };
    }
    fn compiledCallee(self: *Loader, node: rx.ast.Node, selected: frontend.project.compiled.Target, setter: ?target.Setter) Error!Callee {
        if ((target.optionalAttribute(node, "setter") != null) != (setter != null) or self.project.context.stores.len != 0) return self.fail(node.location, "capability", "Store calls require explicit per-call authorization from module declarations");

        const result = try self.libraries.bind(&self.project, .{
            .owner = self.owner,
            .location = target.attribute(node, "module").value_location,
            .setter = setter != null,
            .selected = selected,
        });

        if (result == .diagnostic) {
            self.issue = result.diagnostic;

            return error.InvalidFlow;
        }

        return .{ .signature = result.ports };
    }
    fn fail(self: *Loader, location: rx.ast.Location, code: []const u8, message: []const u8) Error {
        const result = try target.failure(self.allocator, .{ .path = self.owner, .location = location, .code = code, .message = message });

        self.issue = result.diagnostic;

        return error.InvalidFlow;
    }
};

fn seedAction(name: []const u8) Action {
    return switch (rx.execution.admit(name, .Any)) {
        .Import, .Store, .Type, .Args => .declaration,
        .Return => .result,
        .Call => .call,
        .Task => .task,
        .Parallel => .parallel,
        .Switch => .switch_flow,
        .If => .if_flow,
        else => .unsupported,
    };
}

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
