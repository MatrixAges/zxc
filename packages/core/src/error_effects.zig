const std = @import("std");
const ir = @import("ir.zig");
const Self = @This();

allocator: std.mem.Allocator,
types: ir.TypeTable,
functions: ir.FunctionTable,
/// Distinct names in the order first raised; a body raises few, mostly the same literals.
names: std.ArrayList([]const u8) = .empty,
/// The table of the body analyzed, whose expressions are marked in `seen`; other tables are marked in `visited`.
home: ?ir.ExpressionTable = null,
seen: std.DynamicBitSetUnmanaged = .{},
visited: std.AutoHashMapUnmanaged(usize, void) = .empty,
called: std.AutoHashMapUnmanaged(ir.FunctionId, void) = .empty,
unknown: bool = false,
/// The error set of every function, null where unknown: a call then joins the callee's set instead of visiting it.
known: ?[]const ?[]const []const u8 = null,
/// Collects the source functions a body calls instead of visiting them.
callees: ?*std.ArrayList(ir.FunctionId) = null,
pub fn program(allocator: std.mem.Allocator, value: ir.Program) std.mem.Allocator.Error!?[]const []const u8 {
    return programWith(allocator, value, null);
}

/// The errors `value`'s body raises, joining the sets in `known` at calls when given.
pub fn programWith(allocator: std.mem.Allocator, value: ir.Program, known: ?[]const ?[]const []const u8) std.mem.Allocator.Error!?[]const []const u8 {
    var self = Self{ .allocator = allocator, .types = value.types, .functions = value.functions, .known = known };

    defer self.deinit();

    try self.enter(value.expressions);
    if (value.stores.count() != 0) self.unknown = true;
    try self.contracts(value.contracts);
    try self.statements(value.expressions, value.body.block());

    return self.finish();
}

pub fn expression(allocator: std.mem.Allocator, types: ir.TypeTable, functions: ir.FunctionTable, values: ir.ExpressionTable, id: ir.ExprId) std.mem.Allocator.Error!?[]const []const u8 {
    var self = Self{ .allocator = allocator, .types = types, .functions = functions };

    defer self.deinit();

    try self.enter(values);
    try self.visit(values, id);

    return self.finish();
}

/// The error set of every function at once; see `error_effects/functions.zig`.
pub const perFunction = @import("error_effects/functions.zig").all;

pub fn deinit(self: *Self) void {
    self.names.deinit(self.allocator);
    self.seen.deinit(self.allocator);
    self.visited.deinit(self.allocator);
    self.called.deinit(self.allocator);
}

pub fn finish(self: *Self) std.mem.Allocator.Error!?[]const []const u8 {
    if (self.unknown) return null;

    const result = try self.allocator.dupe([]const u8, self.names.items);

    std.mem.sort([]const u8, result, {}, lessThan);

    return result;
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}

pub fn add(self: *Self, name: []const u8) std.mem.Allocator.Error!void {
    for (self.names.items) |existing| {
        if (existing.ptr == name.ptr and existing.len == name.len) return;
        if (std.mem.eql(u8, existing, name)) return;
    }

    try self.names.append(self.allocator, name);
}

pub fn visit(self: *Self, values: ir.ExpressionTable, id: ir.ExprId) std.mem.Allocator.Error!void {
    const index = @backingInt(id);

    if (self.home != null and values.kinds.ptr == self.home.?.kinds.ptr) {
        if (self.seen.isSet(index)) return;

        self.seen.set(index);
    } else if ((try self.visited.getOrPut(self.allocator, @intFromPtr(&values.kinds[index]))).found_existing) return;

    try @import("error_effects/expression.zig").visit(self, values, values.get(id));
}

/// Marks the expressions of `values` by index from now on, unless a body's table is marked already.
fn enter(self: *Self, values: ir.ExpressionTable) std.mem.Allocator.Error!void {
    if (self.home != null) return;

    self.home = values;
    self.seen = try .initEmpty(self.allocator, values.count());
}

pub fn call(self: *Self, id: ir.FunctionId) std.mem.Allocator.Error!void {
    const entry = try self.called.getOrPut(self.allocator, id);

    if (entry.found_existing) return;

    const function = self.functions.at(@backingInt(id));

    if (function.external) |external| {
        if (!external.fallible) return;

        if (external.errors) |errors| {
            for (errors) |name| try self.add(name);
        } else self.unknown = true;

        return;
    }

    if (self.known) |known| {
        if (known[@backingInt(id)]) |names| {
            for (names) |name| try self.add(name);
        } else self.unknown = true;

        return;
    }

    if (self.callees) |list| return list.append(self.allocator, id);

    try self.raises(function);
}

/// What one source function's own body raises.
pub fn raises(self: *Self, function: ir.Function) std.mem.Allocator.Error!void {
    try self.enter(function.expressions);
    if (function.stores.count() != 0) self.unknown = true;
    try self.contracts(function.contracts);
    try self.statements(function.expressions, function.body.block());
}

fn contracts(self: *Self, values: ir.ContractTable) std.mem.Allocator.Error!void {
    for (0..values.count()) |contract_index| {
        const contract = values.at(contract_index);

        if (contract.kind != .requires) continue;
        try self.add("PreconditionFailed");
        try self.visit(contract.expressions, contract.predicate);
    }
}

fn statements(self: *Self, values: ir.ExpressionTable, body: ir.Block) std.mem.Allocator.Error!void {
    for (0..body.len) |statement_index| {
        const statement = body.at(statement_index);

        switch (statement) {
            .evaluate => |id| try self.visit(values, id),
            .constant => |binding| try self.visit(values, binding.value),
            .destructure => |binding| if (values.at(@backingInt(binding.value)).value != .capture) try self.visit(values, binding.value),
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

                for (0..calls.len) |invocation_index| {
                    const invocation = calls.at(invocation_index);

                    try self.visit(values, invocation.value);
                }
            },
            .branch => |branch| {
                try self.visit(values, branch.condition);
                try self.statements(values, branch.yes);
                try self.statements(values, branch.no);
            },
            .switch_stmt => |selection| {
                try self.visit(values, selection.subject);

                for (0..selection.cases.len) |case_index| {
                    const case = selection.cases.at(case_index);

                    if (case.value) |id| try self.visit(values, id);
                    try self.statements(values, case.body);
                }
            },
        }

        if (ir.terminates(.{ .control = body.control, .first = body.first + statement_index, .len = 1 })) return;
    }
}
