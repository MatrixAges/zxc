const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
const StoreInitializer = @import("frontend").project.compiled.StoreInitializer;
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, UnreachableFlow, IncompleteFlow };

allocator: std.mem.Allocator,
types: ir.TypeTable,
native_modules: ir.NativeModuleTable,
symbols: ir.SymbolStorage = .{},
expressions: ir.ExpressionStorage = .{},
functions: ir.FunctionStorage = .{},
base_functions: ir.FunctionTable = .{},
shared: bool = false,
store_initializers: std.ArrayList(StoreInitializer) = .empty,
stores: ir.StoreStorage = .{},
body: std.ArrayList(ir.Statement) = .empty,
control: ir.ControlStorage = .{},
bindings: std.ArrayList(ir.SymbolId) = .empty,
pub fn symbol(self: *Self, name: []const u8, type_id: ir.TypeId, span: zx.Span) std.mem.Allocator.Error!ir.SymbolId {
    const id: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name), .type_id = type_id, .span = span });

    return id;
}

pub fn expression(self: *Self, value: ir.Expression) std.mem.Allocator.Error!ir.ExprId {
    const id: ir.ExprId = @fromBackingInt(@intCast(self.expressions.count()));
    _ = try self.expressions.append(self.allocator, value);

    return id;
}

pub fn importFunction(self: *Self, program: ir.Program, initializers: []const StoreInitializer, existing: ?ir.FunctionId) Error!ir.FunctionId {
    if (existing) |id| {
        if (!self.shared or @backingInt(id) >= self.base_functions.count()) return error.InvalidModule;

        const function = self.base_functions.at(@backingInt(id));

        if (function.input_type != program.input_type or function.output_type != program.output_type or function.output_ownership != program.output_ownership or function.store_mode != program.store_mode or function.stores.count() != program.stores.count()) return error.InvalidModule;
        if (!std.mem.eql(u8, function.file_name, program.file_name)) return error.InvalidModule;

        for (0..function.stores.count()) |index| {
            const actual = function.stores.at(index);
            const expected = program.stores.at(index);

            if (!std.mem.eql(u8, actual.path, expected.path) or actual.type_id != expected.type_id or actual.readable != expected.readable or actual.writable != expected.writable) return error.InvalidModule;
        }

        for (initializers) |initial| try self.initializer(initial);

        return id;
    }

    const base_count = self.base_functions.count();

    if (self.shared and !@import("frontend").project.artifact.function_table.hasPrefix(program.functions, self.base_functions)) return error.InvalidModule;

    const Nodes = @import("frontend").ArtifactNodes;
    const types = try self.allocator.alloc(ir.TypeId, self.types.count());
    const functions = try self.allocator.alloc(?ir.FunctionId, program.functions.count());
    const native_modules = try self.allocator.alloc(?ir.NativeModuleId, self.native_modules.count());

    for (types, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));
    for (functions, 0..) |*id, index| id.* = @fromBackingInt(@intCast(if (index < base_count) index else self.functions.count() + index));
    for (native_modules, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));

    var nodes = Nodes{ .allocator = self.allocator, .types = .{ .mapped = types }, .functions = .{ .indexed = functions }, .native_modules = .{ .indexed = native_modules } };

    for (base_count..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);
        const copied = nodes.function(function) catch |err| return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;

        try self.functions.append(self.allocator, copied);
    }

    for (initializers) |initial| {
        if (@backingInt(initial.function) >= functions.len) return error.InvalidModule;

        var mapped = initial;

        mapped.function = functions[@backingInt(initial.function)].?;

        try self.initializer(mapped);
    }

    const id: ir.FunctionId = @fromBackingInt(@intCast(base_count + self.functions.count()));

    const main = nodes.function(.{
        .file_name = program.file_name,
        .stores = program.stores,
        .store_mode = program.store_mode,
        .input_type = program.input_type,
        .output_type = program.output_type,
        .output_ownership = program.output_ownership,
        .symbols = program.symbols,
        .expressions = program.expressions,
        .body = program.body,
        .contracts = program.contracts,
    }) catch |err| return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;

    try self.functions.append(self.allocator, main);

    return id;
}

pub fn store(self: *Self, value: ir.StoreSlot) Error!u32 {
    for (0..self.stores.count()) |index| {
        const slot = self.stores.at(index);

        if (!std.mem.eql(u8, slot.path, value.path)) continue;
        if (slot.type_id != value.type_id) return error.InvalidModule;

        self.stores.readable.items[index] = slot.readable or value.readable;
        self.stores.writable.items[index] = slot.writable or value.writable;

        return @intCast(index);
    }

    const id: u32 = @intCast(self.stores.count());

    try self.stores.append(self.allocator, .{ .path = try self.allocator.dupe(u8, value.path), .type_id = value.type_id, .readable = value.readable, .writable = value.writable });

    return id;
}

fn lookupFunction(self: *const Self, id: ir.FunctionId) ir.Function {
    const index = @backingInt(id);

    return if (index < self.base_functions.count()) self.base_functions.at(index) else self.functions.at(index - self.base_functions.count());
}

pub fn initializer(self: *Self, value: StoreInitializer) Error!void {
    if (@backingInt(value.function) >= self.base_functions.count() + self.functions.count()) return error.InvalidModule;

    for (self.store_initializers.items) |previous| {
        if (!std.mem.eql(u8, previous.identity, value.identity)) continue;
        if (previous.schema_version != value.schema_version) return error.InvalidModule;
        if (previous.function == value.function) return;

        const before = try std.json.Stringify.valueAlloc(self.allocator, self.lookupFunction(previous.function), .{});

        defer self.allocator.free(before);

        const after = try std.json.Stringify.valueAlloc(self.allocator, self.lookupFunction(value.function), .{});

        defer self.allocator.free(after);

        if (!std.mem.eql(u8, before, after)) return error.InvalidModule;

        return;
    }

    try self.store_initializers.append(self.allocator, value);
}
