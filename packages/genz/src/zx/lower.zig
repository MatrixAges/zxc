const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const ir = zx.ir;
const Self = @This();
pub const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
workspace: std.mem.Allocator,
program: ir.Program,
entry_flags: @import("entry_flags.zig").Flags,
self_function: ?ir.FunctionId = null,
builder: Builder,
types: []node.ExpressionId,
layouts: []node.ExpressionId,
abi_types: []node.ExpressionId = &.{},
abi_layouts: []node.ExpressionId = &.{},
state_types: []node.ExpressionId = &.{},
state_layouts: []node.ExpressionId = &.{},
view_types: []node.ExpressionId = &.{},
state_plan: @import("state_value/analysis.zig"),
state_active: bool = false,
deferred_lists: bool = false,
state_symbols: std.AutoHashMapUnmanaged(ir.SymbolId, void) = .empty,
names: [][]const u8,
native_names: []const []const u8 = &.{},
used: []bool,
cache_reads: []usize,
cache: std.AutoHashMapUnmanaged(ir.ExprId, node.ExpressionId) = .empty,
plans: []const @import("uniqueness/root.zig").Plan = &.{},
plan: @import("uniqueness/root.zig").Plan = .{ .flags = &.{} },
serial: usize = 0,
capture: ?@import("capture.zig").Boundary = null,
uses_allocator: bool = false,
allows_allocation: bool = false,
uses_io: bool = false,
uses_process: bool = false,
io_functions: []const bool = &.{},
process_functions: []const bool = &.{},
task_functions: []const bool,
value_functions: []const bool = &.{},
/// The errors each function raises, joined at calls instead of visiting the callee; null visits callees.
function_errors: ?[]const ?[]const []const u8 = null,
pure_functions: []const bool = &.{},
/// The pure functions that compare no represented aggregates by identity, themselves or through their callees.
identity_free_functions: []const bool = &.{},
local_functions: []const bool = &.{},
fresh_outputs: []const bool = &.{},
constructed_outputs: []const bool = &.{},
value_output: bool = false,
public_value_output: bool = false,
stack_symbols: std.AutoHashMapUnmanaged(ir.SymbolId, void) = .empty,
reference_storage: std.ArrayList(node.Statement) = .empty,
projected_symbols: ?[]const bool = null,
input_aliases: ?[]const bool = null,
iteration_value: ?*@import("iteration_value/root.zig") = null,
loop_fields: ?*const @import("iteration/fields/root.zig") = null,
layout_types: []const @import("iteration_layout/generated.zig").Type = &.{},
slot_counts: []const u32 = &.{},
growth_functions: []const bool = &.{},
may_grow: bool = true,
uses_context: bool = false,
uses_parallel: bool = false,
shared_types: bool = false,
pending_name: []const u8 = "zx_pending",
type_names: ?[]const []const u8 = null,
function_modules: ?[]const []const u8 = null,
function_requests: *@import("functions/requests.zig") = undefined,
comparisons: *std.ArrayList(ir.TypeId) = undefined,
task_declarations: *std.ArrayList(node.Declaration) = undefined,
pub fn refreshEntry(self: *Self) Error!void {
    self.entry_flags = try @import("entry_flags.zig").analyze(self.workspace, self.program, .{ .local = self.local_functions, .pure = self.pure_functions, .io = self.io_functions, .process = self.process_functions, .tasks = self.task_functions, .self_function = self.self_function });
}

