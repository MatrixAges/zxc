const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const lists = @import("../state_value/list.zig");
const functions = @import("functions.zig");

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!node.ExpressionId {
    const slot = self.task_declarations.items.len;
    const name = try std.fmt.allocPrint(self.allocator, "zx_sort_worker_{d}", .{slot});

    try self.task_declarations.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.builder.expression(.undefined_value) } });

    const list_type = self.program.expression(value.target).type_id;
    const child = try @import("../state_value/elements.zig").typeExpr(self, list_type);
    const errors = try zx.error_effects.expressionWith(self.allocator, self.program.types, self.program.functions, self.program.expressions, id, self.function_errors);
    const worker = try @import("worker.zig").build(self, value, child, errors);
    const declarations = try self.allocator.dupe(node.Declaration, &.{ worker.declaration, try functions.less(self, child), try functions.sort(self, child, errors) });
    self.task_declarations.items[slot] = .{ .constant = .{ .name = name, .value = try self.builder.expression(.{ .namespace_type = declarations }) } };
    self.uses_allocator = true;
    self.uses_io = self.uses_io or worker.io;
    self.uses_process = self.uses_process or worker.process;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try lists.expression(self, value.target));
    const environment = try aggregate.bind(self, &body, try self.expr(value.initial.?));
    var fields: std.ArrayList(node.Field) = .empty;

    try fields.appendSlice(self.allocator, &.{
        .{ .name = "allocator", .value = try self.builder.identifier("allocator") },
        .{ .name = "environment", .value = environment },
        .{ .name = "failure", .value = try self.cast(try self.builder.expression(.{ .optional_type = try self.builder.expression(if (errors) |names| .{ .error_set = names } else .{ .primitive = .anyerror }) }), try self.builder.expression(.null_value)) },
    });

    if (worker.io) try fields.append(self.allocator, .{ .name = "io", .value = try self.builder.identifier("io") });
    if (worker.process) try fields.append(self.allocator, .{ .name = "process", .value = try self.builder.identifier("process") });

    const context_name = try self.fresh("sort_context");
    const context_fields = try self.allocator.alloc(node.Field, fields.items.len);

    for (fields.items, context_fields) |field, *target| target.* = .{ .name = field.name, .value = try self.builtin(.TypeOf, &.{field.value}) };

    const context_type = try self.builder.expression(.{ .struct_type = context_fields });

    try body.append(self.allocator, .{ .variable = .{ .name = context_name, .type_expr = context_type, .value = try self.builder.expression(.{ .object = .{ .fields = try fields.toOwnedSlice(self.allocator) } }) } });

    const result = try self.call(try self.field(try self.builder.identifier(name), "sort"), &.{ try self.builder.expression(.{ .address_of = try self.builder.identifier(context_name) }), source }, true);

    return aggregate.finish(self, &body, try lists.owned(self, list_type, result, try self.builder.expression(.{ .boolean = false })));
}
