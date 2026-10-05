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
names: [][]const u8,
native_names: []const []const u8 = &.{},
used: []bool,
cache_reads: []usize,
cache: std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression) = .empty,
append_overrides: std.AutoHashMapUnmanaged(ir.ExprId, @import("object_reduce/append/builder.zig")) = .empty,
serial: usize = 0,
uses_allocator: bool = false,
uses_io: bool = false,
uses_process: bool = false,
io_functions: []const bool = &.{},
process_functions: []const bool = &.{},
uses_context: bool = false,
uses_parallel: bool = false,
shared_types: bool = false,
pending_name: []const u8 = "zx_pending",
type_names: ?[]const []const u8 = null,
function_modules: ?[]const []const u8 = null,
comparisons: *std.ArrayList(ir.TypeId) = undefined,
pub fn declarations(self: *Self) Error![]const node.Declaration {
    var output: std.ArrayList(node.Declaration) = .empty;
    var comparisons: std.ArrayList(ir.TypeId) = .empty;

    self.comparisons = &comparisons;

    try output.append(self.allocator, .{ .constant = .{ .name = "std", .value = try self.builtin(.import, &.{try self.builder.string("std")}) } });
    if (self.function_modules == null) self.native_names = try @import("imports.zig").lower(self, &output);
    try @import("types.zig").lower(self, &output, false);
    for (self.program.exports) |item| try output.append(self.allocator, .{ .constant = .{ .name = item.name, .value = self.types[@intFromEnum(item.type_id)], .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "consumes_input", .value = try self.builder.expression(.{ .boolean = self.program.consumes_input }), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_io", .value = try self.builder.expression(.{ .boolean = @import("io.zig").uses(self.program.expressions, self.program.contracts, self.io_functions) }), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_process", .value = try self.builder.expression(.{ .boolean = @import("io.zig").uses(self.program.expressions, self.program.contracts, self.process_functions) }), .exported = true } });
    if (self.program.type_only) return output.toOwnedSlice(self.allocator);

    for ([_][]const u8{ "Input", "Output" }, [_]ir.TypeId{ self.program.input_type, self.program.output_type }) |contract_name, type_id| {
        var exported = false;

        for (self.program.exports) |item| {
            if (std.mem.eql(u8, item.name, contract_name)) exported = true;
        }

        if (!exported) try output.append(self.allocator, .{ .constant = .{ .name = contract_name, .value = self.types[@intFromEnum(type_id)], .exported = true } });
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
        helper.program.consumes_input = module_function.consumes_input;
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
        helper.cache_reads = try self.allocator.alloc(usize, module_function.expressions.len);

        try @import("store.zig").declaration(&helper, &output);
        try output.append(self.allocator, try helper.function(try std.fmt.allocPrint(self.allocator, "function_{d}", .{index}), false));

        self.uses_parallel = self.uses_parallel or helper.uses_parallel;
    };

    try @import("store.zig").declaration(self, &output);
    try output.append(self.allocator, try self.function("execute", true));
    if (self.uses_parallel) try output.append(self.allocator, .{ .source = @import("parallel/allocator.zig").source });
    for (comparisons.items) |type_id| try output.append(self.allocator, try @import("comparison.zig").ordering(self, type_id));

    return output.toOwnedSlice(self.allocator);
}

pub fn function(self: *Self, name: []const u8, exported: bool) Error!node.Declaration {
    self.uses_allocator = false;
    self.uses_context = false;
    self.uses_io = false;
    self.uses_process = false;

    const needs_io = @import("io.zig").uses(self.program.expressions, self.program.contracts, self.io_functions);
    const needs_process = @import("io.zig").uses(self.program.expressions, self.program.contracts, self.process_functions);

    for (self.names, 0..) |*item, index| item.* = if (index == 0) "in" else try std.fmt.allocPrint(self.allocator, "value_{d}", .{index});

    @memset(self.used, false);
    @memset(self.cache_reads, 0);

    const body_statements = try self.statements(self.program.body);
    const preconditions = try @import("contracts.zig").preconditions(self);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .expression = try self.builtin(.setRuntimeSafety, &.{try self.builder.expression(.{ .boolean = true })}) });

    if (exported and self.uses_allocator) {
        try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) } });
    } else if (!self.uses_allocator) try body.append(self.allocator, .{ .discard = try self.builder.identifier(if (exported) "arena" else "allocator") });

    if (self.program.stores.len > 0 and !self.transaction() and !self.uses_context) try body.append(self.allocator, .{ .discard = try self.builder.identifier("context") });
    if (needs_io and !self.uses_io) try body.append(self.allocator, .{ .discard = try self.builder.identifier("io") });
    if (needs_process and !self.uses_process) try body.append(self.allocator, .{ .discard = try self.builder.identifier("process") });
    if (!self.used[0]) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });

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
    const parameters = try self.allocator.alloc(node.Field, 2 + @as(usize, @intFromBool(injected)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));

    parameters[0] = if (exported) .{ .name = "arena", .value = try self.builder.expression(.{ .pointer = try @import("intrinsics.zig").standardField(self, &.{ "heap", "ArenaAllocator" }) }) } else .{ .name = "allocator", .value = try @import("intrinsics.zig").standardField(self, &.{ "mem", "Allocator" }) };
    parameters[1] = .{ .name = "in", .value = self.types[@intFromEnum(self.program.input_type)] };

    if (injected) parameters[2] = .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) };
    if (needs_io) parameters[2 + @as(usize, @intFromBool(injected))] = .{ .name = "io", .value = try @import("intrinsics.zig").standardField(self, &.{"Io"}) };
    if (needs_process) parameters[parameters.len - 1] = .{ .name = "process", .value = try @import("intrinsics.zig").standardField(self, &.{ "process", "Init", "Minimal" }) };

    return .{ .function = .{ .name = name, .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = self.types[@intFromEnum(self.program.output_type)] }), .body = try body.toOwnedSlice(self.allocator), .exported = exported } };
}