pub fn declarations(self: *Self) Error![]const node.Declaration {
    var output: std.ArrayList(node.Declaration) = .empty;
    var comparisons: std.ArrayList(ir.TypeId) = .empty;
    var task_declarations: std.ArrayList(node.Declaration) = .empty;
    self.comparisons = &comparisons;
    self.task_declarations = &task_declarations;

    var function_requests = try @import("functions/requests.zig").init(self.allocator, self.program.functions.count());

    self.function_requests = &function_requests;

    try output.append(self.allocator, .{ .constant = .{ .name = "std", .value = try self.builtin(.import, &.{try self.builder.string("std")}) } });
    if (self.function_modules == null) self.native_names = try @import("imports.zig").lower(self, &output);
    try @import("types.zig").lower(self, &output, false);
    for (self.program.exports) |item| try output.append(self.allocator, .{ .constant = .{ .name = item.name, .value = try self.typeExpr(item.type_id), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_io", .value = try self.builder.expression(.{ .boolean = self.entry_flags.io }), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_process", .value = try self.builder.expression(.{ .boolean = self.entry_flags.process }), .exported = true } });
    if (self.program.type_only) return output.toOwnedSlice(self.allocator);
    try @import("shape.zig").lower(self, &output);

    for ([_][]const u8{ "Input", "Output" }, [_]ir.TypeId{ self.program.input_type, self.program.output_type }) |contract_name, type_id| {
        var exported = false;

        for (self.program.exports) |item| {
            if (std.mem.eql(u8, item.name, contract_name)) exported = true;
        }

        if (!exported) try output.append(self.allocator, .{ .constant = .{ .name = contract_name, .value = try self.typeExpr(type_id), .exported = true } });
    }

    try @import("store.zig").declaration(self, &output);
    try @import("entry.zig").declarations(self, &output);
    try @import("entry_values.zig").declarations(self, &output);

    var function_index: usize = 0;

    while (function_index < function_requests.count()) : (function_index += 1) {
        try @import("functions/emit.zig").append(self, &output, function_requests.at(function_index));
    }

    try output.appendSlice(self.allocator, task_declarations.items);
    if (self.uses_parallel) try output.append(self.allocator, try @import("parallel/allocator.zig").declaration(self));
    for (comparisons.items) |type_id| try output.append(self.allocator, try @import("comparison.zig").ordering(self, type_id));

    return output.toOwnedSlice(self.allocator);
}

pub fn functionValue(self: *Self, name: []const u8) Error!node.Declaration {
    return self.valueMode(name, false);
}

pub fn valuePrototype(self: *Self, name: []const u8) Error!node.Function {
    return (try self.valueMode(name, true)).function;
}

fn valueMode(self: *Self, name: []const u8, prototype_only: bool) Error!node.Declaration {
    const state = if (self.state_plan.represented(self.program, self.program.output_type) or self.state_plan.inlineRows(self.program, self.program.input_type)) try @import("state_value/root.zig").enter(self) else null;

    defer if (state) |saved| saved.restore();

    if (self.state_active and !self.public_value_output) try self.state_symbols.put(self.allocator, @fromBackingInt(0), {});

    defer _ = self.state_symbols.remove(@fromBackingInt(0));
    const output = self.program.typeOf(self.program.output_type);

    self.value_output = state == null or self.state_plan.represented(self.program, self.program.output_type) or (output != .object and output != .tuple);
    defer self.value_output = false;

    return if (prototype_only) .{ .function = try self.prototype(name, false) } else self.function(name, false);
}

pub fn function(self: *Self, name: []const u8, exported: bool) Error!node.Declaration {
    self.reference_storage = .empty;
    self.projected_symbols = null;
    self.input_aliases = null;
    self.uses_allocator = false;
    self.uses_context = false;
    self.uses_io = false;
    self.uses_process = false;

    const errors = try @import("zx").error_effects.programWith(self.allocator, self.program, self.function_errors);

    self.allows_allocation = if (errors) |names| for (names) |error_name| {
        if (std.mem.eql(u8, error_name, "OutOfMemory")) break true;
    } else false else true;

    const needs_io = self.entry_flags.io;
    const needs_process = self.entry_flags.process;

    for (self.names, 0..) |*item, index| item.* = if (index == 0) "in" else try std.fmt.allocPrint(self.allocator, "value_{d}", .{index});

    @memset(self.used, false);
    @memset(self.cache_reads, 0);

    const body_statements = try self.statements(self.program.body.block());
    const preconditions = try @import("contracts.zig").preconditions(self);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .expression = try self.builtin(.setRuntimeSafety, &.{try self.builder.expression(.{ .boolean = true })}) });

    if (exported and self.uses_allocator) {
        if (self.entry_flags.tasks) {
            self.uses_io = true;

            try @import("tasks/allocator.zig").initialize(self, &body);
        } else try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) } });
    } else if (!self.uses_allocator) try body.append(self.allocator, .{ .discard = try self.builder.identifier(if (exported) "arena" else "allocator") });

    if (self.program.stores.count() > 0 and !self.transaction() and !self.uses_context) try body.append(self.allocator, .{ .discard = try self.builder.identifier("context") });
    if (needs_io and !self.uses_io) try body.append(self.allocator, .{ .discard = try self.builder.identifier("io") });
    if (needs_process and !self.uses_process) try body.append(self.allocator, .{ .discard = try self.builder.identifier("process") });
    if (!self.used[0]) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });

    if (self.transaction()) {
        const fields = try self.allocator.alloc(node.Field, self.program.stores.count());

        for (fields, 0..) |*item, index| item.* = .{ .name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{index}), .value = try self.builder.expression(.null_value) };

        const pending = node.Constant{ .name = "pending", .type_expr = try self.builder.identifier(self.pending_name), .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier(self.pending_name), .fields = fields } }) };

        try body.append(self.allocator, if (@import("statements.zig").writes(self.program.body.block())) .{ .variable = pending } else .{ .constant = pending });
    }

    try body.appendSlice(self.allocator, self.reference_storage.items);
    try body.appendSlice(self.allocator, preconditions);
    try body.appendSlice(self.allocator, body_statements);
    if (self.transaction() and !ir.terminates(self.program.body.block())) try body.append(self.allocator, .{ .expression = try self.commit() });

    var declaration = try self.prototypeWithErrors(name, exported, errors);

    declaration.body = try self.builder.statements(body.items);

    return .{ .function = declaration };
}

