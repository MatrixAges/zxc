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
state_symbols: @import("members.zig") = .empty,
names: [][]const u8,
native_names: []const []const u8 = &.{},
used: []bool,
cache_reads: []usize,
cache: @import("expression_map.zig").Map(ir.ExprId) = .empty,
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
error_cache: ?@import("error_effects.zig").Cache = null,
pure_functions: []const bool = &.{},
/// The pure functions that compare no represented aggregates by identity, themselves or through their callees.
identity_free_functions: []const bool = &.{},
local_functions: []const bool = &.{},
fresh_outputs: []const bool = &.{},
constructed_outputs: []const bool = &.{},
value_output: bool = false,
public_value_output: bool = false,
stack_symbols: @import("members.zig") = .empty,
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
task_declarations: *@import("auxiliary.zig") = undefined,
pub fn refreshEntry(self: *Self) Error!void {
    self.error_cache = null;
    self.entry_flags = try @import("entry_flags.zig").analyze(self.workspace, self.program, .{ .local = self.local_functions, .pure = self.pure_functions, .io = self.io_functions, .process = self.process_functions, .tasks = self.task_functions, .self_function = self.self_function });
}

pub fn declarations(self: *Self) Error!@import("../node/stored.zig").Declarations {
    var output: std.ArrayList(node.Declaration) = .empty;
    var comparisons: std.ArrayList(ir.TypeId) = .empty;
    var task_declarations = @import("auxiliary.zig").init();

    self.comparisons = &comparisons;
    self.task_declarations = &task_declarations;

    var function_requests = try @import("functions/requests.zig").init(self.allocator, self.program.functions.count());

    self.function_requests = &function_requests;

    try @import("module/emitting.zig").standard(self, &output);
    if (self.function_modules == null) self.native_names = try @import("imports.zig").lower(self, &output);
    try @import("types.zig").lower(self, &output, false);
    try @import("module/emitting.zig").exports(self, &output);
    if (self.program.type_only) return self.builder.nodes.declarations(self.allocator, output.items);
    try @import("shape.zig").lower(self, &output);
    try @import("module/emitting.zig").contracts(self, &output);
    try @import("store.zig").declaration(self, &output);
    try @import("entry.zig").declarations(self, &output);
    try @import("entry_values.zig").declarations(self, &output);

    var function_index: usize = 0;

    while (function_index < function_requests.count()) : (function_index += 1) {
        try @import("functions/emit.zig").append(self, &output, function_requests.at(function_index));
    }

    var suffix: std.ArrayList(node.Declaration) = .empty;

    if (self.uses_parallel) try suffix.append(self.allocator, try @import("parallel/allocator.zig").declaration(self));
    for (comparisons.items) |type_id| try suffix.append(self.allocator, try @import("comparison.zig").ordering(self, type_id));

    return task_declarations.assemble(self.allocator, self.builder.nodes, output.items, suffix.items);
}

pub fn functionValue(self: *Self, name: []const u8) Error!node.Declaration {
    return self.valueMode(name, false);
}

pub fn valuePrototype(self: *Self, name: []const u8) Error!node.Function {
    return (try self.valueMode(name, true)).function;
}

fn valueMode(self: *Self, name: []const u8, prototype_only: bool) Error!node.Declaration {
    const state = if (self.state_plan.represented(self.program, self.program.output_type) or self.state_plan.represented(self.program, self.program.input_type) or self.state_plan.inlineRows(self.program, self.program.input_type)) try @import("state_value/root.zig").enter(self) else null;

    defer if (state) |saved| saved.restore();

    if (self.state_active and !self.public_value_output) try self.state_symbols.put(self.allocator, @fromBackingInt(0), {});

    defer _ = self.state_symbols.remove(@fromBackingInt(0));
    const output = self.program.typeOf(self.program.output_type);
    var payload = output;

    while (payload == .optional) payload = self.program.typeOf(payload.optional);

    self.value_output = payload != .native_reference and (state == null or self.state_plan.represented(self.program, self.program.output_type) or (output != .object and output != .tuple));
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

    const errors = try @import("error_effects.zig").program(self);

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
    const has_stores = self.program.stores.count() != 0;
    const store_transaction = @import("store/transaction.zig");

    try @import("functions/prelude/build.zig").append(self, &body, .{ .exported = exported, .io = needs_io, .process = needs_process });
    if (has_stores) try store_transaction.initialize(self, &body);
    try body.appendSlice(self.allocator, self.reference_storage.items);
    try body.appendSlice(self.allocator, preconditions);
    try body.appendSlice(self.allocator, body_statements);
    if (has_stores) try store_transaction.finish(self, &body);

    var declaration = try self.prototypeWithErrors(name, exported, errors);

    declaration.body = try self.builder.statements(body.items);

    return .{ .function = declaration };
}

