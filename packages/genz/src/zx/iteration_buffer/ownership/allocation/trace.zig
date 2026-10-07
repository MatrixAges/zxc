const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();
const Assumption = struct { symbol: ir.SymbolId, path: []const usize };
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
bindings: []const ?ir.ExprId,
functions: []const bool,
assumptions: std.ArrayList(Assumption) = .empty,
pub fn check(self: *Self, id: ir.ExprId, path: []const usize, depth: usize) Error!bool {
    if (depth > self.program.expressions.count()) return false;

    return switch (self.program.expression(id).value) {
        .list => path.len == 0,
        .reference => |symbol| blk: {
            for (self.assumptions.items) |assumption| {
                if (assumption.symbol == symbol) break :blk std.mem.eql(usize, assumption.path, path);
            }

            break :blk if (self.bindings[@backingInt(symbol)]) |binding| try self.check(binding, path, depth + 1) else false;
        },
        .field, .tuple_field => |field| blk: {
            const selected = try self.allocator.alloc(usize, path.len + 1);

            selected[0] = field.index;

            @memcpy(selected[1..], path);

            break :blk try self.check(field.target, selected, depth + 1);
        },
        .object => |object| blk: {
            if (path.len == 0) break :blk false;

            for (0..object.fields.len) |index| {
                const field = object.fields.at(index);

                if (field.index == path[0]) break :blk try self.check(field.value, path[1..], depth + 1);
            }

            break :blk false;
        },
        .tuple => |items| if (path.len != 0 and path[0] < items.len) try self.check(items[path[0]], path[1..], depth + 1) else false,
        .scope => |scope| self.check(scope.result, path, depth + 1),
        .conditional => |branch| try self.check(branch.yes, path, depth + 1) and try self.check(branch.no, path, depth + 1),
        .match_expr => |selection| blk: {
            if (!try self.check(selection.fallback, path, depth + 1)) break :blk false;

            for (0..selection.arms.len) |index| {
                if (!try self.check(selection.arms.at(index).result, path, depth + 1)) break :blk false;
            }

            break :blk true;
        },
        .transform => |transform| path.len == 0 and (transform.kind == .map or transform.kind == .filter),
        .list_update => |update| path.len == 0 and try self.check(update.target, &.{}, depth + 1),
        .list_operation => |operation| path.len == 1 and path[0] == 0 and
            (operation.kind == .push or operation.kind == .concat) and try self.check(operation.target, &.{}, depth + 1),
        .call => |call| path.len == 0 and @backingInt(call.function) < self.functions.len and self.functions[@backingInt(call.function)],
        .iteration => |iteration| blk: {
            if (!try self.check(iteration.initial, path, depth + 1)) break :blk false;

            try self.assumptions.append(self.allocator, .{ .symbol = iteration.parameter, .path = path });

            defer _ = self.assumptions.pop();

            break :blk try self.check(iteration.body, path, depth + 1);
        },
        else => false,
    };
}