pub fn prototype(self: *Self, name: []const u8, exported: bool) Error!node.Function {
    const errors = try @import("zx").error_effects.programWith(self.allocator, self.program, self.function_errors);

    return self.prototypeWithErrors(name, exported, errors);
}

fn prototypeWithErrors(self: *Self, name: []const u8, exported: bool, errors: ?[]const []const u8) Error!node.Function {
    const needs_io = self.entry_flags.io;
    const needs_process = self.entry_flags.process;
    const injected = self.program.stores.count() > 0;
    const parameters = try self.allocator.alloc(node.Field, 2 + @as(usize, @intFromBool(injected)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));

    parameters[0] = if (exported) .{ .name = "arena", .value = try self.builder.expression(.{ .pointer = try @import("intrinsics.zig").standardField(self, &.{ "heap", "ArenaAllocator" }) }) } else .{ .name = "allocator", .value = try @import("intrinsics.zig").standardField(self, &.{ "mem", "Allocator" }) };
    parameters[1] = .{ .name = "in", .value = if (self.public_value_output) try @import("types.zig").get(self, self.view_types, self.program.input_type) else try self.typeExpr(self.program.input_type) };

    if (injected) parameters[2] = .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) };
    if (needs_io) parameters[2 + @as(usize, @intFromBool(injected))] = .{ .name = "io", .value = try @import("intrinsics.zig").standardField(self, &.{"Io"}) };
    if (needs_process) parameters[parameters.len - 1] = .{ .name = "process", .value = try @import("intrinsics.zig").standardField(self, &.{ "process", "Init", "Minimal" }) };

    return .{ .name = name, .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = .{ .payload = if (self.public_value_output) try @import("types.zig").get(self, self.view_types, self.program.output_type) else if (self.value_output) try self.layoutExpr(self.program.output_type) else try self.typeExpr(self.program.output_type), .errors = errors } }), .body = .{}, .exported = exported, .inlined = if (@hasField(@TypeOf(self.entry_flags), "inlined")) self.entry_flags.inlined else false };
}

pub fn expr(self: *Self, id: ir.ExprId) Error!node.ExpressionId {
    const value = if (self.iteration_value) |context| try context.expression(id) orelse try self.regular(id) else try self.regular(id);
    const flags = self.plan.get(id);

    if (flags.normalize) return @import("growth.zig").normalize(self, id, value);
    if (flags.renew) return @import("growth.zig").renewValue(self, id, value);

    return value;
}

