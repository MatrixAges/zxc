const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("module.zig");
const Prepared = @import("project/flow.zig");
const Flow = @import("program/flow.zig");
const expression = @import("expression.zig");
const target = @import("call/target.zig");
const Captures = @import("task_captures.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{InvalidFlow};

allocator: std.mem.Allocator,
scratch: std.mem.Allocator,
binding_allocator: std.mem.Allocator,
owner: []const u8,

aliases: []const zx.ir.Export = &.{},
types: zx.ir.TypeTable,
/// What the expressions extend in place while `types` views it whole.
type_storage: zx.ir.TypeStorage = .{},
native_modules: zx.ir.NativeModuleTable = .{},
shared_functions: ?zx.ir.FunctionTable = null,
verified_functions: zx.ir.FunctionTable = .{},
output_type: zx.ir.TypeId,
loaded: []const Module.Loaded,
results: []const Module.Binding,
tasks: []const zx.ir.TypeId = &.{},

captures: ?*Captures = null,
bindings: std.ArrayList(frontend.expressions.Binding) = .empty,
nonnull: std.ArrayList([]const u8) = .empty,
calls: std.ArrayList(Module.Call) = .empty,
next_binding: usize = 0,
unit_input: bool = false,
issue: ?expression.Diagnostic = null,
pub fn steps(self: *Self, sequence: []const Prepared.Step) Error![]const Flow.Step {
    const result = try self.allocator.alloc(Flow.Step, sequence.len);

    for (sequence, result) |step, *compiled| {
        compiled.* = switch (step.value) {
            .call => |index| .{ .call = try self.call(self.loaded[index]) },
            .parallel => |branches| parallel: {
                const count = self.bindings.items.len;
                const calls = try self.allocator.alloc(usize, branches.len);
                var outputs: std.ArrayList(frontend.expressions.Binding) = .empty;

                defer outputs.deinit(self.binding_allocator);

                for (branches, calls) |branch, *compiled_call| {
                    compiled_call.* = switch (branch) {
                        .call => |index| try self.call(self.loaded[index]),
                        .task => |task| try @import("parallel_task.zig").compile(self, task),
                    };

                    const invocation = self.calls.items[compiled_call.*];

                    if (!try frontend.isParallelSafe(self.allocator, invocation.callee)) {
                        const location = switch (branch) {
                            .call => |index| self.loaded[index].node.location,
                            .task => |task| task.node.location,
                        };

                        self.issue = .{ .location = location, .issue = .{ .code = .unsupported, .span = .{ .start = location.offset, .end = location.offset }, .message = "Parallel branches require pure functions without Store capabilities or native external calls" } };

                        return error.InvalidFlow;
                    }

                    try outputs.appendSlice(self.binding_allocator, self.bindings.items[count..]);

                    self.bindings.shrinkRetainingCapacity(count);
                }

                try self.bindings.appendSlice(self.binding_allocator, outputs.items);

                break :parallel .{ .parallel = calls };
            },
            .result => |attribute| .{ .result = try self.value(attribute, self.output_type) },
            .task => |task| scope: {
                const count = self.bindings.items.len;
                const nested = try self.steps(task.body);
                var task_step: @FieldType(Flow.Step, "task") = .{ .body = nested };
                var published: ?Module.Binding = null;

                if (target.optionalAttribute(task.node, "out")) |attribute| {
                    const binding = self.results[self.next_binding];
                    self.next_binding += 1;
                    const has_value = binding.type_id != @as(zx.ir.TypeId, @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void))));

                    task_step.output = .{ .value = try self.value(attribute, binding.type_id), .name = if (has_value) binding.name else null };

                    if (has_value) published = binding;
                }

                self.bindings.shrinkRetainingCapacity(count);

                if (published) |binding| try self.bindings.append(self.binding_allocator, .{ .name = binding.name, .type_id = binding.type_id });

                break :scope .{ .task = task_step };
            },
            .selection => |selection| selection: {
                const condition = @import("condition.zig");
                var parsed = try @import("attribute.zig").parse(self.allocator, selection.subject, self.owner);

                defer parsed.deinit();

                const subject = try self.valueParsed(&parsed, selection.subject, null);
                const cases = try self.allocator.alloc(Flow.Case, selection.cases.len);
                const count = self.bindings.items.len;
                var labels: condition.Cases = .{ .allocator = self.allocator, .owner = self.owner };

                defer labels.deinit();

                for (selection.cases, cases, 0..) |case, *item, index| {
                    const label: struct { value: ?zx.ir.Program, truth: ?bool } = if (case.value) |attribute| label: {
                        var label = try labels.label(attribute);

                        defer label.deinit();

                        const program = try self.valueParsed(&label, attribute, subject.output_type);
                        const truth = condition.boolean(&label);

                        labels.observe(truth);

                        break :label .{ .value = program, .truth = truth };
                    } else .{ .value = null, .truth = try labels.remaining(selection.cases[index + 1 ..]) };

                    const facts = self.nonnull.items.len;

                    if (label.truth) |present| {
                        condition.assumeParsed(self.allocator, &parsed, present, self) catch |err| switch (err) {
                            error.OutOfMemory => return error.OutOfMemory,
                            else => return error.InvalidFlow,
                        };
                    }

                    const body = try self.steps(case.body);

                    self.nonnull.shrinkRetainingCapacity(facts);
                    self.bindings.shrinkRetainingCapacity(count);

                    item.* = .{ .value = label.value, .body = body };
                }

                const checked = try @import("selection.zig").check(self.allocator, subject, selection.subject, cases, selection.cases);

                if (checked == .diagnostic) {
                    self.issue = checked.diagnostic;

                    return error.InvalidFlow;
                }

                break :selection .{ .selection = .{ .subject = subject, .cases = cases, .exhaustive = checked.exhaustive } };
            },
        };
    }

    return result;
}

