const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("types.zig");
const Error = @import("model.zig").Error;
const Self = @This();
const IdMap = @import("nodes/id_map.zig").Map;

pub const TypeMap = union(enum) {
    collect: if (@import("parser_options").generated_parser) void else *Types,
    mapped: []const ir.TypeId,
    planned: []const u64,
    identity: u32,
    pub fn include(self: TypeMap, id: ir.TypeId) Error!ir.TypeId {
        return switch (self) {
            .collect => |types| if (comptime @import("parser_options").generated_parser) unreachable else types.include(id),
            .mapped => |mapping| if (@backingInt(id) < mapping.len) mapping[@backingInt(id)] else error.InvalidModule,
            .planned => |mapping| if (@backingInt(id) < mapping.len and mapping[@backingInt(id)] != 0) @fromBackingInt(@intCast(mapping[@backingInt(id)] - 1)) else error.InvalidModule,
            .identity => |count| if (@backingInt(id) < count) id else error.InvalidModule,
        };
    }
};

allocator: std.mem.Allocator,
types: TypeMap,
functions: IdMap(ir.FunctionId),
native_modules: IdMap(ir.NativeModuleId),
pub fn constants(self: *Self, values: []const ir.Constant) Error![]const ir.Constant {
    if (values.len == 0) return &.{};

    const result = try self.allocator.alloc(ir.Constant, values.len);

    for (values, result) |value, *owned| {
        owned.* = try @import("../../analysis/constants/copy.zig").copy(self.allocator, value);
        owned.type_id = try self.types.include(value.type_id);
    }

    return result;
}

pub fn functionId(self: *Self, id: ir.FunctionId) Error!ir.FunctionId {
    return self.functions.get(id);
}

pub fn function(self: *Self, value: ir.Function) Error!ir.Function {
    var result = value;
    result.file_name = try self.allocator.dupe(u8, value.file_name);
    result.input_type = try self.types.include(value.input_type);
    result.output_type = try self.types.include(value.output_type);
    result.symbols = try self.symbols(value.symbols);
    result.expressions = try self.expressions(value.expressions);
    result.body = try self.body(value.body);
    result.stores = try self.stores(value.stores);
    result.contracts = try self.contracts(value.contracts);
    result.external = if (value.external) |entry| try self.external(entry) else null;

    return result;
}

pub fn stores(self: *Self, values: ir.StoreTable) Error!ir.StoreTable {
    if (!values.validStructure()) return error.InvalidModule;

    if (comptime @import("parser_options").generated_parser) {
        const mapped = try @import("nodes/remap.zig").columns(self, values.types, &.{});

        return @import("nodes/columns.zig").own(self.allocator, values, .{ .types = mapped.types });
    }

    var storage: ir.StoreStorage = .{};

    errdefer storage.deinit(self.allocator);

    for (0..values.count()) |index| {
        var item = values.at(index);

        item.path = try self.allocator.dupe(u8, item.path);
        item.handle = try self.allocator.dupe(u8, item.handle);
        item.type_id = try self.types.include(item.type_id);

        try storage.append(self.allocator, item);
    }

    return storage.finish(self.allocator);
}

fn symbols(self: *Self, values: ir.SymbolTable) Error!ir.SymbolTable {
    if (!values.validStructure()) return error.InvalidModule;

    if (comptime @import("parser_options").generated_parser) {
        const mapped = try @import("nodes/remap.zig").columns(self, values.types, &.{});

        return @import("nodes/columns.zig").own(self.allocator, values, .{ .types = mapped.types });
    }

    var storage: ir.SymbolStorage = .{};

    errdefer storage.deinit(self.allocator);

    for (0..values.count()) |index| {
        var item = values.at(index);

        item.name = try self.allocator.dupe(u8, item.name);
        item.type_id = try self.types.include(item.type_id);

        try storage.append(self.allocator, item);
    }

    return storage.finish(self.allocator);
}

