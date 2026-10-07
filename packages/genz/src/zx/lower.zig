const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const ir = zx.ir;
const Self = @This();
pub const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
builder: Builder,
types: []*const node.Expression,
layouts: []*const node.Expression,
abi_types: []*const node.Expression = &.{},
abi_layouts: []*const node.Expression = &.{},
state_types: []*const node.Expression = &.{},
state_layouts: []*const node.Expression = &.{},
state_plan: @import("state_value/analysis.zig"),
state_active: bool = false,
state_symbols: std.AutoHashMapUnmanaged(ir.SymbolId, void) = .empty,
names: [][]const u8,
native_names: []const []const u8 = &.{},
used: []bool,
cache_reads: []usize,
cache: std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression) = .empty,
append_overrides: std.AutoHashMapUnmanaged(ir.ExprId, @import("object_reduce/append/builder.zig")) = .empty,
list_update_buffers: std.AutoHashMapUnmanaged(ir.ExprId, @import("list_update.zig").Storage) = .empty,
collection_buffers: std.AutoHashMapUnmanaged(ir.ExprId, @import("iteration_buffer/capacity.zig")) = .empty,
buffer_calls: std.AutoHashMapUnmanaged(ir.ExprId, []const ?@import("object_reduce/append/builder.zig")) = .empty,
buffer_functions: []const []const @import("buffer_call/root.zig").Lane = &.{},
buffered_type: ?*const node.Expression = null,
uses_buffers: bool = false,
serial: usize = 0,
capture: ?@import("capture.zig").Boundary = null,
uses_allocator: bool = false,
allows_allocation: bool = false,
uses_io: bool = false,
uses_process: bool = false,
io_functions: []const bool = &.{},
process_functions: []const bool = &.{},
value_functions: []const bool = &.{},
pure_functions: []const bool = &.{},
local_functions: []const bool = &.{},
value_output: bool = false,
stack_symbols: std.AutoHashMapUnmanaged(ir.SymbolId, void) = .empty,
iteration_value: ?*@import("iteration_value/root.zig") = null,
uses_context: bool = false,
uses_parallel: bool = false,
shared_types: bool = false,
pending_name: []const u8 = "zx_pending",
type_names: ?[]const []const u8 = null,
function_modules: ?[]const []const u8 = null,
comparisons: *std.ArrayList(ir.TypeId) = undefined,
task_declarations: *std.ArrayList(node.Declaration) = undefined,
pub fn declarations(self: *Self) Error![]const node.Declaration {
    var output: std.ArrayList(node.Declaration) = .empty;
    var comparisons: std.ArrayList(ir.TypeId) = .empty;
    var task_declarations: std.ArrayList(node.Declaration) = .empty;
    self.comparisons = &comparisons;
    self.task_declarations = &task_declarations;

    try output.append(self.allocator, .{ .constant = .{ .name = "std", .value = try self.builtin(.import, &.{try self.builder.string("std")}) } });
    if (self.function_modules == null) self.native_names = try @import("imports.zig").lower(self, &output);
    try @import("types.zig").lower(self, &output, false);
    for (self.program.exports) |item| try output.append(self.allocator, .{ .constant = .{ .name = item.name, .value = self.types[@backingInt(item.type_id)], .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_io", .value = try self.builder.expression(.{ .boolean = @import("io.zig").uses(self.program.expressions, self.program.contracts, self.io_functions) }), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_process", .value = try self.builder.expression(.{ .boolean = @import("capabilities.zig").uses(self.program.expressions, self.program.contracts, self.process_functions) }), .exported = true } });
    if (self.program.type_only) return output.toOwnedSlice(self.allocator);
    try @import("shape.zig").lower(self, &output);

    for ([_][]const u8{ "Input", "Output" }, [_]ir.TypeId{ self.program.input_type, self.program.output_type }) |contract_name, type_id| {
        var exported = false;

        for (self.program.exports) |item| {
            if (std.mem.eql(u8, item.name, contract_name)) exported = true;
        }

        if (!exported) try output.append(self.allocator, .{ .constant = .{ .name = contract_name, .value = self.types[@backingInt(type_id)], .exported = true } });
    }

    if (self.function_modules == null) for (self.program.functions, 0..) |module_function, index| {
        if (module_function.external != null) {
            try output.append(self.allocator, try @import("external.zig").lower(self, module_function, index));

            continue;
        }

        var helper = self.*;
        helper.program.symbols = module_function.symbols;
        helper.program.expressions = module_function.expressions;
        helper.program.body = module_function.body;
        helper.program.input_type = module_function.input_type;
        helper.program.output_type = module_function.output_type;
        helper.program.stores = module_function.stores;
        helper.program.store_mode = module_function.store_mode;
        helper.pending_name = try std.fmt.allocPrint(self.allocator, "zx_pending_{d}", .{index});
        helper.program.contracts = module_function.contracts;
        helper.names = try self.allocator.alloc([]const u8, module_function.symbols.len);
        helper.used = try self.allocator.alloc(bool, module_function.symbols.len);
        helper.cache = .empty;
        helper.append_overrides = .empty;
        helper.buffer_calls = .empty;
        helper.stack_symbols = .empty;
        helper.cache_reads = try self.allocator.alloc(usize, module_function.expressions.len);

        try @import("store.zig").declaration(&helper, &output);
        try output.append(self.allocator, try helper.function(try std.fmt.allocPrint(self.allocator, "function_{d}", .{index}), false));
        if (self.value_functions[index]) try output.append(self.allocator, try helper.functionValue(try std.fmt.allocPrint(self.allocator, "function_{d}_value", .{index})));
        if (@import("buffer_call/root.zig").available(self.buffer_functions[index])) try output.append(self.allocator, try @import("buffer_call/root.zig").declaration(&helper, try std.fmt.allocPrint(self.allocator, "function_{d}_buffered", .{index}), self.buffer_functions[index]));

        self.uses_parallel = self.uses_parallel or helper.uses_parallel;
    };

    try @import("store.zig").declaration(self, &output);
    try output.append(self.allocator, try self.function("execute", true));
    try output.appendSlice(self.allocator, task_declarations.items);
    if (self.uses_parallel) try output.append(self.allocator, try @import("parallel/allocator.zig").declaration(self));
    for (comparisons.items) |type_id| try output.append(self.allocator, try @import("comparison.zig").ordering(self, type_id));

    return output.toOwnedSlice(self.allocator);
}

