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
symbols: ir.SymbolStorage = .{},
active: std.ArrayList(ir.SymbolId) = .empty,
nodes: ir.ExpressionStorage = .{},
control: ir.ControlStorage = .{},
output_type: ir.TypeId = undefined,
function_imports: []const FunctionImport = &.{},
functions: ir.FunctionTable = .{},
stores: ir.StoreTable = .{},
store_bindings: []const @import("analyze.zig").StoreBinding = &.{},
store_type_count: usize = 0,
expression_bindings: std.ArrayList(ir.SymbolId) = .empty,
expression_units: std.ArrayList([]const u8) = .empty,
allow_store: bool = false,
lambda_depth: usize = 0,
scope_floor: usize = 0,
refinement: zx.Refinement = .{},
pub const FunctionImport = @import("../modules/function_import.zig");

pub fn run(self: *Self, program: zx.ast.Program, file_name: []const u8) zx.Error!ir.Program {
    try self.types.initialize();

    return self.runInitialized(program, @import("type_views").Native{ .items = program.declarations }, file_name);
}

pub fn runView(self: *Self, program: anytype, view: anytype, file_name: []const u8) zx.Error!ir.Program {
    try @import("types/resolve.zig").initialize(&self.types, view);

    return self.runInitialized(program, view, file_name);
}

fn runInitialized(self: *Self, program: anytype, view: anytype, file_name: []const u8) zx.Error!ir.Program {
    const contract_span = if (program.body) |body| body.span else zx.Span{ .start = 0, .end = 0 };
    const input_type = if (program.body != null) try self.types.named(.{ .text = "Input", .span = contract_span }) else Types.scalarId(.void);

    self.output_type = if (program.body != null) try self.types.named(.{ .text = "Output", .span = contract_span }) else Types.scalarId(.void);

    try self.resolveStores(program.has_store, contract_span);

    const body: ?ir.BlockId = if (program.body) |source_body| blk: {
        _ = try self.bind(.{ .text = "in", .span = contract_span }, input_type, 0);

        break :blk try self.block(source_body);
    } else null;

    if (self.output_type != Types.scalarId(.void) and !self.control.returns(body.?)) return self.reporter.fail(.return_path, contract_span, "every path must return Output");

    const exports = try self.exportTypes(view);
    const contracts = try @import("contracts.zig").analyze(self, program.contracts, input_type, exports);

    return self.finish(.{
        .contracts = contracts,
        .file_name = file_name,
        .input_type = input_type,
        .body = body,
        .exports = exports,
        .type_only = program.body == null,
    });
}

fn resolveStores(self: *Self, has_store: bool, span: zx.Span) zx.Error!void {
    if (self.store_bindings.len > 0) self.stores = try @import("store.zig").resolve(self, self.store_bindings, span);

    self.allow_store = has_store or self.stores.count() > 0;

    if (has_store and self.stores.count() == 0) return self.reporter.fail(.capability, span, "Store setters require an authorized call context");
}

fn exportTypes(self: *Self, view: anytype) zx.Error![]const ir.Export {
    const declarations = view.declarations();
    const exports = try self.allocator.alloc(ir.Export, declarations.count());
    var iterator = declarations.iterator();

    for (exports) |*item| {
        const declaration = iterator.next().?;

        item.* = .{
            .name = try self.allocator.dupe(u8, declaration.name.text),
            .type_id = try self.types.named(declaration.name),
        };
    }

    return exports;
}

const Output = struct {
    file_name: []const u8,
    input_type: ir.TypeId,
    exports: []const ir.Export,
    type_only: bool,
    body: ?ir.BlockId = null,
    contracts: []const ir.Contract = &.{},
};

fn finish(self: *Self, output: Output) zx.Error!ir.Program {
    return .{
        .contracts = output.contracts,
        .file_name = try self.allocator.dupe(u8, output.file_name),
        .types = try self.types.items.finish(self.allocator),
        .symbols = try self.symbols.finish(self.allocator),
        .expressions = try self.nodes.finish(self.allocator),
        .input_type = output.input_type,
        .output_type = self.output_type,
        .body = try self.control.finish(self.allocator, output.body),
        .exports = output.exports,
        .stores = self.stores,
        .type_only = output.type_only,
    };
}

pub fn expression(self: *Self, value: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const source = if (@TypeOf(value) == *zx.ast.Expression) @as(*const zx.ast.Expression, value) else value;
    const result = try expressions.analyze(self, source, expected);

    return if (expected) |type_id| self.coerce(result, type_id, value.span) else result;
}

pub fn resolveType(self: *Self, value: anytype) zx.Error!ir.TypeId {
    if (@TypeOf(value) == *const zx.ast.Type or @TypeOf(value) == *zx.ast.Type) return self.types.resolve(value);

    return @import("types/resolve.zig").node(&self.types, value.view.*, value.ref);
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
    const id: ir.ExprId = @fromBackingInt(@intCast(self.nodes.count()));
    _ = try self.nodes.append(self.allocator, value);

    return id;
}

pub fn node(self: *const Self, id: ir.ExprId) ir.ExpressionRow {
    return self.nodes.at(@backingInt(id));
}

pub fn lookup(self: *const Self, name: []const u8) ?ir.SymbolId {
    var index = self.active.items.len;

    while (index > self.scope_floor) {
        index -= 1;
        const id = self.active.items[index];

        if (std.mem.eql(u8, self.symbols.at(@backingInt(id)).name, name)) return id;
    }

    return null;
}

pub fn resolveValue(self: *Self, name: zx.ast.Name) zx.Error!ir.SymbolId {
    if (self.lookup(name.text)) |id| return id;

    for (self.active.items[0..self.scope_floor]) |id| {
        if (std.mem.eql(u8, self.symbols.at(@backingInt(id)).name, name.text)) {
            return self.reporter.fail(.ownership, name.span, "ZX callbacks cannot capture outer bindings; use explicit callback parameters");
        }
    }

    return self.reporter.fail(.name, name.span, "unknown value or use before declaration");
}

pub fn bind(self: *Self, name: zx.ast.Name, type_id: ir.TypeId, scope_start: usize) zx.Error!ir.SymbolId {
    if (std.mem.startsWith(u8, name.text, "$")) return self.reporter.fail(.capability, name.span, "$ names are reserved for Call-injected handles");

    for (self.active.items[scope_start..]) |id| {
        if (std.mem.eql(u8, self.symbols.at(@backingInt(id)).name, name.text)) return self.reporter.fail(.name, name.span, "duplicate binding in the same scope");
    }

    const id: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = type_id, .span = name.span });
    try self.active.append(self.allocator, id);

    return id;
}

pub fn block(self: *Self, value: anytype) zx.Error!ir.BlockId {
    return statements.block(self, value);
}

pub const returns = ir.terminates;
