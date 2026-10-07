const std = @import("std");
const ir = @import("zx").ir;
const Plan = @import("plan.zig");
const Mapping = @import("mapping.zig");
const Self = @This();

allocator: std.mem.Allocator,
plan: Plan,
depth: usize = 0,
expressions: std.ArrayList(ir.Expression) = .empty,
costs: std.ArrayList(usize) = .empty,
symbols: ir.SymbolStorage = .{},
pub fn prepare(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!ir.Program {
    if (program.functions.len == 0) return program;

    const plan = try Plan.init(allocator, program);
    var result = program;
    const functions = try allocator.dupe(ir.Function, program.functions);

    for (functions) |*function| {
        if (function.stores.len != 0) continue;

        const selected = try @import("selection.zig").create(allocator, function.expressions, function.body, plan) orelse continue;

        const transformed = rebuild(allocator, plan, function.symbols, function.expressions, function.body, selected) catch |err| switch (err) {
            error.ExpansionLimit => continue,
            error.OutOfMemory => return error.OutOfMemory,
        };

        function.body = transformed.body;
        function.expressions = transformed.expressions;
        function.symbols = transformed.symbols;
    }

    result.functions = functions;

    if (program.stores.len != 0) return result;

    if (try @import("selection.zig").create(allocator, program.expressions, program.body, plan)) |selected| {
        const transformed = rebuild(allocator, plan, program.symbols, program.expressions, program.body, selected) catch |err| switch (err) {
            error.ExpansionLimit => return result,
            error.OutOfMemory => return error.OutOfMemory,
        };

        result.body = transformed.body;
        result.expressions = transformed.expressions;
        result.symbols = transformed.symbols;
    }

    return result;
}

const Rebuilt = struct { symbols: ir.SymbolTable, expressions: []const ir.Expression, body: []const ir.Statement };

fn rebuild(allocator: std.mem.Allocator, plan: Plan, symbols: ir.SymbolTable, expressions: []const ir.Expression, body: []const ir.Statement, selected: []const bool) Mapping.Error!Rebuilt {
    var unit = Self{ .allocator = allocator, .plan = plan };
    var mapping = try Mapping.init(&unit, symbols, expressions, selected);

    for (expressions, 0..) |_, index| _ = try mapping.expression(@fromBackingInt(@intCast(index)));

    const statements = try mapping.value([]const ir.Statement, body);

    return .{ .body = statements, .expressions = try unit.expressions.toOwnedSlice(allocator), .symbols = try unit.symbols.finish(allocator) };
}

pub fn append(self: *Self, expression: ir.Expression) std.mem.Allocator.Error!ir.ExprId {
    const id: ir.ExprId = @fromBackingInt(@intCast(self.expressions.items.len));
    const cost = 1 + @import("cost.zig").count(self.costs.items, expression.value);

    try self.expressions.append(self.allocator, expression);
    try self.costs.append(self.allocator, cost);

    return id;
}

pub fn symbol(self: *Self, item: ir.Symbol) std.mem.Allocator.Error!ir.SymbolId {
    const id: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, item);

    return id;
}
