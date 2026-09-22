const std = @import("std");
const zx = @import("zx");
const genz = @import("genz");
const node = genz.node;
const ir = zx.ir;
const Self = @This();
pub const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
builder: genz.Builder,
types: []*const node.Expression,
names: [][]const u8,
used: []bool,
cache_reads: []usize,
cache: std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression) = .empty,
serial: usize = 0,
uses_allocator: bool = false,
pub fn declarations(self: *Self) Error![]const node.Declaration {
    var output: std.ArrayList(node.Declaration) = .empty;

    try output.append(self.allocator, .{ .constant = .{ .name = "std", .value = try self.builtin(.import, &.{try self.builder.string("std")}) } });
    try output.append(self.allocator, .{ .constant = .{ .name = "runtime", .value = try self.builtin(.import, &.{try self.builder.string("zx_runtime")}) } });

    for (self.program.types, 0..) |value, index| {
        self.types[index] = switch (value) {
            .scalar => |scalar| switch (scalar) {
                .string => try self.builder.expression(.{ .const_slice = try self.builder.expression(.{ .primitive = .u8 }) }),
                else => try self.builder.expression(.{ .primitive = std.meta.stringToEnum(@FieldType(node.Expression, "primitive"), @tagName(scalar)).? }),
            },
            .optional => |child| try self.builder.expression(.{ .optional_type = self.types[@intFromEnum(child)] }),
            .list => |child| try self.builder.expression(.{ .const_slice = self.types[@intFromEnum(child)] }),
            .object, .tuple, .enumeration => blk: {
                const name = try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{index});

                const definition = switch (value) {
                    .enumeration => |enumeration| try self.builder.expression(.{ .enum_type = enumeration.members }),
                    .tuple => |children| tuple: {
                        const items = try self.allocator.alloc(*const node.Expression, children.len);

                        for (children, 0..) |child, child_index| items[child_index] = self.types[@intFromEnum(child)];

                        break :tuple try self.builder.expression(.{ .tuple_type = items });
                    },
                    .object => |fields| object: {
                        const items = try self.allocator.alloc(node.Field, fields.len);

                        for (fields, 0..) |item, field_index| items[field_index] = .{ .name = item.name, .value = self.types[@intFromEnum(item.type_id)] };

                        break :object try self.builder.expression(.{ .struct_type = items });
                    },
                    else => unreachable,
                };

                try output.append(self.allocator, .{ .constant = .{ .name = name, .value = definition } });

                break :blk try self.builder.identifier(name);
            },
        };
    }

    for (self.program.exports) |item| try output.append(self.allocator, .{ .constant = .{ .name = item.name, .value = self.types[@intFromEnum(item.type_id)], .exported = true } });
    if (self.program.type_only) return output.toOwnedSlice(self.allocator);

    for ([_][]const u8{ "Input", "Output" }, [_]ir.TypeId{ self.program.input_type, self.program.output_type }) |contract_name, type_id| {
        var exported = false;

        for (self.program.exports) |item| {
            if (std.mem.eql(u8, item.name, contract_name)) exported = true;
        }

        if (!exported) try output.append(self.allocator, .{ .constant = .{ .name = contract_name, .value = self.types[@intFromEnum(type_id)], .exported = true } });
    }

    for (self.program.functions, 0..) |module_function, index| {
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
        helper.program.stores = &.{};
        helper.names = try self.allocator.alloc([]const u8, module_function.symbols.len);
        helper.used = try self.allocator.alloc(bool, module_function.symbols.len);
        helper.cache = .empty;
        helper.cache_reads = try self.allocator.alloc(usize, module_function.expressions.len);

        try output.append(self.allocator, try helper.function(try std.fmt.allocPrint(self.allocator, "function_{d}", .{index}), false));
    }

    if (self.program.stores.len > 0) {
        const fields = try self.allocator.alloc(node.Field, self.program.stores.len);

        for (self.program.stores, 0..) |slot, index| fields[index] = .{ .name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{index}), .value = try self.builder.expression(.{ .optional_type = self.types[@intFromEnum(slot.type_id)] }) };
        try output.append(self.allocator, .{ .constant = .{ .name = "zx_pending", .value = try self.builder.expression(.{ .struct_type = fields }), .exported = true } });
    }

    try output.append(self.allocator, try self.function("execute", true));

    return output.toOwnedSlice(self.allocator);
}

fn function(self: *Self, name: []const u8, exported: bool) Error!node.Declaration {
    self.uses_allocator = false;

    for (self.names, 0..) |*item, index| item.* = if (index == 0) "in" else try std.fmt.allocPrint(self.allocator, "value_{d}", .{index});

    @memset(self.used, false);
    @memset(self.cache_reads, 0);

    const body_statements = try self.statements(self.program.body);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .expression = try self.builtin(.setRuntimeSafety, &.{try self.builder.expression(.{ .boolean = true })}) });

    if (exported and self.uses_allocator) {
        try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) } });
    } else if (!self.uses_allocator) try body.append(self.allocator, .{ .discard = try self.builder.identifier(if (exported) "arena" else "allocator") });

    if (!self.used[0]) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });

    if (self.program.stores.len > 0) {
        const fields = try self.allocator.alloc(node.Field, self.program.stores.len);

        for (fields, 0..) |*item, index| item.* = .{ .name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{index}), .value = try self.builder.expression(.null_value) };

        const pending = node.Constant{ .name = "pending", .type_expr = try self.builder.identifier("zx_pending"), .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier("zx_pending"), .fields = fields } }) };

        try body.append(self.allocator, if (@import("statements.zig").writes(self.program.body)) .{ .variable = pending } else .{ .constant = pending });
    }

    try body.appendSlice(self.allocator, body_statements);
    if (self.program.stores.len > 0 and !ir.terminates(self.program.body)) try body.append(self.allocator, .{ .expression = try self.commit() });

    const parameters = try self.allocator.alloc(node.Field, if (self.program.stores.len > 0) 3 else 2);

    parameters[0] = if (exported) .{ .name = "arena", .value = try self.builder.expression(.{ .pointer = try self.field(try self.builder.identifier("runtime"), "Arena") }) } else .{ .name = "allocator", .value = try self.field(try self.builder.identifier("runtime"), "Allocator") };
    parameters[1] = .{ .name = "in", .value = self.types[@intFromEnum(self.program.input_type)] };

    if (self.program.stores.len > 0) parameters[2] = .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) };

    return .{ .function = .{ .name = name, .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = self.types[@intFromEnum(self.program.output_type)] }), .body = try body.toOwnedSlice(self.allocator), .exported = exported } };
}

