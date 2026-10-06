const std = @import("std");
const ast = @import("zx").ast;
const Self = @This();
const Error = std.mem.Allocator.Error;
pub const Candidate = struct { expression: *const ast.Expression, nested: bool = false };

allocator: std.mem.Allocator,
items: std.ArrayList(Candidate) = .empty,
pub fn program(self: *Self, value: ast.Program) Error!void {
    for (value.contracts) |contract| try self.expression(contract.predicate, null);
    if (value.body) |body| try self.block(body);
}

fn block(self: *Self, body: ast.Block) Error!void {
    for (body.statements) |statement| switch (statement.value) {
        .constant => |binding| try self.expression(binding.value, null),
        .destructure => |binding| try self.expression(binding.value, null),
        .evaluate => |value| try self.expression(value, null),
        .result => |value| if (value) |item| try self.expression(item, null),
        .state_update => |value| {
            try self.expression(value.target, null);
            try self.expression(value.value, null);
        },
        .store_set => |value| {
            try self.expression(value.target, null);
            try self.expression(value.value, null);
        },
        .branch => |branch| {
            try self.expression(branch.condition, null);
            try self.block(branch.yes);
            if (branch.no) |no| try self.block(no);
        },
        .switch_stmt => |selection| {
            try self.expression(selection.subject, null);

            for (selection.cases) |case| {
                if (case.value) |value| try self.expression(value, null);
                try self.block(case.body);
            }
        },
    };
}

pub fn expression(self: *Self, value: *const ast.Expression, outer: ?usize) Error!void {
    switch (value.value) {
        .conditional => |choice| {
            const index = self.items.items.len;

            try self.items.append(self.allocator, .{ .expression = value, .nested = outer != null });
            if (outer) |parent| self.items.items[parent].nested = true;
            try self.expression(choice.condition, index);
            try self.expression(choice.yes, index);
            try self.expression(choice.no, index);
        },
        .lambda => |lambda| try self.expression(lambda.body, null),
        .state_block => |body| try self.block(body),
        .field => |field| try self.expression(field.target, outer),
        .index => |item| {
            try self.expression(item.target, outer);
            try self.expression(item.index, outer);
        },
        .capture, .task, .await_task, .cancel_task => |child| try self.expression(child, outer),
        .unary => |unary| try self.expression(unary.operand, outer),
        .binary => |binary| {
            try self.expression(binary.left, outer);
            try self.expression(binary.right, outer);
        },
        .match_expr => |selection| {
            if (selection.subject) |subject| try self.expression(subject, outer);

            for (selection.arms) |arm| {
                try self.expression(arm.condition, outer);
                try self.expression(arm.result, outer);
            }

            try self.expression(selection.fallback, outer);
        },
        .object => |fields| for (fields) |field| try self.expression(field.value, outer),
        .list => |items| for (items) |item| try self.expression(item, outer),
        .call => |call| {
            try self.expression(call.callee, outer);
            for (call.arguments) |argument| try self.expression(argument, outer);
        },
        .template => |parts| for (parts) |part| {
            if (part == .expression) try self.expression(part.expression, outer);
        },
        else => {},
    }
}