pub fn functionValue(self: *Self, name: []const u8) Error!node.Declaration {
    const state = if (self.state_plan.represented(self.program, self.program.output_type)) try @import("state_value/root.zig").enter(self) else null;

    defer if (state) |saved| saved.restore();

    if (self.state_active) try self.state_symbols.put(self.allocator, @fromBackingInt(0), {});

    defer _ = self.state_symbols.remove(@fromBackingInt(0));

    self.value_output = true;
    defer self.value_output = false;

    return self.function(name, false);
}

pub fn function(self: *Self, name: []const u8, exported: bool) Error!node.Declaration {
    self.uses_allocator = false;
    self.uses_context = false;
    self.uses_io = false;
    self.uses_process = false;
    self.uses_buffers = false;

    const errors = try @import("zx").error_effects.program(self.allocator, self.program);

    self.allows_allocation = if (errors) |names| for (names) |error_name| {
        if (std.mem.eql(u8, error_name, "OutOfMemory")) break true;
    } else false else true;

    const needs_io = @import("io.zig").uses(self.program.expressions, self.program.contracts, self.io_functions);
    const needs_process = @import("capabilities.zig").uses(self.program.expressions, self.program.contracts, self.process_functions);

    for (self.names, 0..) |*item, index| item.* = if (index == 0) "in" else try std.fmt.allocPrint(self.allocator, "value_{d}", .{index});

    @memset(self.used, false);
    @memset(self.cache_reads, 0);

    const body_statements = try self.statements(self.program.body);
    const preconditions = try @import("contracts.zig").preconditions(self);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .expression = try self.builtin(.setRuntimeSafety, &.{try self.builder.expression(.{ .boolean = true })}) });

    if (exported and self.uses_allocator) {
        if (try @import("tasks/allocator.zig").required(self.allocator, self.program)) {
            self.uses_io = true;

            try @import("tasks/allocator.zig").initialize(self, &body);
        } else try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) } });
    } else if (!self.uses_allocator) try body.append(self.allocator, .{ .discard = try self.builder.identifier(if (exported) "arena" else "allocator") });

    if (self.program.stores.len > 0 and !self.transaction() and !self.uses_context) try body.append(self.allocator, .{ .discard = try self.builder.identifier("context") });
    if (needs_io and !self.uses_io) try body.append(self.allocator, .{ .discard = try self.builder.identifier("io") });
    if (needs_process and !self.uses_process) try body.append(self.allocator, .{ .discard = try self.builder.identifier("process") });
    if (!self.used[0]) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });
    if (self.buffered_type != null and !self.uses_buffers) try body.append(self.allocator, .{ .discard = try self.builder.identifier("buffers") });

    if (self.transaction()) {
        const fields = try self.allocator.alloc(node.Field, self.program.stores.len);

        for (fields, 0..) |*item, index| item.* = .{ .name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{index}), .value = try self.builder.expression(.null_value) };

        const pending = node.Constant{ .name = "pending", .type_expr = try self.builder.identifier(self.pending_name), .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier(self.pending_name), .fields = fields } }) };

        try body.append(self.allocator, if (@import("statements.zig").writes(self.program.body)) .{ .variable = pending } else .{ .constant = pending });
    }

    try body.appendSlice(self.allocator, preconditions);
    try body.appendSlice(self.allocator, body_statements);
    if (self.transaction() and !ir.terminates(self.program.body)) try body.append(self.allocator, .{ .expression = try self.commit() });

    const injected = self.program.stores.len > 0;
    const parameters = try self.allocator.alloc(node.Field, 2 + @as(usize, @intFromBool(injected)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)) + @as(usize, @intFromBool(self.buffered_type != null)));

    parameters[0] = if (exported) .{ .name = "arena", .value = try self.builder.expression(.{ .pointer = try @import("intrinsics.zig").standardField(self, &.{ "heap", "ArenaAllocator" }) }) } else .{ .name = "allocator", .value = try @import("intrinsics.zig").standardField(self, &.{ "mem", "Allocator" }) };
    parameters[1] = .{ .name = "in", .value = self.types[@backingInt(self.program.input_type)] };

    if (injected) parameters[2] = .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) };
    if (needs_io) parameters[2 + @as(usize, @intFromBool(injected))] = .{ .name = "io", .value = try @import("intrinsics.zig").standardField(self, &.{"Io"}) };
    if (needs_process) parameters[parameters.len - 1] = .{ .name = "process", .value = try @import("intrinsics.zig").standardField(self, &.{ "process", "Init", "Minimal" }) };
    if (self.buffered_type) |buffered_type| parameters[parameters.len - 1] = .{ .name = "buffers", .value = buffered_type };

    return .{ .function = .{ .name = name, .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = .{ .payload = if (self.value_output) self.layouts[@backingInt(self.program.output_type)] else self.types[@backingInt(self.program.output_type)], .errors = errors } }), .body = try body.toOwnedSlice(self.allocator), .exported = exported } };
}