pub fn prototype(self: *Self, name: []const u8, exported: bool) Error!node.Function {
    const errors = try @import("error_effects.zig").program(self);

    return self.prototypeWithErrors(name, exported, errors);
}

fn prototypeWithErrors(self: *Self, name: []const u8, exported: bool, errors: ?[]const []const u8) Error!node.Function {
    return @import("signature/build.zig").build(self, name, exported, errors);
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
        .integer, .negative_integer, .float, .boolean, .string, .unit, .none, .enum_value, .error_value => @import("literals.zig").lower(self, id, value_type),
        .some => |child| self.cast(value_type, try self.expr(child)),
        .store_get => |slot| @import("access/store.zig").lower(self, slot, value.type_id),
        .reference => |symbol| @import("access/reference.zig").lower(self, symbol, value.type_id),
        .field => |item| self.projectedField(item.target, value.type_id, self.program.typeOf(self.program.expression(item.target).type_id).object.at(item.index).name),
        .tuple_field => |item| blk: {
            if (try @import("collections.zig").projection(self, item.target, item.index)) |selected| break :blk selected;

            break :blk self.projectedField(item.target, value.type_id, try std.fmt.allocPrint(self.allocator, "{d}", .{item.index}));
        },
        .index => |item| blk: {
            const raw = try self.abiNestedItems(item.target);
            const source = raw orelse try @import("state_value/list.zig").expression(self, item.target);
            const indexed = try @import("intrinsics.zig").index(self, source, try self.expr(item.index));
            const route = @import("access/projection/rules.zig").result(self, value.type_id, self.program.expression(item.target).type_id, raw != null, false);

            if (route == .Direct) break :blk indexed;

            var body: std.ArrayList(node.Statement) = .empty;

            const converted = if (route == .Value)
                try @import("state_value/conversion.zig").convert(self, &body, value.type_id, try @import("aggregate.zig").bind(self, &body, indexed), .value)
            else
                try @import("state_value/elements.zig").read(self, &body, self.program.expression(item.target).type_id, indexed);

            break :blk @import("aggregate.zig").finish(self, &body, converted);
        },
        .length => |child| blk: {
            const raw = try self.abiNestedItems(child);
            const source = raw orelse try @import("state_value/list.zig").expression(self, child);

            break :blk @import("access/emit.zig").length(self, source, value_type);
        },
        .unary => |unary| @import("operators/unary.zig").lower(self, unary),
        .binary => |operation| self.binary(operation),
        .match_expr => |selection| @import("match.zig").lower(self, selection),
        .conditional => |conditional| @import("selection/conditional.zig").lower(self, conditional),
        .object => |object| @import("aggregate.zig").object(self, id, object),
        .list, .tuple, .template => |items| @import("aggregate.zig").sequence(self, value, items),
        .list_operation => @import("collections.zig").lower(self, id),
        .transform => |transform| @import("transform.zig").lower(self, id, transform),
        .scope => |scope| @import("scope.zig").lower(self, scope),
        .iteration => |iteration| @import("iteration.zig").lower(self, id, iteration),
        .list_update => @import("list_update.zig").lower(self, id),
        .call => |invocation| @import("regular_call/root.zig").lower(self, invocation),
    };
}