fn value(self: *Self, attribute: rx.ast.Attribute, expected: ?zx.ir.TypeId) Error!zx.ir.Program {
    var parsed = try @import("attribute.zig").parse(self.allocator, attribute, self.owner);

    defer parsed.deinit();

    return self.valueParsed(&parsed, attribute, expected);
}

fn valueParsed(self: *Self, parsed: *const frontend.ExpressionInput.Result, attribute: rx.ast.Attribute, expected: ?zx.ir.TypeId) Error!zx.ir.Program {
    try self.ensureTypeStorage();

    var arena = std.heap.ArenaAllocator.init(self.scratch);
    var buffer: [std.heap.page_size_min / 8]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const selection = try @import("expression_scope.zig").select(scratch.allocator(), parsed, self.bindings.items, self.nonnull.items);

    const compiled = try expression.compileParsed(self.allocator, parsed, attribute, .{
        .types = self.types,
        .borrow_types = true,
        .type_storage = &self.type_storage,
        .native_modules = self.native_modules,
        .aliases = self.aliases,
        .bindings = selection.bindings,
        .nonnull_bindings = self.nonnull.items,
        .unit_bindings = if (self.unit_input) &.{"$in"} else &.{},
        .expected = expected,
        .scratch_backing = self.scratch,
    }, true);

    if (compiled.value == .diagnostic) {
        self.issue = compiled.value.diagnostic;

        return error.InvalidFlow;
    }

    const program = compiled.value.ir;

    self.types = program.types;

    if (self.captures) |captures| captures.observeMapped(program.expressions.references, selection.positions);

    return program;
}

pub fn takeTypeStorage(self: *Self) Error!zx.ir.TypeStorage {
    try self.ensureTypeStorage();

    const storage = self.type_storage;

    self.type_storage = .{};

    return storage;
}

fn ensureTypeStorage(self: *Self) Error!void {
    if (viewed(self.type_storage, self.types)) return;

    self.type_storage = .{};

    try self.type_storage.appendDelta(self.allocator, self.types);

    self.types = self.type_storage.view();
}

/// Whether `types` is already backed by this flow's append-only storage.
fn viewed(storage: zx.ir.TypeStorage, types: zx.ir.TypeTable) bool {
    inline for (@typeInfo(zx.ir.TypeStorage).@"struct".field_names) |name| {
        const column = @field(storage, name).items;

        if (column.ptr != @field(types, name).ptr or column.len != @field(types, name).len) return false;
    }

    return true;
}

fn call(self: *Self, loaded: Module.Loaded) Error!usize {
    const count = self.bindings.items.len;

    for (loaded.getters) |getter| try self.bindings.append(self.binding_allocator, .{ .name = getter.name, .type_id = getter.slot.type_id });

    const argument = if (target.optionalAttribute(loaded.node, "in")) |attribute| try self.value(attribute, loaded.function.program.input_type) else try @import("call/unit.zig").create(self.allocator, self.owner, self.types, loaded.node.location);

    self.bindings.shrinkRetainingCapacity(count);

    var out: ?[]const u8 = null;
    const binding = self.results[self.next_binding];

    self.next_binding += 1;

    if (binding.type_id != @as(zx.ir.TypeId, @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void))))) {
        try self.bindings.append(self.binding_allocator, .{ .name = binding.name, .type_id = binding.type_id });

        out = binding.name;
    }

    const index = self.calls.items.len;

    try self.calls.append(self.allocator, .{ .function_id = loaded.function.id, .callee = loaded.function.program, .store_initializers = loaded.function.store_initializers, .argument = argument, .input_omitted = target.optionalAttribute(loaded.node, "in") == null, .out = out, .getters = loaded.getters });

    return index;
}

pub fn assumeNonNull(self: *Self, expression_value: anytype) zx.Error!void {
    try @import("condition.zig").publish(self.allocator, expression_value, self.bindings.items, false, &self.nonnull);
}