pub fn expr(self: *Self, id: ir.ExprId) Error!*const node.Expression {
    if (self.iteration_value) |context| if (try context.expression(id)) |value| return value;

    return self.regular(id);
}

pub fn regular(self: *Self, id: ir.ExprId) Error!*const node.Expression {
    if (self.cache.get(id)) |cached| {
        self.cache_reads[@backingInt(id)] += 1;

        return cached;
    }

    if (self.append_overrides.get(id)) |override| return override.lower(self, id);

    if (self.buffer_calls.contains(id)) {
        const type_id = self.program.expression(id).type_id;
        const result = try @import("buffer_call/root.zig").invocation(self, id);

        return if (self.program.typeOf(type_id) == .list) result else self.construct(type_id, result);
    }

    const value = self.program.expression(id);
    const value_type = self.types[@backingInt(value.type_id)];

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

            break :blk if (self.transaction()) self.builder.expression(.{ .binary = .{ .operator = .coalesce, .left = try self.field(try self.builder.identifier("pending"), name), .right = current } }) else current;
        },
        .reference => |symbol| blk: {
            self.used[@backingInt(symbol)] = true;

            const reference = try self.builder.identifier(self.names[@backingInt(symbol)]);
            const value_reference = if (self.stack_symbols.contains(symbol)) try self.builder.expression(.{ .address_of = reference }) else reference;

            if (self.state_active and !self.state_symbols.contains(symbol)) {
                var body: std.ArrayList(node.Statement) = .empty;
                const converted = try @import("state_value/conversion.zig").convert(self, &body, value.type_id, value_reference, .value);

                break :blk @import("aggregate.zig").finish(self, &body, converted);
            }

            break :blk value_reference;
        },
        .field => |item| self.field(try self.projection(item.target), self.program.typeOf(self.program.expression(item.target).type_id).object.at(item.index).name),
        .tuple_field => |item| blk: {
            if (try @import("collections.zig").projection(self, item.target, item.index)) |selected| break :blk selected;

            break :blk self.field(try self.projection(item.target), try std.fmt.allocPrint(self.allocator, "{d}", .{item.index}));
        },
        .index => |item| @import("intrinsics.zig").index(self, try self.expr(item.target), try self.expr(item.index)),
        .length => |child| self.cast(value_type, try self.field(try self.expr(child), "len")),
        .unary => |unary| self.builder.expression(.{ .unary = .{ .operator = if (unary.operator == .not) .not else .negate, .operand = try self.expr(unary.operand) } }),
        .binary => |operation| self.binary(operation),
        .match_expr => |selection| @import("match.zig").lower(self, selection),
        .conditional => |conditional| self.builder.expression(.{ .conditional = .{ .condition = try self.expr(conditional.condition), .yes = try self.expr(conditional.yes), .no = try self.expr(conditional.no) } }),
        .object => |object| @import("aggregate.zig").object(self, id, object),
        .list, .tuple, .template => |items| @import("aggregate.zig").sequence(self, value, items),
        .list_operation => |operation| @import("collections.zig").lower(self, value.type_id, operation, self.collection_buffers.get(id)),
        .transform => |transform| @import("transform.zig").lower(self, id, transform),
        .scope => |scope| @import("scope.zig").lower(self, scope),
        .iteration => |iteration| @import("iteration.zig").lower(self, id, iteration),
        .list_update => |update| @import("list_update.zig").lower(self, update, self.list_update_buffers.get(id)),
        .call => |invocation| blk: {
            var body: std.ArrayList(node.Statement) = .empty;
            const callee_function = self.program.functions[@backingInt(invocation.function)];

            if (self.state_active and self.value_functions[@backingInt(invocation.function)] and self.state_plan.represented(self.program, callee_function.output_type)) break :blk @import("value_call/root.zig").invocation(self, invocation, null);
            if (!self.state_active and self.allows_allocation and self.value_functions[@backingInt(invocation.function)] and self.state_plan.represented(self.program, callee_function.output_type)) break :blk @import("value_call/root.zig").pointerInvocation(self, invocation);

            const scalar = switch (self.program.typeOf(callee_function.output_type)) {
                .scalar, .enumeration, .error_set => true,
                else => false,
            };

            const needs_io = self.io_functions[@backingInt(invocation.function)];
            const needs_process = self.process_functions[@backingInt(invocation.function)];
            const arguments = try self.allocator.alloc(*const node.Expression, 2 + @as(usize, @intFromBool(invocation.stores.len > 0)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));
            arguments[0] = try self.builder.identifier("allocator");

            arguments[1] = if (callee_function.external != null and callee_function.external.?.expand_tuple and @import("native_value.zig").isolated(self.program, callee_function) and self.program.expression(invocation.argument).value == .tuple and !self.cache.contains(invocation.argument)) temporary: {
                const argument_value = self.program.expression(invocation.argument);
                const layout = try @import("aggregate.zig").tupleValue(self, argument_value, argument_value.value.tuple);
                const argument = try @import("aggregate.zig").bind(self, &body, try self.cast(self.layouts[@backingInt(argument_value.type_id)], layout));

                break :temporary try self.builder.expression(.{ .address_of = argument });
            } else if (scalar and self.pure_functions[@backingInt(invocation.function)] and self.program.expression(invocation.argument).value == .object and !self.cache.contains(invocation.argument)) temporary: {
                break :temporary try @import("value_call/argument.zig").borrow(self, &body, invocation.argument);
            } else if (self.state_active) converted: {
                const argument = try @import("aggregate.zig").bind(self, &body, try self.expr(invocation.argument));
                const borrow = self.pure_functions[@backingInt(invocation.function)] and !self.state_plan.represented(self.program, callee_function.output_type);

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

fn projection(self: *Self, id: ir.ExprId) Error!*const node.Expression {
    switch (self.program.expression(id).value) {
        .iteration, .list_operation => return @import("value_call/root.zig").expression(self, id),
        .call => |value| if (self.value_functions[@backingInt(value.function)]) return @import("value_call/root.zig").expression(self, id),
        else => {},
    }

    return self.expr(id);
}

pub fn functionReference(self: *Self, id: ir.FunctionId) Error!*const node.Expression {
    if (self.function_modules) |modules| return self.field(try self.builtin(.import, &.{try self.builder.string(modules[@backingInt(id)])}), "call");

    return self.builder.identifier(try std.fmt.allocPrint(self.allocator, "function_{d}", .{@backingInt(id)}));
}

pub fn binary(self: *Self, value: @FieldType(@FieldType(ir.Expression, "value"), "binary")) Error!*const node.Expression {
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

        return self.cast(self.types[@backingInt(type_id)], try self.builtin(.intCast, &.{remainder}));
    }

    if (value.operator == .remainder or (value.operator == .divide and !floating)) return self.builtin(if (value.operator == .divide) .divTrunc else .rem, &.{ left, right });

    return self.builder.expression(.{ .binary = .{ .operator = std.meta.stringToEnum(node.BinaryOperator, @tagName(value.operator)).?, .left = left, .right = right } });
}

pub fn field(self: *Self, target: *const node.Expression, name: []const u8) Error!*const node.Expression {
    return self.builder.expression(.{ .field = .{ .target = target, .name = name } });
}

pub fn call(self: *Self, callee: *const node.Expression, arguments: []const *const node.Expression, fallible: bool) Error!*const node.Expression {
    if (callee.* == .field and callee.field.target.* == .identifier and std.mem.eql(u8, callee.field.target.identifier, "allocator")) self.uses_allocator = true;

    for (arguments) |argument| {
        if (argument.* == .identifier and std.mem.eql(u8, argument.identifier, "allocator")) self.uses_allocator = true;
    }

    const result = try self.builder.expression(.{ .call = .{ .callee = callee, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });

    if (!fallible) return result;
    if (self.capture) |boundary| return self.builder.expression(.{ .catch_value = .{ .value = result, .capture = boundary.name, .label = boundary.label, .result = boundary.failure } });

    return self.builder.expression(.{ .try_value = result });
}

pub fn builtin(self: *Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const *const node.Expression) Error!*const node.Expression {
    return self.builder.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });
}