fn projectedField(self: *Self, target: ir.ExprId, id: ir.TypeId, name: []const u8) Error!node.ExpressionId {
    const target_type = self.program.expression(target).type_id;
    const eligible = @import("access/projection/rules.zig").raw(self, target_type, false);
    const raw = if (eligible) try self.abiProjection(target) else null;
    var value = try self.field(raw orelse try self.projection(target), name);

    if (self.loop_fields) |context| {
        if (context.field(self, target, name)) value = try @import("access/emit.zig").dereference(self, value);
    }

    const route = @import("access/projection/rules.zig").result(self, id, target_type, raw != null, true);

    if (route == .Direct) return value;
    if (route == .Borrowed) return @import("state_value/list.zig").borrowed(self, id, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const bound = try @import("aggregate.zig").bind(self, &body, value);

    return @import("aggregate.zig").finish(self, &body, try @import("state_value/conversion.zig").convert(self, &body, id, bound, .value));
}

fn abiNestedItems(self: *Self, id: ir.ExprId) Error!?node.ExpressionId {
    const type_id = self.program.expression(id).type_id;
    const eligible = @import("access/projection/rules.zig").raw(self, type_id, true);

    if (!eligible) return null;

    return self.abiProjection(id);
}

fn abiProjection(self: *Self, id: ir.ExprId) Error!?node.ExpressionId {
    const value = self.program.expression(id);
    const plan = @import("access/projection/rules.zig").route(self, id);

    return switch (plan.route) {
        .None => null,
        .Anchor => try self.projection(id),
        .Field => field: {
            const selected = value.value.field;
            const parent = try self.abiProjection(selected.target) orelse return null;
            const fields = self.program.typeOf(self.program.expression(selected.target).type_id).object;

            break :field try self.field(parent, fields.at(selected.index).name);
        },
        .Index => index: {
            const selected = value.value.index;
            const raw = try self.abiProjection(selected.target);
            const parent = raw orelse if (plan.managed_parent) try @import("state_value/list.zig").expression(self, selected.target) else return null;

            break :index try @import("intrinsics.zig").index(self, parent, try self.expr(selected.index));
        },
    };
}

fn projection(self: *Self, id: ir.ExprId) Error!node.ExpressionId {
    const use_value = @import("access/projection/rules.zig").value(self, id);

    if (use_value) return @import("value_call/root.zig").expression(self, id);

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
    if (!@import("genz_options").generated_analysis) return @import("operators/seed.zig").binary(self, value);

    return @import("operators/binary.zig").lower(self, value);
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
    return @import("access/emit.zig").field(self, target, name);
}

pub fn call(self: *Self, callee: node.ExpressionId, arguments: []const node.ExpressionId, fallible: bool) Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("invocation/seed.zig").call(self, callee, arguments, fallible);

    return @import("invocation/call.zig").lower(self, callee, arguments, fallible);
}

pub fn builtin(self: *Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const node.ExpressionId) Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("invocation/seed.zig").builtin(self, name, arguments);

    return @import("invocation/builtin.zig").lower(self, name, arguments);
}

pub fn cast(self: *Self, type_expr: node.ExpressionId, value: node.ExpressionId) Error!node.ExpressionId {
    return self.builtin(.as, &.{ type_expr, value });
}

pub fn construct(self: *Self, type_id: ir.TypeId, value: node.ExpressionId) Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("construction_seed.zig").construct(self, type_id, value);

    return @import("construction/build.zig").lower(self, type_id, value);
}

pub fn fresh(self: *Self, prefix: []const u8) Error![]const u8 {
    self.serial += 1;

    return std.fmt.allocPrint(self.allocator, "{s}_{d}", .{ prefix, self.serial });
}

pub fn statements(self: *Self, values: ir.Block) Error![]const node.Statement {
    return @import("statements.zig").lower(self, values);
}

pub fn transaction(self: *const Self) bool {
    return @import("store/transaction.zig").active(self);
}
