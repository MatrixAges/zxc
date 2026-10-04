const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{InvalidModule};

allocator: std.mem.Allocator,
types: []const ir.Type,
native_modules: []const ir.NativeModule,
symbols: std.ArrayList(ir.Symbol) = .empty,
expressions: std.ArrayList(ir.Expression) = .empty,
functions: std.ArrayList(ir.Function) = .empty,
body: std.ArrayList(ir.Statement) = .empty,
bindings: std.ArrayList(ir.SymbolId) = .empty,
pub fn symbol(self: *Self, name: []const u8, type_id: ir.TypeId, span: zx.Span) Error!ir.SymbolId {
    const id: ir.SymbolId = @enumFromInt(self.symbols.items.len);

    try self.symbols.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name), .type_id = type_id, .span = span });

    return id;
}

pub fn expression(self: *Self, value: ir.Expression) Error!ir.ExprId {
    const id: ir.ExprId = @enumFromInt(self.expressions.items.len);

    try self.expressions.append(self.allocator, value);

    return id;
}

pub fn importFunction(self: *Self, program: ir.Program) Error!ir.FunctionId {
    const Nodes = @import("frontend").ArtifactNodes;
    const types = try self.allocator.alloc(ir.TypeId, self.types.len);
    const functions = try self.allocator.alloc(?ir.FunctionId, program.functions.len);
    const native_modules = try self.allocator.alloc(?ir.NativeModuleId, self.native_modules.len);

    for (types, 0..) |*id, index| id.* = @enumFromInt(index);
    for (functions, 0..) |*id, index| id.* = @enumFromInt(self.functions.items.len + index);
    for (native_modules, 0..) |*id, index| id.* = @enumFromInt(index);

    var nodes = Nodes{ .allocator = self.allocator, .types = .{ .mapped = types }, .functions = functions, .native_modules = native_modules };

    for (program.functions) |function| {
        const copied = nodes.function(function) catch |err| return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;

        try self.functions.append(self.allocator, copied);
    }

    const id: ir.FunctionId = @enumFromInt(self.functions.items.len);

    const main = nodes.function(.{
        .file_name = program.file_name,
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
