const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

/// Evaluation order of one function body: when each expression runs, which exclusive arm and which repeated body it sits in,
/// who consumes it, and where every symbol is defined.
pub const none = std.math.maxInt(u32);

/// `flow` hands the whole value to the parent, `member` places it at member `index` of the parent,
/// and `bind` names it as symbol `index`; the other roles end the value's path.
pub const Role = enum { observe, use, argument, evaluation, flow, member, bind };
pub const Edge = struct { parent: u32, child: ir.ExprId, role: Role, index: u32 = 0, region: u32 = 0 };
pub const Region = struct { parent: u32, fork: u32, arm: u32, depth: u32, returns: bool };
pub const Def = union(enum) { unknown, input, value: ir.ExprId, part: struct { value: ir.ExprId, index: u32 }, carried: ir.ExprId, condition: ir.ExprId, element };

expressions: ir.ExpressionTable,
time: []u32,
finish: []u32,
region: []u32,
loop: []u32,
regions: std.ArrayList(Region) = .empty,
edges: std.ArrayList(Edge) = .empty,
defs: []Def,
def_loop: []u32,
results: std.ArrayList(ir.ExprId) = .empty,
repeated: std.ArrayList(ir.ExprId) = .empty,
repeated_parent: std.ArrayList(u32) = .empty,
concurrent: std.ArrayList(bool) = .empty,
clock: u32 = 0,
forks: u32 = 0,
current_region: u32 = 0,
current_loop: u32 = none,
allocator: std.mem.Allocator,
pub fn create(allocator: std.mem.Allocator, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.Block) std.mem.Allocator.Error!Self {
    const count = expressions.count();
    var self = Self{
        .allocator = allocator,
        .expressions = expressions,
        .time = try allocator.alloc(u32, count),
        .finish = try allocator.alloc(u32, count),
        .region = try allocator.alloc(u32, count),
        .loop = try allocator.alloc(u32, count),
        .defs = try allocator.alloc(Def, symbols.count()),
        .def_loop = try allocator.alloc(u32, symbols.count()),
    };

    @memset(self.time, none);
    @memset(self.finish, none);
    @memset(self.defs, .unknown);
    @memset(self.def_loop, none);

    if (symbols.count() != 0) self.defs[0] = .input;

    try self.regions.append(allocator, .{ .parent = none, .fork = none, .arm = 0, .depth = 0, .returns = false });
    try self.block(body);

    return self;
}

/// Exclusive when the two expressions sit in different arms of the same branching construct, or when the earlier one
/// sits in an arm that returns before the later one runs.
pub fn exclusive(self: Self, left: ir.ExprId, right: ir.ExprId) bool {
    return self.apart(self.region[@backingInt(left)], self.time[@backingInt(left)], self.region[@backingInt(right)], self.time[@backingInt(right)]);
}

pub fn apart(self: Self, left: u32, left_time: u32, right: u32, right_time: u32) bool {
    var a = left;
    var b = right;
    var a_returns = false;
    var b_returns = false;
    const regions = self.regions.items;

    while (regions[a].depth > regions[b].depth) : (a = regions[a].parent) a_returns = a_returns or regions[a].returns;
    while (regions[b].depth > regions[a].depth) : (b = regions[b].parent) b_returns = b_returns or regions[b].returns;

    while (a != b and regions[a].parent != regions[b].parent) {
        a_returns = a_returns or regions[a].returns;
        b_returns = b_returns or regions[b].returns;
        a = regions[a].parent;
        b = regions[b].parent;
    }

    if (a != b) {
        if (regions[a].fork == regions[b].fork and regions[a].arm != regions[b].arm) return true;

        a_returns = a_returns or regions[a].returns;
        b_returns = b_returns or regions[b].returns;
    }

    return if (left_time < right_time) a_returns else b_returns;
}

