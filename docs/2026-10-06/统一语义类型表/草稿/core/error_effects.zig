const std = @import("std");
const ir = @import("ir.zig");
const Self = @This();

allocator: std.mem.Allocator,
types: ir.TypeTable,
functions: []const ir.Function,
names: std.StringHashMapUnmanaged(void) = .empty,
visited: std.AutoHashMapUnmanaged(usize, void) = .empty,
called: std.AutoHashMapUnmanaged(ir.FunctionId, void) = .empty,
unknown: bool = false,
pub fn program(allocator: std.mem.Allocator, value: ir.Program) std.mem.Allocator.Error!?[]const []const u8 {
    var self = Self{ .allocator = allocator, .types = value.types, .functions = value.functions };

    defer self.deinit();

    if (value.stores.len != 0) self.unknown = true;
    try self.contracts(value.contracts);
    try self.statements(value.expressions, value.body);

    return self.finish();
}

pub fn expression(allocator: std.mem.Allocator, types: ir.TypeTable, functions: []const ir.Function, values: []const ir.Expression, id: ir.ExprId) std.mem.Allocator.Error!?[]const []const u8 {
    var self = Self{ .allocator = allocator, .types = types, .functions = functions };

    defer self.deinit();

    try self.visit(values, id);

    return self.finish();
}

fn deinit(self: *Self) void {
    self.names.deinit(self.allocator);
    self.visited.deinit(self.allocator);
    self.called.deinit(self.allocator);
}

fn finish(self: *Self) std.mem.Allocator.Error!?[]const []const u8 {
    if (self.unknown) return null;

    const result = try self.allocator.alloc([]const u8, self.names.count());
    var iterator = self.names.keyIterator();

    for (result) |*name| name.* = (iterator.next().?).*;

    std.mem.sort([]const u8, result, {}, lessThan);

    return result;
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}

pub fn add(self: *Self, name: []const u8) std.mem.Allocator.Error!void {
    try self.names.put(self.allocator, name, {});
}

pub fn visit(self: *Self, values: []const ir.Expression, id: ir.ExprId) std.mem.Allocator.Error!void {
    const value = &values[@backingInt(id)];
    const entry = try self.visited.getOrPut(self.allocator, @intFromPtr(value));

    if (entry.found_existing) return;

    try @import("error_effects/expression.zig").visit(self, values, value.*);
}

pub fn call(self: *Self, id: ir.FunctionId) std.mem.Allocator.Error!void {
    const entry = try self.called.getOrPut(self.allocator, id);

    if (entry.found_existing) return;

    const function = self.functions[@backingInt(id)];

    if (function.external) |external| {
        if (!external.fallible) return;

        if (external.errors) |errors| {
            for (errors) |name| try self.add(name);
        } else self.unknown = true;

        return;
    }

    if (function.stores.len != 0) self.unknown = true;
    try self.contracts(function.contracts);
    try self.statements(function.expressions, function.body);
}

fn contracts(self: *Self, values: []const ir.Contract) std.mem.Allocator.Error!void {
    for (values) |contract| {
        if (contract.kind != .requires) continue;
        try self.add("PreconditionFailed");
        try self.visit(contract.expressions, contract.predicate);
    }
}

fn statements(self: *Self, values: []const ir.Expression, body: []const ir.Statement) std.mem.Allocator.Error!void {
    for (body) |statement| {
        switch (statement) {
            .evaluate => |id| try self.visit(values, id),
            .constant => |binding| try self.visit(values, binding.value),
            .destructure => |binding| if (values[@backingInt(binding.value)].value != .capture) try self.visit(values, binding.value),
            .store_set => |write| {
                self.unknown = true;

                try self.visit(values, write.value);
            },
            .result => |value| {
                if (value) |id| try self.visit(values, id);

                return;
            },
            .parallel => |calls| {
                self.unknown = true;

                for (calls) |invocation| try self.visit(values, invocation.value);
            },
            .branch => |branch| {
                try self.visit(values, branch.condition);
                try self.statements(values, branch.yes);
                try self.statements(values, branch.no);
            },
            .switch_stmt => |selection| {
                try self.visit(values, selection.subject);

                for (selection.cases) |case| {
                    if (case.value) |id| try self.visit(values, id);
                    try self.statements(values, case.body);
                }
            },
        }

        if (ir.terminates(&.{statement})) return;
    }
}
