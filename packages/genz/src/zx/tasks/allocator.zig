const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

/// Which functions start tasks, themselves or through the functions they call.
pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const result = try allocator.alloc(bool, program.functions.count());

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        result[index] = uses(function.expressions, result[0..index]);
    }

    return result;
}

/// Whether the entry body needs the task allocator, given `functions` of the same program.
pub fn required(program: ir.Program, task_functions: []const bool) bool {
    return uses(program.expressions, task_functions);
}

fn uses(expressions: ir.ExpressionTable, task_functions: []const bool) bool {
    for (0..expressions.count()) |expression_index| {
        if (expressions.concurrent(expression_index)) return true;
        if (expressions.callee(expression_index)) |function| if (task_functions[@backingInt(function)]) return true;
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