fn block(self: *Self, statements: ir.Block) std.mem.Allocator.Error!void {
    for (0..statements.len) |index| switch (statements.at(index)) {
        .evaluate => |id| try self.operand(none, id, .observe),
        .constant => |binding| {
            try self.operandAt(none, binding.value, .bind, @backingInt(binding.symbol));
            self.define(binding.symbol, .{ .value = binding.value });
        },
        .parallel => |invocations| for (0..invocations.len) |item| {
            try self.repeat(none, @fromBackingInt(invocations.values[item]), .use);
        },
        .destructure => |binding| {
            try self.operand(none, binding.value, .use);

            for (0..binding.symbols.len) |item| if (binding.symbols.at(item)) |symbol| self.define(symbol, .{ .part = .{ .value = binding.value, .index = @intCast(item) } });
        },
        .branch => |branch| {
            try self.operand(none, branch.condition, .observe);

            const fork_id = self.split();
            try self.arm(fork_id, 0, branch.yes);
            try self.arm(fork_id, 1, branch.no);
        },
        .switch_stmt => |selection| {
            try self.operand(none, selection.subject, .observe);

            for (0..selection.cases.len) |item| if (selection.cases.at(item).value) |value| try self.operand(none, value, .observe);

            const fork_id = self.split();

            for (0..selection.cases.len) |item| try self.arm(fork_id, @intCast(item), selection.cases.at(item).body);
        },
        .store_set => |setter| try self.operand(none, setter.value, .use),
        .result => |value| if (value) |id| {
            try self.operand(none, id, .use);
            try self.results.append(self.allocator, id);
        },
    };
}

fn arm(self: *Self, fork_id: u32, index: u32, statements: ir.Block) std.mem.Allocator.Error!void {
    const saved = self.current_region;

    self.current_region = try self.enter(fork_id, index);
    self.regions.items[self.current_region].returns = ir.terminates(statements);

    defer self.current_region = saved;

    try self.block(statements);
}

/// Enters a repeated body; tasks and parallel branches run concurrently with the code around them.
fn open(self: *Self, owner: ir.ExprId, concurrent: bool) std.mem.Allocator.Error!u32 {
    const saved = self.current_loop;

    self.current_loop = @intCast(self.repeated.items.len);

    try self.repeated.append(self.allocator, owner);
    try self.repeated_parent.append(self.allocator, saved);
    try self.concurrent.append(self.allocator, concurrent);

    return saved;
}

/// Whether a value defined in loop `outer` reaches a read in loop `inner` across a concurrent body.
pub fn crossesConcurrent(self: Self, inner: u32, outer: u32) bool {
    var loop = inner;

    while (loop != none and loop != outer) : (loop = self.repeated_parent.items[loop]) {
        if (self.concurrent.items[loop]) return true;
    }

    return false;
}

fn split(self: *Self) u32 {
    self.forks += 1;

    return self.forks;
}

fn enter(self: *Self, fork_id: u32, index: u32) std.mem.Allocator.Error!u32 {
    const parent = self.current_region;

    try self.regions.append(self.allocator, .{ .parent = parent, .fork = fork_id, .arm = index, .depth = self.regions.items[parent].depth + 1, .returns = false });

    return @intCast(self.regions.items.len - 1);
}

fn define(self: *Self, symbol: ir.SymbolId, def: Def) void {
    self.defs[@backingInt(symbol)] = def;
    self.def_loop[@backingInt(symbol)] = self.current_loop;
}

fn operand(self: *Self, parent: u32, child: ir.ExprId, role: Role) std.mem.Allocator.Error!void {
    return self.operandAt(parent, child, role, 0);
}

fn operandAt(self: *Self, parent: u32, child: ir.ExprId, role: Role, index: u32) std.mem.Allocator.Error!void {
    try self.edges.append(self.allocator, .{ .parent = parent, .child = child, .role = role, .index = index, .region = self.current_region });

    if (self.time[@backingInt(child)] != none) return;

    try self.visit(child);
}

/// Visits a child that runs once per iteration or task, inside its own repeated body.
fn repeat(self: *Self, parent: u32, child: ir.ExprId, role: Role) std.mem.Allocator.Error!void {
    const saved = try self.open(if (parent == none) child else @fromBackingInt(parent), true);

    defer self.current_loop = saved;

    try self.operand(parent, child, role);
}