pub fn regular(self: *Self, id: ir.ExprId) Error!node.ExpressionId {
    if (self.cache.get(id)) |cached| {
        self.cache_reads[@backingInt(id)] += 1;

        return cached;
    }

    const value = self.program.expression(id);
    const value_type = try self.typeExpr(value.type_id);

    return switch (value.value) {
        .task => @import("tasks/root.zig").start(self, id, false),
        .await_task => |child| @import("tasks/root.zig").wait(self, child),
        .cancel_task => |child| @import("tasks/root.zig").cancel(self, child),
        .parallel => |branches| @import("tasks/root.zig").parallel(self, value.type_id, branches),
        .capture => |child| @import("capture.zig").lower(self, value.type_id, child),
        .optional_value => |child| self.builder.expression(.{ .optional_unwrap = try self.expr(child) }),
        .integer => |integer| self.cast(value_type, try self.builder.integer(integer)),
        .negative_integer => |integer| self.cast(value_type, try self.builder.expression(.{ .unary = .{ .operator = .negate, .operand = try self.builder.integer(integer) } })),
        .float => |float| self.cast(value_type, try self.builder.expression(.{ .float = float })),
        .boolean => |boolean| self.builder.expression(.{ .boolean = boolean }),
        .string => |text| self.cast(value_type, try self.builder.string(text)),
        .unit => self.builder.expression(.unit),
        .none => self.cast(value_type, try self.builder.expression(.null_value)),
        .some => |child| self.cast(value_type, try self.expr(child)),
        .enum_value => |member| self.cast(value_type, try self.builder.expression(.{ .enum_literal = self.program.typeOf(value.type_id).enumeration.members[member] })),
        .error_value => |member| self.cast(value_type, try self.builder.expression(.{ .error_value = self.program.typeOf(value.type_id).error_set[member] })),
        .store_get => |slot| blk: {
            self.uses_context = true;

            const name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{slot});
            const current = try self.builder.expression(.{ .dereference = try self.field(try self.builder.identifier("context"), name) });
            const stored = if (self.transaction()) try self.builder.expression(.{ .binary = .{ .operator = .coalesce, .left = try self.field(try self.builder.identifier("pending"), name), .right = current } }) else current;

            if (!self.state_active or !self.state_plan.represented(self.program, value.type_id)) break :blk stored;
            if (self.program.typeOf(value.type_id) == .list) break :blk @import("state_value/list.zig").borrowed(self, value.type_id, stored);

            var body: std.ArrayList(node.Statement) = .empty;
            const source = try @import("aggregate.zig").bind(self, &body, stored);
            const converted = try @import("state_value/conversion.zig").convert(self, &body, value.type_id, source, .value);

            break :blk @import("aggregate.zig").finish(self, &body, converted);
        },
        .reference => |symbol| blk: {
            self.used[@backingInt(symbol)] = true;

            const reference = try self.builder.identifier(self.names[@backingInt(symbol)]);
            const value_reference = if (self.stack_symbols.contains(symbol)) try self.builder.expression(.{ .address_of = reference }) else reference;

            if (self.state_active and !self.state_symbols.contains(symbol)) {
                var body: std.ArrayList(node.Statement) = .empty;
                const converted = try @import("state_value/conversion.zig").convert(self, &body, value.type_id, value_reference, if (self.public_value_output and @backingInt(symbol) == 0) .view_value else .value);

                break :blk @import("aggregate.zig").finish(self, &body, converted);
            }

            break :blk value_reference;
        },
        .field => |item| self.projectedField(item.target, value.type_id, self.program.typeOf(self.program.expression(item.target).type_id).object.at(item.index).name),
        .tuple_field => |item| blk: {
            if (try @import("collections.zig").projection(self, item.target, item.index)) |selected| break :blk selected;

            break :blk self.projectedField(item.target, value.type_id, try std.fmt.allocPrint(self.allocator, "{d}", .{item.index}));
        },
        .index => |item| blk: {
            const indexed = try @import("intrinsics.zig").index(self, try @import("state_value/list.zig").expression(self, item.target), try self.expr(item.index));

            if (!self.state_active or !self.state_plan.represented(self.program, value.type_id)) break :blk indexed;

            var body: std.ArrayList(node.Statement) = .empty;
            const converted = try @import("state_value/elements.zig").read(self, &body, self.program.expression(item.target).type_id, indexed);

            break :blk @import("aggregate.zig").finish(self, &body, converted);
        },
        .length => |child| self.cast(value_type, try self.field(try @import("state_value/list.zig").expression(self, child), "len")),
        .unary => |unary| self.builder.expression(.{ .unary = .{ .operator = if (unary.operator == .not) .not else .negate, .operand = try self.expr(unary.operand) } }),
        .binary => |operation| self.binary(operation),
        .match_expr => |selection| @import("match.zig").lower(self, selection),
        .conditional => |conditional| self.builder.expression(.{ .conditional = .{ .condition = try self.expr(conditional.condition), .yes = try self.expr(conditional.yes), .no = try self.expr(conditional.no) } }),
        .object => |object| @import("aggregate.zig").object(self, id, object),
        .list, .tuple, .template => |items| @import("aggregate.zig").sequence(self, value, items),
        .list_operation => @import("collections.zig").lower(self, id),
        .transform => |transform| @import("transform.zig").lower(self, id, transform),
        .scope => |scope| @import("scope.zig").lower(self, scope),
        .iteration => |iteration| @import("iteration.zig").lower(self, id, iteration),
        .list_update => @import("list_update.zig").lower(self, id),
        .call => |invocation| blk: {
            var body: std.ArrayList(node.Statement) = .empty;
            const callee_function = self.program.functions.at(@backingInt(invocation.function));
            const state_callee = self.state_plan.represented(self.program, callee_function.output_type) or self.state_plan.inlineRows(self.program, callee_function.input_type);

            if (self.state_active and self.value_functions[@backingInt(invocation.function)] and state_callee) {
                if (self.state_plan.represented(self.program, callee_function.output_type)) break :blk @import("value_call/root.zig").invocation(self, invocation);

                break :blk @import("value_call/root.zig").pointerInvocation(self, invocation);
            }

            if (!self.state_active and self.allows_allocation and self.value_functions[@backingInt(invocation.function)] and self.state_plan.represented(self.program, callee_function.output_type)) break :blk @import("value_call/root.zig").pointerInvocation(self, invocation);
            if (self.allows_allocation and self.value_functions[@backingInt(invocation.function)] and self.constructed_outputs[@backingInt(invocation.function)]) break :blk @import("value_call/root.zig").pointerInvocation(self, invocation);

            const scalar = @import("types/scalar.zig").check(self.program.types, callee_function.output_type);
            const needs_io = self.io_functions[@backingInt(invocation.function)];
            const needs_process = self.process_functions[@backingInt(invocation.function)];
            const arguments = try self.allocator.alloc(node.ExpressionId, 2 + @as(usize, @intFromBool(invocation.stores.len > 0)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));

            arguments[0] = try self.builder.identifier("allocator");

            arguments[1] = if (callee_function.external != null and callee_function.external.?.expand_tuple and self.program.expression(invocation.argument).value == .tuple and !self.cache.contains(invocation.argument)) temporary: {
                const argument_value = self.program.expression(invocation.argument);
                const layout = try @import("aggregate.zig").tupleValue(self, argument_value, argument_value.value.tuple);
                const argument = try @import("aggregate.zig").bind(self, &body, try self.cast(try self.layoutExpr(argument_value.type_id), layout));

                break :temporary try self.builder.expression(.{ .address_of = argument });
            } else if (scalar and self.pure_functions[@backingInt(invocation.function)] and !self.cache.contains(invocation.argument)) temporary: {
                break :temporary try @import("value_call/argument.zig").borrow(self, &body, invocation.argument);
            } else if (self.state_active) converted: {
                const argument = try @import("aggregate.zig").bind(self, &body, try self.expr(invocation.argument));
                const output = self.program.typeOf(callee_function.output_type);

                const independent = (output == .object or output == .tuple) and
                    callee_function.input_type != callee_function.output_type and

                    self.value_functions[@backingInt(invocation.function)] and
                    self.fresh_outputs[@backingInt(invocation.function)];

                const borrow = !self.state_plan.represented(self.program, callee_function.output_type) and
                    (self.pure_functions[@backingInt(invocation.function)] or independent);

                break :converted try @import("state_value/conversion.zig").convert(self, &body, callee_function.input_type, argument, if (borrow) .borrow else .pointer);
            } else try self.expr(invocation.argument);

            if (invocation.stores.len > 0) arguments[2] = try @import("store.zig").adapter(self, invocation);

            if (needs_io) {
                self.uses_io = true;

                arguments[2 + @as(usize, @intFromBool(invocation.stores.len > 0))] = try self.builder.identifier("io");
            }

            if (needs_process) {
                self.uses_process = true;
                arguments[arguments.len - 1] = try self.builder.identifier("process");
            }

            var result = try self.call(try self.functionReference(invocation.function), arguments, true);

            if (self.state_active and self.state_plan.represented(self.program, callee_function.output_type)) {
                result = try @import("aggregate.zig").bind(self, &body, result);
                result = try @import("state_value/conversion.zig").convert(self, &body, callee_function.output_type, result, .value);
            }

            break :blk if (body.items.len == 0) result else try @import("aggregate.zig").finish(self, &body, result);
        },
    };
}

