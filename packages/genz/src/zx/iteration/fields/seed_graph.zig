const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

allocator: std.mem.Allocator,
expressions: ir.ExpressionTable,
type_id: ir.TypeId,
seen: []bool,
states: []bool,
symbols: []bool,
valid: bool = true,
pending: std.ArrayList(ir.ExprId) = .empty,
/// Source fields/graph forwarding rules; whole-state uses cannot escape the loop representation.
pub fn visit(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!void {
    try self.pending.append(self.allocator, id);

    while (self.valid) {
        const next = self.pending.pop() orelse break;

        try self.node(next);
    }
}

fn node(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!void {
    const index = @backingInt(id);

    if (!self.valid or self.seen[index]) return;

    self.seen[index] = true;

    const expression = self.expressions.get(id);

    self.states[index] = expression.type_id == self.type_id;

    switch (expression.value) {
        .task, .capture, .parallel, .iteration => self.valid = false,
        .reference => |symbol| if (self.states[index]) {
            self.symbols[@backingInt(symbol)] = true;
        },
        .field => |field| try self.edge(field.target, true),
        .scope => |scope| {
            for (0..scope.bindings.len) |item| try self.edge(scope.bindings.at(item).value, true);
            try self.edge(scope.result, true);
        },
        .object => |object| {
            for (0..object.fields.len) |item| try self.edge(object.fields.at(item).value, false);
            for (object.evaluation) |item| try self.edge(item, true);
        },
        .conditional => |choice| {
            try self.edge(choice.condition, false);
            try self.edge(choice.yes, true);
            try self.edge(choice.no, true);
        },
        .match_expr => |choice| {
            if (choice.subject) |subject| try self.edge(subject, false);

            for (0..choice.arms.len) |item| {
                const arm = choice.arms.at(item);

                try self.edge(arm.condition, false);
                try self.edge(arm.result, true);
            }

            try self.edge(choice.fallback, true);
        },
        inline else => |payload| try self.operands(payload),
    }
}

fn edge(self: *Self, id: ir.ExprId, forwarded: bool) std.mem.Allocator.Error!void {
    if (self.expressions.get(id).type_id == self.type_id and !forwarded) self.valid = false;
    if (self.valid) try self.pending.append(self.allocator, id);
}

fn operands(self: *Self, value: anytype) std.mem.Allocator.Error!void {
    const T = @TypeOf(value);

    if (T == ir.ExprId) return self.edge(value, false);

    switch (@typeInfo(T)) {
        .@"struct" => inline for (@typeInfo(T).@"struct".field_names) |name| try self.operands(@field(value, name)),
        .optional => if (value) |child| try self.operands(child),
        .pointer => |pointer| if (pointer.size == .slice and pointer.child == ir.ExprId) {
            for (value) |child| try self.edge(child, false);
        },
        else => {},
    }
}
