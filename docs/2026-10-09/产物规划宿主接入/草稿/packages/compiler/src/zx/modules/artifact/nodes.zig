const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("types.zig");
const Error = @import("model.zig").Error;
const Self = @This();

pub const TypeMap = union(enum) {
    collect: *Types,
    mapped: []const ir.TypeId,
    planned: []const u64,
    pub fn include(self: TypeMap, id: ir.TypeId) Error!ir.TypeId {
        return switch (self) {
            .collect => |types| types.include(id),
            .mapped => |mapping| if (@backingInt(id) < mapping.len) mapping[@backingInt(id)] else error.InvalidModule,
            .planned => |mapping| if (@backingInt(id) < mapping.len and mapping[@backingInt(id)] != 0) @fromBackingInt(@intCast(mapping[@backingInt(id)] - 1)) else error.InvalidModule,
        };
    }
};

allocator: std.mem.Allocator,
types: TypeMap,
functions: []const ?ir.FunctionId,
native_modules: []const ?ir.NativeModuleId,
pub fn functionId(self: *Self, id: ir.FunctionId) Error!ir.FunctionId {
    const index = @backingInt(id);

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
    result.body = try self.body(value.body);
    result.stores = try self.stores(value.stores);

    var contracts: ir.ContractStorage = .{};

    errdefer contracts.deinit(self.allocator);

    if (!value.contracts.validStructure()) return error.InvalidModule;

    for (0..value.contracts.count()) |index| {
        var contract = value.contracts.at(index);

        contract.symbols = try self.symbols(contract.symbols);
        contract.expressions = try self.expressions(contract.expressions);

        try contracts.append(self.allocator, contract);
    }

    result.contracts = try contracts.finish(self.allocator);
    result.external = if (value.external) |entry| try self.external(entry) else null;

    return result;
}

pub fn stores(self: *Self, values: ir.StoreTable) Error!ir.StoreTable {
    if (!values.validStructure()) return error.InvalidModule;

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

fn body(self: *Self, value: ir.ControlBody) Error!ir.ControlBody {
    if (!try value.validStructure(self.allocator)) return error.InvalidModule;
    if (value.root == null) return .{};

    const table = try self.allocator.create(ir.ControlTable);

    inline for (@typeInfo(ir.ControlTable).@"struct".field_names) |name| {
        const source = @field(value.control, name);

        @field(table, name) = try self.allocator.dupe(@typeInfo(@TypeOf(source)).pointer.child, source);
    }

    return .{ .control = table, .root = value.root };
}

pub fn external(self: *Self, value: ir.External) Error!ir.External {
    const index = @backingInt(value.module);

    if (index >= self.native_modules.len) return error.InvalidModule;

    var result = value;

    result.module = self.native_modules[index] orelse return error.InvalidModule;
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
