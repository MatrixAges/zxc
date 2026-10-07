const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
const StoreInitializer = @import("frontend").project.compiled.StoreInitializer;
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, UnreachableFlow, IncompleteFlow };

allocator: std.mem.Allocator,
types: ir.TypeTable,
native_modules: []const ir.NativeModule,
symbols: ir.SymbolStorage = .{},
expressions: std.ArrayList(ir.Expression) = .empty,
functions: std.ArrayList(ir.Function) = .empty,
store_initializers: std.ArrayList(StoreInitializer) = .empty,
stores: std.ArrayList(ir.StoreSlot) = .empty,
body: std.ArrayList(ir.Statement) = .empty,
bindings: std.ArrayList(ir.SymbolId) = .empty,
pub fn symbol(self: *Self, name: []const u8, type_id: ir.TypeId, span: zx.Span) std.mem.Allocator.Error!ir.SymbolId {
    const id: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name), .type_id = type_id, .span = span });

    return id;
}

pub fn expression(self: *Self, value: ir.Expression) std.mem.Allocator.Error!ir.ExprId {
    const id: ir.ExprId = @fromBackingInt(@intCast(self.expressions.items.len));

    try self.expressions.append(self.allocator, value);

    return id;
}

pub fn importFunction(self: *Self, program: ir.Program, initializers: []const StoreInitializer) Error!ir.FunctionId {
    const Nodes = @import("frontend").ArtifactNodes;
    const types = try self.allocator.alloc(ir.TypeId, self.types.count());
    const functions = try self.allocator.alloc(?ir.FunctionId, program.functions.len);
    const native_modules = try self.allocator.alloc(?ir.NativeModuleId, self.native_modules.len);

    for (types, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));
    for (functions, 0..) |*id, index| id.* = @fromBackingInt(@intCast(self.functions.items.len + index));
    for (native_modules, 0..) |*id, index| id.* = @fromBackingInt(@intCast(index));

    var nodes = Nodes{ .allocator = self.allocator, .types = .{ .mapped = types }, .functions = functions, .native_modules = native_modules };

    for (program.functions) |function| {
        const copied = nodes.function(function) catch |err| return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;

        try self.functions.append(self.allocator, copied);
    }

    for (initializers) |initial| {
        if (@backingInt(initial.function) >= functions.len) return error.InvalidModule;

        var mapped = initial;

        mapped.function = functions[@backingInt(initial.function)].?;

        var found = false;

        for (self.store_initializers.items) |previous| {
            if (!std.mem.eql(u8, previous.identity, mapped.identity)) continue;
            if (previous.schema_version != mapped.schema_version) return error.InvalidModule;

            const before = try std.json.Stringify.valueAlloc(self.allocator, self.functions.items[@backingInt(previous.function)], .{});

            defer self.allocator.free(before);

            const after = try std.json.Stringify.valueAlloc(self.allocator, self.functions.items[@backingInt(mapped.function)], .{});

            defer self.allocator.free(after);

            if (!std.mem.eql(u8, before, after)) return error.InvalidModule;

            found = true;

            break;
        }

        if (!found) try self.store_initializers.append(self.allocator, mapped);
    }

    const id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.items.len));

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
    for (self.stores.items, 0..) |*slot, index| {
        if (!std.mem.eql(u8, slot.path, value.path)) continue;
        if (slot.type_id != value.type_id) return error.InvalidModule;

        slot.readable = slot.readable or value.readable;
        slot.writable = slot.writable or value.writable;

        return @intCast(index);
    }

    const id: u32 = @intCast(self.stores.items.len);

    try self.stores.append(self.allocator, .{ .path = try self.allocator.dupe(u8, value.path), .type_id = value.type_id, .readable = value.readable, .writable = value.writable });

    return id;
}