fn projectedField(self: *Self, target: ir.ExprId, id: ir.TypeId, name: []const u8) Error!node.ExpressionId {
    const target_type = self.program.expression(target).type_id;
    const represented_target = self.state_active and self.state_plan.represented(self.program, target_type);
    const raw = if (represented_target and self.iteration_value == null and self.loop_fields == null and self.program.typeOf(target_type) == .object) try self.abiProjection(target) else null;
    var value = try self.field(raw orelse try self.projection(target), name);

    if (self.loop_fields) |context| {
        if (context.field(self, target, name)) value = try self.builder.expression(.{ .dereference = value });
    }

    if (!self.state_active or !self.state_plan.represented(self.program, id) or (raw == null and represented_target)) return value;
    if (self.program.typeOf(id) == .list and !@import("state_value/elements.zig").inlineStored(self, id)) return @import("state_value/list.zig").borrowed(self, id, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const bound = try @import("aggregate.zig").bind(self, &body, value);

    return @import("aggregate.zig").finish(self, &body, try @import("state_value/conversion.zig").convert(self, &body, id, bound, .value));
}

fn abiProjection(self: *Self, id: ir.ExprId) Error!?node.ExpressionId {
    const value = self.program.expression(id);
    const flags = self.plan.get(id);

    if (flags.normalize or flags.renew) return null;
    if (!self.state_plan.represented(self.program, value.type_id)) return try self.projection(id);
    if (self.cache.contains(id) or value.value != .field) return null;

    const selected = value.value.field;
    const parent = try self.abiProjection(selected.target) orelse return null;
    const fields = self.program.typeOf(self.program.expression(selected.target).type_id).object;

    return try self.field(parent, fields.at(selected.index).name);
}

fn projection(self: *Self, id: ir.ExprId) Error!node.ExpressionId {
    switch (self.program.expression(id).value) {
        .scope, .iteration, .list_operation => return @import("value_call/root.zig").expression(self, id),
        .call => |value| if (self.value_functions[@backingInt(value.function)]) return @import("value_call/root.zig").expression(self, id),
        else => {},
    }

    return self.expr(id);
}

pub fn functionReference(self: *Self, id: ir.FunctionId) Error!node.ExpressionId {
    return self.requestFunction(id, .regular);
}

pub fn requestFunction(self: *Self, id: ir.FunctionId, variant: @import("functions/requests.zig").Variant) Error!node.ExpressionId {
    if (self.function_modules) |modules| return self.field(try self.builtin(.import, &.{try self.builder.string(modules[@backingInt(id)])}), variant.member());
    try self.function_requests.add(self.allocator, id, variant);

    return self.builder.identifier(try variant.name(self.allocator, id));
}

pub fn binary(self: *Self, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "binary")) Error!node.ExpressionId {
    const left = try self.expr(value.left);
    const right = try self.expr(value.right);
    const type_id = self.program.expression(value.left).type_id;
    const target = self.program.typeOf(type_id);

    if ((value.operator == .equal or value.operator == .not_equal) and target == .optional and (self.program.expression(value.left).value == .none or self.program.expression(value.right).value == .none)) {
        return self.builder.expression(.{ .binary = .{ .operator = if (value.operator == .equal) .equal else .not_equal, .left = if (self.program.expression(value.left).value == .none) try self.builder.expression(.null_value) else left, .right = if (self.program.expression(value.right).value == .none) try self.builder.expression(.null_value) else right } });
    }

    if ((value.operator == .equal or value.operator == .not_equal) and (target == .optional or (target == .scalar and target.scalar == .string))) {
        const equal = try @import("comparison.zig").equal(self, type_id, left, right);

        return if (value.operator == .equal) equal else self.builder.expression(.{ .unary = .{ .operator = .not, .operand = equal } });
    }

    const floating = target == .scalar and (target.scalar == .f32 or target.scalar == .f64);

    if (value.operator == .remainder and target == .scalar and (target.scalar == .i32 or target.scalar == .i64)) {
        const wide = try self.builder.expression(.{ .primitive = if (target.scalar == .i32) .i33 else .i65 });
        const remainder = try self.builtin(.rem, &.{ try self.cast(wide, left), try self.cast(wide, right) });

        return self.cast(try self.typeExpr(type_id), try self.builtin(.intCast, &.{remainder}));
    }

    if (value.operator == .remainder or (value.operator == .divide and !floating)) return self.builtin(if (value.operator == .divide) .divTrunc else .rem, &.{ left, right });

    return self.builder.expression(.{ .binary = .{ .operator = std.meta.stringToEnum(node.BinaryOperator, @tagName(value.operator)).?, .left = left, .right = right } });
}