pub fn expr(self: *Self, id: ir.ExprId) Error!*const node.Expression {
    if (self.cache.get(id)) |cached| {
        self.cache_reads[@intFromEnum(id)] += 1;

        return cached;
    }

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
            const name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{slot});

            break :blk self.builder.expression(.{ .binary = .{ .operator = .coalesce, .left = try self.field(try self.builder.identifier("pending"), name), .right = try self.builder.expression(.{ .dereference = try self.field(try self.builder.identifier("context"), name) }) } });
        },
        .reference => |symbol| blk: {
            self.used[@intFromEnum(symbol)] = true;

            break :blk self.builder.identifier(self.names[@intFromEnum(symbol)]);
        },
        .field => |item| self.field(try self.expr(item.target), self.program.typeOf(self.program.expression(item.target).type_id).object[item.index].name),
        .tuple_field => |item| self.field(try self.expr(item.target), try std.fmt.allocPrint(self.allocator, "{d}", .{item.index})),
        .index => |item| self.runtimeCall("at", &.{ value_type, try self.expr(item.target), try self.expr(item.index) }, true),
        .length => |child| self.cast(value_type, try self.field(try self.expr(child), "len")),
        .clone => |child| self.runtimeCall("clone", &.{ value_type, try self.builder.identifier("allocator"), try self.expr(child) }, true),
        .unary => |unary| self.builder.expression(.{ .unary = .{ .operator = if (unary.operator == .not) .not else .negate, .operand = try self.expr(unary.operand) } }),
        .binary => |operation| self.binary(operation),
        .conditional => |conditional| self.builder.expression(.{ .conditional = .{ .condition = try self.expr(conditional.condition), .yes = try self.expr(conditional.yes), .no = try self.expr(conditional.no) } }),
        .object => |object| @import("aggregate.zig").object(self, id, object),
        .list, .tuple, .template => |items| @import("aggregate.zig").sequence(self, value, items),
        .list_operation => |operation| @import("aggregate.zig").operation(self, value.type_id, operation),
        .transform => |transform| @import("transform.zig").lower(self, id, transform),
        .call => |invocation| self.call(try self.builder.identifier(try std.fmt.allocPrint(self.allocator, "function_{d}", .{@intFromEnum(invocation.function)})), &.{ try self.builder.identifier("allocator"), try self.expr(invocation.argument) }, true),
    };
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
        const equal = try self.runtimeCall("equal", &.{ self.types[@intFromEnum(type_id)], left, right }, false);

        return if (value.operator == .equal) equal else self.builder.expression(.{ .unary = .{ .operator = .not, .operand = equal } });
    }

    const floating = target == .scalar and (target.scalar == .f32 or target.scalar == .f64);

    if (value.operator == .remainder or (value.operator == .divide and !floating)) return self.builtin(if (value.operator == .divide) .divTrunc else .rem, &.{ left, right });

    return self.builder.expression(.{ .binary = .{ .operator = std.meta.stringToEnum(node.BinaryOperator, @tagName(value.operator)).?, .left = left, .right = right } });
}

pub fn field(self: *Self, target: *const node.Expression, name: []const u8) Error!*const node.Expression {
    return self.builder.expression(.{ .field = .{ .target = target, .name = name } });
}

pub fn call(self: *Self, callee: *const node.Expression, arguments: []const *const node.Expression, fallible: bool) Error!*const node.Expression {
    for (arguments) |argument| {
        if (argument.* == .identifier and std.mem.eql(u8, argument.identifier, "allocator")) self.uses_allocator = true;
    }

    const result = try self.builder.expression(.{ .call = .{ .callee = callee, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });

    return if (fallible) self.builder.expression(.{ .try_value = result }) else result;
}

pub fn runtimeCall(self: *Self, name: []const u8, arguments: []const *const node.Expression, fallible: bool) Error!*const node.Expression {
    return self.call(try self.field(try self.builder.identifier("runtime"), name), arguments, fallible);
}

pub fn builtin(self: *Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const *const node.Expression) Error!*const node.Expression {
    return self.builder.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });
}

pub fn cast(self: *Self, type_expr: *const node.Expression, value: *const node.Expression) Error!*const node.Expression {
    return self.builtin(.as, &.{ type_expr, value });
}

pub fn fresh(self: *Self, prefix: []const u8) Error![]const u8 {
    self.serial += 1;

    return std.fmt.allocPrint(self.allocator, "{s}_{d}", .{ prefix, self.serial });
}

pub fn statements(self: *Self, values: []const ir.Statement) Error![]const node.Statement {
    return @import("statements.zig").lower(self, values);
}

pub fn commit(self: *Self) Error!*const node.Expression {
    return self.call(try self.field(try self.builder.identifier("context"), "commit"), &.{try self.builder.identifier("pending")}, true);
}