fn visit(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!void {
    const index = @backingInt(id);
    const parent: u32 = index;

    self.time[index] = self.clock;
    self.region[index] = self.current_region;
    self.loop[index] = self.current_loop;
    self.clock += 1;

    switch (self.expressions.get(id).value) {
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value, .reference, .store_get => {},
        .some => |child| try self.operand(parent, child, .flow),
        .optional_value, .capture, .await_task, .cancel_task => |child| try self.operand(parent, child, .use),
        .length => |child| try self.operand(parent, child, .observe),
        .task => |task| try self.repeat(parent, task.body, .use),
        .parallel => |branches| for (0..branches.len) |item| try self.repeat(parent, branches.at(item).task, .use),
        .field, .tuple_field => |projection| try self.operand(parent, projection.target, .use),
        .index => |item| {
            try self.operand(parent, item.target, .observe);
            try self.operand(parent, item.index, .observe);
        },
        .list => |items| for (items) |item| try self.operand(parent, item, .use),
        .tuple => |items| for (items, 0..) |item, position| try self.operandAt(parent, item, .member, @intCast(position)),
        .template => |items| for (items) |item| try self.operand(parent, item, .observe),
        .list_operation => |operation| {
            try self.operand(parent, operation.target, .use);

            for (operation.arguments) |argument| try self.operand(parent, argument, if (operation.kind == .push) .use else .observe);
        },
        .transform => |transform| {
            try self.operand(parent, transform.target, .observe);

            if (transform.initial) |initial| try self.operand(parent, initial, .use);

            const saved = try self.open(id, false);

            defer self.current_loop = saved;

            for (transform.parameters, 0..) |symbol, position| self.define(symbol, if (transform.kind == .reduce and position == 0) .{ .carried = id } else .element);

            try self.operand(parent, transform.body, .use);
        },
        .scope => |scope| {
            for (0..scope.bindings.len) |item| {
                const binding = scope.bindings.at(item);

                if (binding.symbol) |symbol| try self.operandAt(parent, binding.value, .bind, @backingInt(symbol)) else try self.operand(parent, binding.value, .use);

                if (binding.symbol) |symbol| self.define(symbol, .{ .value = binding.value });
            }

            try self.operand(parent, scope.result, .flow);
        },
        .iteration => |iteration| {
            try self.operand(parent, iteration.initial, .use);

            const saved = try self.open(id, false);

            defer self.current_loop = saved;

            self.define(iteration.condition_parameter, .{ .condition = id });
            self.define(iteration.parameter, .{ .carried = id });

            if (iteration.postcondition) {
                try self.operand(parent, iteration.body, .use);
                try self.operand(parent, iteration.condition, .observe);
            } else {
                try self.operand(parent, iteration.condition, .observe);
                try self.operand(parent, iteration.body, .use);
            }
        },
        .list_update => |update| {
            try self.operand(parent, update.target, .use);
            try self.operand(parent, update.index, .observe);
            try self.operand(parent, update.value, .use);
        },
        .call => |invocation| try self.operand(parent, invocation.argument, .argument),
        .unary => |unary| try self.operand(parent, unary.operand, .observe),
        .binary => |binary| {
            try self.operand(parent, binary.left, .observe);
            try self.operand(parent, binary.right, .observe);
        },
        .conditional => |conditional| {
            try self.operand(parent, conditional.condition, .observe);

            const fork_id = self.split();

            try self.alternative(parent, fork_id, 0, conditional.yes);
            try self.alternative(parent, fork_id, 1, conditional.no);
        },
        .match_expr => |selection| {
            if (selection.subject) |subject| try self.operand(parent, subject, .observe);

            for (0..selection.arms.len) |item| try self.operand(parent, selection.arms.at(item).condition, .observe);

            const fork_id = self.split();

            for (0..selection.arms.len) |item| try self.alternative(parent, fork_id, @intCast(item), selection.arms.at(item).result);
            try self.alternative(parent, fork_id, @intCast(selection.arms.len), selection.fallback);
        },
        .object => |object| {
            for (object.evaluation) |item| try self.operand(parent, item, .evaluation);
            for (0..object.fields.len) |item| try self.operandAt(parent, object.fields.at(item).value, .member, object.fields.at(item).index);
        },
    }

    self.finish[index] = self.clock;
}

fn alternative(self: *Self, parent: u32, fork_id: u32, index: u32, child: ir.ExprId) std.mem.Allocator.Error!void {
    const saved = self.current_region;

    self.current_region = try self.enter(fork_id, index);

    defer self.current_region = saved;

    try self.operand(parent, child, .flow);
}
