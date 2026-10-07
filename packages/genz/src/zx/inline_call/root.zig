const std = @import("std");
const ir = @import("zx").ir;
const Plan = @import("plan.zig");
const Mapping = @import("mapping.zig");
const Self = @This();

allocator: std.mem.Allocator,
plan: Plan,
depth: usize = 0,
expressions: ir.ExpressionStorage = .{},
control: ir.ControlStorage = .{},
costs: std.ArrayList(usize) = .empty,
symbols: ir.SymbolStorage = .{},
pub fn prepare(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!ir.Program {
    if (program.functions.count() == 0) return program;

    const plan = try Plan.init(allocator, program);
    var result = program;
    var functions: ir.FunctionStorage = .{};

    errdefer functions.deinit(allocator);

    for (0..program.functions.count()) |index| {
        var function = program.functions.at(index);

        transform: {
            if (function.stores.count() != 0) break :transform;

            const selected = try @import("selection.zig").create(allocator, function.expressions, function.body, plan) orelse break :transform;

            const transformed = rebuild(allocator, plan, function.symbols, function.expressions, function.body, selected) catch |err| switch (err) {
                error.ExpansionLimit => break :transform,
                error.OutOfMemory => return error.OutOfMemory,
            };

            function.body = transformed.body;
            function.expressions = transformed.expressions;
            function.symbols = transformed.symbols;
        }

        try functions.append(allocator, function);
    }

    result.functions = try functions.finish(allocator);

    if (program.stores.count() != 0) return result;

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

const Rebuilt = struct { symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.ControlBody };

fn rebuild(allocator: std.mem.Allocator, plan: Plan, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.ControlBody, selected: []const bool) Mapping.Error!Rebuilt {
    var unit = Self{ .allocator = allocator, .plan = plan };
    var mapping = try Mapping.init(&unit, symbols, expressions, selected);

    for (0..expressions.count()) |index| _ = try mapping.expression(@fromBackingInt(@intCast(index)));

    const root = try mapping.block(body.block());

    return .{ .body = try unit.control.finish(allocator, root), .expressions = try unit.expressions.finish(allocator), .symbols = try unit.symbols.finish(allocator) };
}

pub fn append(self: *Self, expression: ir.Expression) std.mem.Allocator.Error!ir.ExprId {
    const id: ir.ExprId = @fromBackingInt(@intCast(self.expressions.count()));
    _ = try self.expressions.append(self.allocator, expression);
    const cost = 1 + @import("cost.zig").count(self.costs.items, self.expressions.at(@backingInt(id)).value);

    try self.costs.append(self.allocator, cost);

    return id;
}

pub fn symbol(self: *Self, item: ir.Symbol) std.mem.Allocator.Error!ir.SymbolId {
    const id: ir.SymbolId = @fromBackingInt(@intCast(self.symbols.count()));

    try self.symbols.append(self.allocator, item);

    return id;
}