fn expressions(self: *Self, values: ir.ExpressionTable) Error!ir.ExpressionTable {
    @setEvalBranchQuota(100_000);

    if (!values.validStructure()) return error.InvalidModule;

    if (comptime @import("parser_options").generated_parser) {
        const mapped = try @import("nodes/remap.zig").columns(self, values.types, values.call_functions);

        return @import("nodes/columns.zig").own(self.allocator, values, .{ .types = mapped.types, .call_functions = mapped.functions });
    }

    var result: ir.ExpressionTable = .{};

    inline for (@typeInfo(ir.ExpressionTable).@"struct".field_names) |name| {
        const source = @field(values, name);
        const owned = try self.allocator.dupe(@typeInfo(@TypeOf(source)).pointer.child, source);

        if (comptime std.mem.eql(u8, name, "types")) {
            for (owned) |*id| id.* = @backingInt(try self.types.include(@fromBackingInt(id.*)));
        } else if (comptime std.mem.eql(u8, name, "call_functions")) {
            for (owned) |*id| id.* = @backingInt(try self.functionId(@fromBackingInt(id.*)));
        } else if (comptime std.mem.eql(u8, name, "strings")) {
            for (owned) |*text| text.* = try self.allocator.dupe(u8, text.*);
        }

        @field(result, name) = owned;
    }

    return result;
}

fn contracts(self: *Self, values: ir.ContractTable) Error!ir.ContractTable {
    if (!values.validStructure()) return error.InvalidModule;
    if (values.count() == 0) return .{};

    const owned_symbols = try self.allocator.alloc(*const ir.SymbolTable, values.count());
    const owned_expressions = try self.allocator.alloc(*const ir.ExpressionTable, values.count());

    for (values.symbols, values.expressions, owned_symbols, owned_expressions) |source_symbols, source_expressions, *symbols_slot, *expressions_slot| {
        const mapped_symbols = try self.symbols(source_symbols.*);
        const mapped_expressions = try self.expressions(source_expressions.*);
        const symbol_table = try self.allocator.create(ir.SymbolTable);
        const expression_table = try self.allocator.create(ir.ExpressionTable);
        symbol_table.* = mapped_symbols;
        expression_table.* = mapped_expressions;
        symbols_slot.* = symbol_table;
        expressions_slot.* = expression_table;
    }

    return @import("nodes/columns.zig").own(self.allocator, values, .{ .symbols = owned_symbols, .expressions = owned_expressions });
}

fn body(self: *Self, value: ir.ControlBody) Error!ir.ControlBody {
    if (!try value.validStructure(self.allocator)) return error.InvalidModule;
    if (value.root == null) return .{};

    const table = try self.allocator.create(ir.ControlTable);

    table.* = try @import("nodes/columns.zig").own(self.allocator, value.control.*, .{});

    return .{ .control = table, .root = value.root };
}

pub fn external(self: *Self, value: ir.External) Error!ir.External {
    var result = value;

    result.module = try self.native_modules.get(value.module);
    result.member = try self.strings(value.member);
    result.errors = if (value.errors) |errors| try self.strings(errors) else null;
    result.export_name = if (value.export_name) |name| try self.allocator.dupe(u8, name) else null;
    result.input = if (value.input) |input| try self.nativeType(input) else null;

    return result;
}

fn nativeType(self: *Self, value: ir.NativeType) Error!ir.NativeType {
    const names = try self.allocator.alloc(?[]const u8, value.names.len);

    for (value.names, names) |name, *owned| owned.* = if (name) |text| try self.allocator.dupe(u8, text) else null;

    return .{ .names = names };
}

pub fn strings(self: *Self, values: []const []const u8) Error![]const []const u8 {
    const result = try self.allocator.alloc([]const u8, values.len);

    for (values, result) |value, *owned| owned.* = try self.allocator.dupe(u8, value);

    return result;
}
