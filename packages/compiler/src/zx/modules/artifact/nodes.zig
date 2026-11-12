const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("types.zig");
const Error = @import("model.zig").Error;
const Self = @This();
const IdMap = @import("nodes/id_map.zig").Map;
const own = @import("nodes/columns.zig").own;
const generated = @import("parser_options").generated_parser;

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
    if (comptime generated) return self.linkedFunction(value);

    var result = value;

    result.file_name = try self.allocator.dupe(u8, value.file_name);
    result.input_type = try self.types.include(value.input_type);
    result.output_type = try self.types.include(value.output_type);
    result.symbols = try self.symbolsSeed(value.symbols);
    result.expressions = try self.expressionsSeed(value.expressions);
    result.body = try self.body(value.body);
    result.stores = try self.stores(value.stores);
    result.contracts = try self.contracts(value.contracts, {});
    result.external = if (value.external) |entry| try self.external(entry) else null;

    return result;
}

fn linkedFunction(self: *Self, value: ir.Function) Error!ir.Function {
    const mapped = try @import("nodes/remap.zig").function(self, &value);
    var result = value;
    result.file_name = try self.allocator.dupe(u8, value.file_name);
    result.input_type = @fromBackingInt(mapped.ports.input);
    result.output_type = @fromBackingInt(mapped.ports.output);
    result.symbols = try own(self.allocator, value.symbols, .{ .types = mapped.symbols });
    result.expressions = try own(self.allocator, value.expressions, .{ .types = mapped.expressions, .call_functions = mapped.calls });
    result.body = try self.body(value.body);
    result.stores = try own(self.allocator, value.stores, .{ .types = mapped.stores });
    result.contracts = try self.contracts(value.contracts, mapped.contracts);
    result.external = if (value.external) |entry| try self.externalMapped(entry, @fromBackingInt(mapped.ports.native_module.?)) else null;

    return result;
}

pub fn stores(self: *Self, values: ir.StoreTable) Error!ir.StoreTable {
    if (!values.validStructure()) return error.InvalidModule;

    if (comptime generated) {
        const mapped = try @import("nodes/remap.zig").columns(self.allocator, self, values.types, &.{});

        return own(self.allocator, values, .{ .types = mapped.types });
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

fn symbolsSeed(self: *Self, values: ir.SymbolTable) Error!ir.SymbolTable {
    if (!values.validStructure()) return error.InvalidModule;

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

fn expressionsSeed(self: *Self, values: ir.ExpressionTable) Error!ir.ExpressionTable {
    @setEvalBranchQuota(100_000);

    if (!values.validStructure()) return error.InvalidModule;

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

fn contracts(self: *Self, values: ir.ContractTable, mapped: anytype) Error!ir.ContractTable {
    if (comptime @TypeOf(mapped) == void) {
        if (!values.validStructure()) return error.InvalidModule;
    }

    if (values.count() == 0) return .{};

    const owned_symbols = try self.allocator.alloc(*const ir.SymbolTable, values.count());
    const owned_expressions = try self.allocator.alloc(*const ir.ExpressionTable, values.count());

    for (values.symbols, values.expressions, owned_symbols, owned_expressions, 0..) |source_symbols, source_expressions, *symbols_slot, *expressions_slot, index| {
        const symbol_table = try self.allocator.create(ir.SymbolTable);
        const expression_table = try self.allocator.create(ir.ExpressionTable);

        if (comptime @TypeOf(mapped) == void) {
            symbol_table.* = try self.symbolsSeed(source_symbols.*);
            expression_table.* = try self.expressionsSeed(source_expressions.*);
        } else {
            symbol_table.* = try own(self.allocator, source_symbols.*, .{ .types = mapped.symbols[index] });
            expression_table.* = try own(self.allocator, source_expressions.*, .{ .types = mapped.types[index], .call_functions = mapped.calls[index] });
        }

        symbols_slot.* = symbol_table;
        expressions_slot.* = expression_table;
    }

    return own(self.allocator, values, .{ .symbols = owned_symbols, .expressions = owned_expressions });
}

fn body(self: *Self, value: ir.ControlBody) Error!ir.ControlBody {
    if (!try value.validStructure(self.allocator)) return error.InvalidModule;
    if (value.root == null) return .{};

    const table = try self.allocator.create(ir.ControlTable);

    table.* = try own(self.allocator, value.control.*, .{});

    return .{ .control = table, .root = value.root };
}

pub fn external(self: *Self, value: ir.External) Error!ir.External {
    return self.externalMapped(value, try self.native_modules.get(value.module));
}

fn externalMapped(self: *Self, value: ir.External, module: ir.NativeModuleId) Error!ir.External {
    var result = value;

    result.module = module;
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
