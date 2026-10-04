const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("types.zig");
const Error = @import("model.zig").Error;
const Self = @This();

allocator: std.mem.Allocator,
types: *Types,
functions: []const ?ir.FunctionId,
native_modules: []const ?ir.NativeModuleId,
pub fn functionId(self: *Self, id: ir.FunctionId) Error!ir.FunctionId {
    const index = @intFromEnum(id);

    if (index >= self.functions.len) return error.InvalidModule;

    return self.functions[index] orelse error.InvalidModule;
}

pub fn function(self: *Self, value: ir.Function) Error!ir.Function {
    var result = value;
    result.file_name = try self.allocator.dupe(u8, value.file_name);
    result.input_type = try self.types.include(value.input_type);
    result.output_type = try self.types.include(value.output_type);
    result.symbols = try self.symbols(value.symbols);
    result.expressions = try self.expressions(value.expressions);
    result.body = try self.statements(value.body);
    const contracts = try self.allocator.alloc(ir.Contract, value.contracts.len);
    result.contracts = contracts;

    for (value.contracts, contracts) |contract, *owned| {
        owned.* = contract;
        owned.symbols = try self.symbols(contract.symbols);
        owned.expressions = try self.expressions(contract.expressions);
    }

    result.external = if (value.external) |entry| try self.external(entry) else null;

    return result;
}

fn symbols(self: *Self, values: []const ir.Symbol) Error![]const ir.Symbol {
    const result = try self.allocator.dupe(ir.Symbol, values);

    for (result) |*item| {
        item.name = try self.allocator.dupe(u8, item.name);
        item.type_id = try self.types.include(item.type_id);
    }

    return result;
}

fn expressions(self: *Self, values: []const ir.Expression) Error![]const ir.Expression {
    const result = try self.allocator.dupe(ir.Expression, values);

    for (result) |*item| {
        item.type_id = try self.types.include(item.type_id);

        item.value = switch (item.value) {
            .string => |text| .{ .string = try self.allocator.dupe(u8, text) },
            .list => |ids| .{ .list = try self.allocator.dupe(ir.ExprId, ids) },
            .tuple => |ids| .{ .tuple = try self.allocator.dupe(ir.ExprId, ids) },
            .template => |ids| .{ .template = try self.allocator.dupe(ir.ExprId, ids) },
            .list_operation => |operation| .{ .list_operation = .{ .kind = operation.kind, .target = operation.target, .arguments = try self.allocator.dupe(ir.ExprId, operation.arguments) } },
            .transform => |transform| blk: {
                var owned = transform;
                owned.parameters = try self.allocator.dupe(ir.SymbolId, transform.parameters);

                break :blk .{ .transform = owned };
            },
            .match_expr => |selection| .{ .match_expr = .{ .subject = selection.subject, .arms = try self.allocator.dupe(ir.MatchArm, selection.arms), .fallback = selection.fallback } },
            .object => |object| .{ .object = .{ .fields = try self.allocator.dupe(ir.ObjectField, object.fields), .evaluation = try self.allocator.dupe(ir.ExprId, object.evaluation) } },
            .call => |call| .{ .call = .{ .function = try self.functionId(call.function), .argument = call.argument } },
            .integer, .negative_integer, .float, .boolean, .none, .unit, .some, .enum_value, .reference, .store_get, .context_get, .field, .index, .length, .tuple_field, .unary, .binary, .conditional => item.value,
        };
    }

    return result;
}

fn statements(self: *Self, values: []const ir.Statement) Error![]const ir.Statement {
    const result = try self.allocator.dupe(ir.Statement, values);

    for (result) |*item| item.* = switch (item.*) {
        .constant, .store_set, .result => item.*,
        .destructure => |binding| .{ .destructure = .{ .symbols = try self.allocator.dupe(?ir.SymbolId, binding.symbols), .value = binding.value } },
        .branch => |branch| .{ .branch = .{ .condition = branch.condition, .yes = try self.statements(branch.yes), .no = try self.statements(branch.no) } },
        .switch_stmt => |selection| blk: {
            const cases = try self.allocator.dupe(ir.SwitchCase, selection.cases);

            for (cases) |*case| case.body = try self.statements(case.body);

            break :blk .{ .switch_stmt = .{ .subject = selection.subject, .cases = cases, .exhaustive = selection.exhaustive } };
        },
    };

    return result;
}

pub fn external(self: *Self, value: ir.External) Error!ir.External {
    const index = @intFromEnum(value.module);

    if (index >= self.native_modules.len) return error.InvalidModule;

    var result = value;

    result.module = self.native_modules[index] orelse return error.InvalidModule;
    result.member = try self.strings(value.member);
    result.export_name = if (value.export_name) |name| try self.allocator.dupe(u8, name) else null;
    result.input = if (value.input) |input| try self.nativeType(input) else null;

    return result;
}

fn nativeType(self: *Self, value: ir.NativeType) Error!ir.NativeType {
    const children = try self.allocator.alloc(ir.NativeType, value.children.len);

    for (value.children, children) |child, *owned| owned.* = try self.nativeType(child);

    return .{ .name = if (value.name) |name| try self.allocator.dupe(u8, name) else null, .children = children };
}

pub fn strings(self: *Self, values: []const []const u8) Error![]const []const u8 {
    const result = try self.allocator.alloc([]const u8, values.len);

    for (values, result) |value, *owned| owned.* = try self.allocator.dupe(u8, value);

    return result;
}