pub fn cast(self: *Self, type_expr: *const node.Expression, value: *const node.Expression) Error!*const node.Expression {
    return self.builtin(.as, &.{ type_expr, value });
}

pub fn construct(self: *Self, type_id: ir.TypeId, value: *const node.Expression) Error!*const node.Expression {
    if (@import("state_value/root.zig").selected(self, type_id)) return self.cast(self.types[@backingInt(type_id)], try @import("state_value/origin.zig").tuple(self, type_id, value));

    var body: std.ArrayList(node.Statement) = .empty;
    const layout = self.layouts[@backingInt(type_id)];
    const pointer = try @import("aggregate.zig").bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "create"), &.{layout}, true));

    try body.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .dereference = pointer }), .value = try self.cast(layout, value) } });

    return @import("aggregate.zig").finish(self, &body, try self.cast(self.types[@backingInt(type_id)], pointer));
}

pub fn fresh(self: *Self, prefix: []const u8) Error![]const u8 {
    self.serial += 1;

    return std.fmt.allocPrint(self.allocator, "{s}_{d}", .{ prefix, self.serial });
}

pub fn statements(self: *Self, values: []const ir.Statement) Error![]const node.Statement {
    return @import("statements.zig").lower(self, values);
}

pub fn transaction(self: *const Self) bool {
    return self.program.stores.len > 0 and self.program.store_mode == .transaction;
}

pub fn commit(self: *Self) Error!*const node.Expression {
    return self.call(try self.field(try self.builder.identifier("context"), "commit"), &.{try self.builder.identifier("pending")}, true);
}