/// The type expression of `id` in the current representation.
pub fn typeExpr(self: *Self, id: ir.TypeId) Error!node.ExpressionId {
    return @import("types.zig").get(self, self.types, id);
}

/// The layout expression of `id` in the current representation.
pub fn layoutExpr(self: *Self, id: ir.TypeId) Error!node.ExpressionId {
    return @import("types.zig").get(self, self.layouts, id);
}

pub fn field(self: *Self, target: node.ExpressionId, name: []const u8) Error!node.ExpressionId {
    return self.builder.expression(.{ .field = .{ .target = target, .name = name } });
}

pub fn call(self: *Self, callee: node.ExpressionId, arguments: []const node.ExpressionId, fallible: bool) Error!node.ExpressionId {
    const target = self.builder.nodes.get(callee);

    if (target == .field) {
        const owner = self.builder.nodes.get(target.field.target);

        if (owner == .identifier and std.mem.eql(u8, owner.identifier, "allocator")) self.uses_allocator = true;
    }

    for (arguments) |argument_id| {
        const argument = self.builder.nodes.get(argument_id);

        if (argument == .identifier and std.mem.eql(u8, argument.identifier, "allocator")) self.uses_allocator = true;
    }

    const result = try self.builder.expression(.{ .call = .{ .callee = callee, .arguments = try self.allocator.dupe(node.ExpressionId, arguments) } });

    if (!fallible) return result;
    if (self.capture) |boundary| return self.builder.expression(.{ .catch_value = .{ .value = result, .capture = boundary.name, .label = boundary.label, .result = boundary.failure } });

    return self.builder.expression(.{ .try_value = result });
}

