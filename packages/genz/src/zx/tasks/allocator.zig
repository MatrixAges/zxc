const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn required(allocator: std.mem.Allocator, program: ir.Program) Lower.Error!bool {
    const functions = try allocator.alloc(bool, program.functions.count());

    defer allocator.free(functions);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        functions[index] = uses(function.expressions, functions[0..index]);
    }

    return uses(program.expressions, functions);
}

fn uses(expressions: ir.ExpressionTable, functions: []const bool) bool {
    for (0..expressions.count()) |expression_index| {
        const expression = expressions.at(expression_index);

        switch (expression.value) {
            .task, .await_task, .cancel_task, .parallel => return true,
            .call => |call| if (functions[@backingInt(call.function)]) return true,
            else => {},
        }
    }

    return false;
}

pub fn initialize(self: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    const fields = try self.allocator.dupe(node.Field, &.{
        .{ .name = "child", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) },
        .{ .name = "io", .value = try self.builder.identifier("io") },
        .{ .name = "mutex", .value = try self.builder.expression(.{ .enum_literal = "init" }) },
    });

    try self.task_declarations.append(self.allocator, .{ .constant = .{ .name = "zx_task_allocator", .value = try @import("../allocator.zig").lower(self, true) } });
    try body.append(self.allocator, .{ .variable = .{ .name = "task_allocator", .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier("zx_task_allocator"), .fields = fields } }) } });
    try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("task_allocator"), "allocator"), &.{}, false) } });
}
