const std = @import("std");
const ir = @import("../ir.zig");
const Effects = @import("../error_effects.zig");

pub fn visit(self: *Effects, values: []const ir.Expression, value: ir.Expression) std.mem.Allocator.Error!void {
    switch (value.value) {
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value, .reference, .store_get => {},
        .capture => try self.add("OutOfMemory"),
        .some, .optional_value, .length => |child| try self.visit(values, child),
        .field, .tuple_field => |field| try self.visit(values, field.target),
        .index => |index| {
            try self.add("IndexOutOfBounds");
            try self.visit(values, index.target);
            try self.visit(values, index.index);
        },
        .list, .tuple, .template => |children| {
            try self.add("OutOfMemory");
            for (children) |child| try self.visit(values, child);
        },
        .object => |object| {
            try self.add("OutOfMemory");
            for (object.evaluation) |child| try self.visit(values, child);
            for (object.fields) |field| try self.visit(values, field.value);
        },
        .list_operation => |operation| {
            try self.add("OutOfMemory");

            if (operation.kind == .push or operation.kind == .concat or operation.kind == .splice) try self.add("Overflow");
            if (operation.kind == .splice) try self.add("IndexOutOfBounds");
            try self.visit(values, operation.target);
            for (operation.arguments) |argument| try self.visit(values, argument);
        },
        .transform => |transform| {
            if (transform.kind != .reduce) try self.add("OutOfMemory");
            try self.visit(values, transform.target);
            try self.visit(values, transform.body);
            if (transform.initial) |initial| try self.visit(values, initial);
        },
        .scope => |scope| {
            for (scope.bindings) |binding| try self.visit(values, binding.value);
            try self.visit(values, scope.result);
        },
        .iteration => |iteration| {
            const target = self.types[@backingInt(value.type_id)];

            if (target == .object or target == .tuple) try self.add("OutOfMemory");
            try self.visit(values, iteration.initial);
            try self.visit(values, iteration.condition);
            try self.visit(values, iteration.body);
        },
        .list_update => |update| {
            try self.add("OutOfMemory");
            try self.add("IndexOutOfBounds");
            try self.visit(values, update.target);
            try self.visit(values, update.index);
            try self.visit(values, update.value);
        },
        .call => |call| {
            try self.visit(values, call.argument);
            try self.call(call.function);
        },
        .unary => |unary| try self.visit(values, unary.operand),
        .binary => |binary| {
            try self.visit(values, binary.left);
            try self.visit(values, binary.right);
        },
        .conditional => |conditional| {
            try self.visit(values, conditional.condition);
            try self.visit(values, conditional.yes);
            try self.visit(values, conditional.no);
        },
        .match_expr => |match| {
            if (match.subject) |subject| try self.visit(values, subject);

            for (match.arms) |arm| {
                try self.visit(values, arm.condition);
                try self.visit(values, arm.result);
            }

            try self.visit(values, match.fallback);
        },
    }
}