pub fn builtin(self: *Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const node.ExpressionId) Error!node.ExpressionId {
    return self.builder.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(node.ExpressionId, arguments) } });
}

pub fn cast(self: *Self, type_expr: node.ExpressionId, value: node.ExpressionId) Error!node.ExpressionId {
    return self.builtin(.as, &.{ type_expr, value });
}

pub fn construct(self: *Self, type_id: ir.TypeId, value: node.ExpressionId) Error!node.ExpressionId {
    if (@import("state_value/root.zig").selected(self, type_id)) {
        const result = try self.cast(try self.layoutExpr(type_id), try @import("state_value/origin.zig").tuple(self, type_id, value));

        if (!self.state_plan.referenced(type_id)) return result;

        var prefix: std.ArrayList(node.Statement) = .empty;
        const pointer = try @import("state_value/reference.zig").store(self, &prefix, type_id, result);

        return @import("aggregate.zig").finish(self, &prefix, pointer);
    }

    var body: std.ArrayList(node.Statement) = .empty;
    const layout = try self.layoutExpr(type_id);
    const pointer = try @import("aggregate.zig").bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "create"), &.{layout}, true));

    try body.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .dereference = pointer }), .value = try self.cast(layout, value) } });

    return @import("aggregate.zig").finish(self, &body, try self.cast(try self.typeExpr(type_id), pointer));
}

pub fn fresh(self: *Self, prefix: []const u8) Error![]const u8 {
    self.serial += 1;

    return std.fmt.allocPrint(self.allocator, "{s}_{d}", .{ prefix, self.serial });
}

pub fn statements(self: *Self, values: ir.Block) Error![]const node.Statement {
    return @import("statements.zig").lower(self, values);
}

pub fn transaction(self: *const Self) bool {
    return self.program.stores.count() > 0 and self.program.store_mode == .transaction;
}

pub fn commit(self: *Self) Error!node.ExpressionId {
    return self.call(try self.field(try self.builder.identifier("context"), "commit"), &.{try self.builder.identifier("pending")}, true);
}
