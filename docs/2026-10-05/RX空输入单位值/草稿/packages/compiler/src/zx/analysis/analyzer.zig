const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Types = @import("types.zig");
const expressions = @import("expressions.zig");
const statements = @import("statements.zig");
const Self = @This();

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
types: Types,
symbols: std.ArrayList(ir.Symbol) = .empty,
active: std.ArrayList(ir.SymbolId) = .empty,
nodes: std.ArrayList(ir.Expression) = .empty,
output_type: ir.TypeId = undefined,
function_imports: []const FunctionImport = &.{},
functions: []const ir.Function = &.{},
stores: []const ir.StoreSlot = &.{},
store_bindings: []const @import("analyze.zig").StoreBinding = &.{},
store_type_count: usize = 0,
expression_bindings: std.ArrayList(ir.SymbolId) = .empty,
expression_units: std.ArrayList([]const u8) = .empty,
allow_store: bool = false,
lambda_depth: usize = 0,
scope_floor: usize = 0,
pub const FunctionImport = @import("../modules/function_import.zig");

pub fn run(self: *Self, program: zx.ast.Program, file_name: []const u8) zx.Error!ir.Program {
    try self.types.initialize();

    const contract_span = if (program.body) |body| body.span else zx.Span{ .start = 0, .end = 0 };
    const input_type = if (program.body != null) try self.types.named(.{ .text = "Input", .span = contract_span }) else Types.scalarId(.void);

    self.output_type = if (program.body != null) try self.types.named(.{ .text = "Output", .span = contract_span }) else Types.scalarId(.void);

    if (self.store_bindings.len > 0) self.stores = try @import("store.zig").resolve(self, self.store_bindings, contract_span);

    self.allow_store = program.has_store or self.stores.len > 0;

    if (program.has_store and self.stores.len == 0) return self.reporter.fail(.capability, contract_span, "Store setters require an authorized call context");

    const body = if (program.body) |source_body| blk: {
        _ = try self.bind(.{ .text = "in", .span = contract_span }, input_type, 0);

        break :blk try self.block(source_body);
    } else &.{};

    if (self.output_type != Types.scalarId(.void) and !returns(body)) return self.reporter.fail(.return_path, contract_span, "every path must return Output");

    const exports = try self.allocator.alloc(ir.Export, program.declarations.len);

    for (program.declarations, 0..) |declaration, index| exports[index] = .{
        .name = try self.allocator.dupe(u8, declaration.name.text),
        .type_id = try self.types.named(declaration.name),
    };

    const contracts = try @import("contracts.zig").analyze(self, program.contracts, input_type, exports);

    return .{
        .consumes_input = program.consumes_input,
        .contracts = contracts,
        .file_name = try self.allocator.dupe(u8, file_name),
        .types = try self.types.items.toOwnedSlice(self.allocator),
        .symbols = try self.symbols.toOwnedSlice(self.allocator),
        .expressions = try self.nodes.toOwnedSlice(self.allocator),
        .input_type = input_type,
        .output_type = self.output_type,
        .body = body,
        .exports = exports,
        .stores = self.stores,
        .type_only = program.body == null,
    };
}

pub fn expression(self: *Self, value: *const zx.ast.Expression, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const result = try expressions.analyze(self, value, expected);

    return if (expected) |type_id| self.coerce(result, type_id, value.span) else result;
}

pub fn coerce(self: *Self, id: ir.ExprId, expected: ir.TypeId, span: zx.Span) zx.Error!ir.ExprId {
    if (self.node(id).type_id == expected) return id;

    const target = self.types.get(expected);

    if (target == .optional) {
        const child = try self.coerce(id, target.optional, span);

        return self.append(.{ .type_id = expected, .span = span, .value = .{ .some = child } });
    }

    return self.reporter.fail(.type_mismatch, span, "expression type does not match its context");
}

pub fn append(self: *Self, value: ir.Expression) zx.Error!ir.ExprId {
    const id: ir.ExprId = @enumFromInt(self.nodes.items.len);

    try self.nodes.append(self.allocator, value);

    return id;
}

pub fn node(self: *const Self, id: ir.ExprId) ir.Expression {
    return self.nodes.items[@intFromEnum(id)];
}

pub fn lookup(self: *const Self, name: []const u8) ?ir.SymbolId {
    var index = self.active.items.len;

    while (index > self.scope_floor) {
        index -= 1;
        const id = self.active.items[index];

        if (std.mem.eql(u8, self.symbols.items[@intFromEnum(id)].name, name)) return id;
    }

    return null;
}

pub fn resolveValue(self: *Self, name: zx.ast.Name) zx.Error!ir.SymbolId {
    if (self.lookup(name.text)) |id| return id;

    for (self.active.items[0..self.scope_floor]) |id| {
        if (std.mem.eql(u8, self.symbols.items[@intFromEnum(id)].name, name.text)) {
            return self.reporter.fail(.ownership, name.span, "ZX callbacks cannot capture outer bindings; use explicit callback parameters");
        }
    }

    return self.reporter.fail(.name, name.span, "unknown value or use before declaration");
}

pub fn bind(self: *Self, name: zx.ast.Name, type_id: ir.TypeId, scope_start: usize) zx.Error!ir.SymbolId {
    if (std.mem.startsWith(u8, name.text, "$")) return self.reporter.fail(.capability, name.span, "$ names are reserved for Call-injected handles");

    for (self.active.items[scope_start..]) |id| {
        if (std.mem.eql(u8, self.symbols.items[@intFromEnum(id)].name, name.text)) return self.reporter.fail(.name, name.span, "duplicate binding in the same scope");
    }

    const id: ir.SymbolId = @enumFromInt(self.symbols.items.len);

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = type_id, .span = name.span });
    try self.active.append(self.allocator, id);

    return id;
}

pub fn block(self: *Self, value: zx.ast.Block) zx.Error![]const ir.Statement {
    return statements.block(self, value);
}

pub const returns = ir.terminates;