pub fn expr(self: *Self, id: ir.ExprId) Error!*const node.Expression {
    if (self.cache.get(id)) |cached| {
        self.cache_reads[@intFromEnum(id)] += 1;

        return cached;
    }

    if (self.append_overrides.get(id)) |override| return override.lower(self, id);

    const value = self.program.expression(id);
    const value_type = self.types[@intFromEnum(value.type_id)];

    return switch (value.value) {
        .integer => |integer| self.cast(value_type, try self.builder.integer(integer)),
        .negative_integer => |integer| self.cast(value_type, try self.builder.expression(.{ .unary = .{ .operator = .negate, .operand = try self.builder.integer(integer) } })),
        .float => |float| self.cast(value_type, try self.builder.expression(.{ .float = float })),
        .boolean => |boolean| self.builder.expression(.{ .boolean = boolean }),
        .string => |text| self.cast(value_type, try self.builder.string(text)),
        .unit => self.builder.expression(.unit),
        .none => self.cast(value_type, try self.builder.expression(.null_value)),
        .some => |child| self.cast(value_type, try self.expr(child)),
        .enum_value => |member| self.cast(value_type, try self.builder.expression(.{ .enum_literal = self.program.typeOf(value.type_id).enumeration.members[member] })),
        .store_get => |slot| blk: {
            self.uses_context = true;

            const name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{slot});
            const current = try self.builder.expression(.{ .dereference = try self.field(try self.builder.identifier("context"), name) });

            break :blk if (self.transaction()) self.builder.expression(.{ .binary = .{ .operator = .coalesce, .left = try self.field(try self.builder.identifier("pending"), name), .right = current } }) else current;
        },
        .reference => |symbol| blk: {
            self.used[@intFromEnum(symbol)] = true;

            break :blk self.builder.identifier(self.names[@intFromEnum(symbol)]);
        },
        .field => |item| self.field(try self.expr(item.target), self.program.typeOf(self.program.expression(item.target).type_id).object[item.index].name),
        .tuple_field => |item| self.field(try self.expr(item.target), try std.fmt.allocPrint(self.allocator, "{d}", .{item.index})),
        .index => |item| @import("intrinsics.zig").index(self, try self.expr(item.target), try self.expr(item.index)),
        .length => |child| self.cast(value_type, try self.field(try self.expr(child), "len")),
        .unary => |unary| self.builder.expression(.{ .unary = .{ .operator = if (unary.operator == .not) .not else .negate, .operand = try self.expr(unary.operand) } }),
        .binary => |operation| self.binary(operation),
        .match_expr => |selection| @import("match.zig").lower(self, selection),
        .conditional => |conditional| self.builder.expression(.{ .conditional = .{ .condition = try self.expr(conditional.condition), .yes = try self.expr(conditional.yes), .no = try self.expr(conditional.no) } }),
        .object => |object| @import("aggregate.zig").object(self, id, object),
        .list, .tuple, .template => |items| @import("aggregate.zig").sequence(self, value, items),
        .list_operation => |operation| @import("collections.zig").lower(self, value.type_id, operation),
        .transform => |transform| @import("transform.zig").lower(self, id, transform),
        .call => |invocation| blk: {
            const needs_io = self.io_functions[@intFromEnum(invocation.function)];
            const needs_process = self.process_functions[@intFromEnum(invocation.function)];
            const arguments = try self.allocator.alloc(*const node.Expression, 2 + @as(usize, @intFromBool(invocation.stores.len > 0)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));

            arguments[0] = try self.builder.identifier("allocator");
            arguments[1] = try self.expr(invocation.argument);

            if (invocation.stores.len > 0) arguments[2] = try @import("store.zig").adapter(self, invocation);

            if (needs_io) {
                self.uses_io = true;

                arguments[2 + @as(usize, @intFromBool(invocation.stores.len > 0))] = try self.builder.identifier("io");
            }

            if (needs_process) {
                self.uses_process = true;
                arguments[arguments.len - 1] = try self.builder.identifier("process");
            }

            break :blk self.call(try self.functionReference(invocation.function), arguments, true);
        },
    };
}

pub fn functionReference(self: *Self, id: ir.FunctionId) Error!*const node.Expression {
    if (self.function_modules) |modules| return self.field(try self.builtin(.import, &.{try self.builder.string(modules[@intFromEnum(id)])}), "call");

    return self.builder.identifier(try std.fmt.allocPrint(self.allocator, "function_{d}", .{@intFromEnum(id)}));
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

        return self.cast(self.types[@intFromEnum(type_id)], try self.builtin(.intCast, &.{remainder}));
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

    return if (fallible) self.builder.expression(.{ .try_value = result }) else result;
}

pub fn builtin(self: *Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const *const node.Expression) Error!*const node.Expression {
    return self.builder.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });
}

pub fn cast(self: *Self, type_expr: *const node.Expression, value: *const node.Expression) Error!*const node.Expression {
    return self.builtin(.as, &.{ type_expr, value });
}

pub fn construct(self: *Self, type_id: ir.TypeId, value: *const node.Expression) Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const layout = self.layouts[@intFromEnum(type_id)];
    const pointer = try @import("aggregate.zig").bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "create"), &.{layout}, true));

    try body.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .dereference = pointer }), .value = try self.cast(layout, value) } });

    return @import("aggregate.zig").finish(self, &body, try self.cast(self.types[@intFromEnum(type_id)], pointer));
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
