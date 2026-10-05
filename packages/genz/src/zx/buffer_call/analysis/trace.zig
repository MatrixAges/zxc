const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("flow.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
function: ir.Function,
summaries: []const []const flow.Lane,
bindings: []?ir.ExprId,
results: std.ArrayList(ir.ExprId) = .empty,
appends: std.ArrayList(ir.ExprId) = .empty,
calls: std.ArrayList(flow.Call) = .empty,
pub fn init(allocator: std.mem.Allocator, program: ir.Program, function: ir.Function, summaries: []const []const flow.Lane) Error!Self {
    var self = Self{ .allocator = allocator, .program = program, .function = function, .summaries = summaries, .bindings = try allocator.alloc(?ir.ExprId, function.symbols.len) };

    @memset(self.bindings, null);

    try self.block(function.body);

    for (function.expressions) |expression| if (expression.value == .scope) {
        for (expression.value.scope.bindings) |binding| if (binding.symbol) |symbol| {
            self.bindings[@backingInt(symbol)] = binding.value;
        };
    };

    return self;
}

pub fn lane(self: *Self, output: []const u32) Error!?flow.Lane {
    self.appends.clearRetainingCapacity();
    self.calls.clearRetainingCapacity();

    var input: ?[]const u32 = null;

    for (self.results.items) |result| {
        const origin = try self.trace(result, output) orelse return null;

        if (input) |previous| {
            if (!std.mem.eql(u32, previous, origin)) return null;
        } else input = origin;
    }

    return .{
        .input = input orelse return null,
        .output = output,
        .appends = try self.allocator.dupe(ir.ExprId, self.appends.items),
        .calls = try self.allocator.dupe(flow.Call, self.calls.items),
    };
}

fn block(self: *Self, statements: []const ir.Statement) Error!void {
    for (statements) |statement| switch (statement) {
        .constant => |binding| self.bindings[@backingInt(binding.symbol)] = binding.value,
        .result => |value| if (value) |id| {
            try self.results.append(self.allocator, id);
        },
        .branch => |branch| {
            try self.block(branch.yes);
            try self.block(branch.no);
        },
        .switch_stmt => |selection| for (selection.cases) |case| {
            try self.block(case.body);
        },
        else => {},
    };
}

pub fn trace(self: *Self, id: ir.ExprId, path: []const u32) Error!?[]const u32 {
    const expression = self.function.expressions[@backingInt(id)];

    return switch (expression.value) {
        .reference => |symbol| if (@backingInt(symbol) == 0)
            path
        else if (self.bindings[@backingInt(symbol)]) |binding|
            self.trace(binding, path)
        else
            null,
        .field, .tuple_field => |projection| blk: {
            const target = self.function.expressions[@backingInt(projection.target)].value;

            if (target == .list_operation) {
                const operation = target.list_operation;

                if (path.len != 0 or projection.index != 0 or (operation.kind != .push and operation.kind != .concat)) break :blk null;
                if (std.mem.indexOfScalar(ir.ExprId, self.appends.items, id) == null) try self.appends.append(self.allocator, id);

                break :blk try self.trace(operation.target, &.{});
            }

            const selected = try self.allocator.alloc(u32, path.len + 1);

            selected[0] = projection.index;

            @memcpy(selected[1..], path);

            break :blk try self.trace(projection.target, selected);
        },
        .object => |object| blk: {
            if (path.len == 0) break :blk null;

            for (object.fields) |field| {
                if (field.index == path[0]) break :blk try self.trace(field.value, path[1..]);
            }

            break :blk null;
        },
        .tuple => |items| if (path.len != 0 and path[0] < items.len) self.trace(items[path[0]], path[1..]) else null,
        .conditional => |value| self.join(value.yes, value.no, path),
        .match_expr => |value| blk: {
            const origin = try self.trace(value.fallback, path) orelse break :blk null;

            for (value.arms) |arm| {
                const next = try self.trace(arm.result, path) orelse break :blk null;

                if (!std.mem.eql(u32, origin, next)) break :blk null;
            }

            break :blk origin;
        },
        .call => |call| blk: {
            const index = @backingInt(call.function);

            if (index >= self.summaries.len) break :blk null;

            for (self.summaries[index], 0..) |summary, lane_index| {
                if (!std.mem.eql(u32, summary.output, path)) continue;

                const duplicate = for (self.calls.items) |saved| {
                    if (saved.expression == id and saved.lane == lane_index) break true;
                } else false;

                if (!duplicate) try self.calls.append(self.allocator, .{ .expression = id, .lane = lane_index });

                break :blk try self.trace(call.argument, summary.input);
            }

            break :blk null;
        },
        else => null,
    };
}

fn join(self: *Self, yes: ir.ExprId, no: ir.ExprId, path: []const u32) Error!?[]const u32 {
    const left = try self.trace(yes, path) orelse return null;
    const right = try self.trace(no, path) orelse return null;

    return if (std.mem.eql(u32, left, right)) left else null;
}
