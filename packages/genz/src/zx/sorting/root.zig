const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const lists = @import("../state_value/list.zig");
const functions = @import("functions.zig");
const intrinsic = @import("../intrinsics.zig");

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!node.ExpressionId {
    const slot = self.task_declarations.count();
    const name = try std.fmt.allocPrint(self.allocator, "zx_sort_worker_{d}", .{slot});

    try self.task_declarations.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.builder.expression(.undefined_value) } });

    const list_type = self.program.expression(value.target).type_id;
    const child = try @import("../state_value/elements.zig").typeExpr(self, list_type);
    const errors = try @import("../error_effects.zig").expression(self, id);
    const worker = try @import("worker.zig").build(self, value, child, errors);
    const helpers = try functions.build(self, child, errors);
    const declarations = try self.allocator.dupe(node.Declaration, &.{ worker.declaration, helpers[0], helpers[1] });

    try self.task_declarations.replace(self.allocator, slot, .{ .constant = .{ .name = name, .value = try self.builder.expression(.{ .namespace_type = declarations }) } });

    self.uses_allocator = true;
    self.uses_io = self.uses_io or worker.io;
    self.uses_process = self.uses_process or worker.process;

    var body: std.ArrayList(node.Statement) = .empty;
    const evaluated = try self.expr(value.target);
    const qualified = if (lists.selected(self, list_type)) try @import("../state_value/ownership.zig").clip(self, &body, value.target, evaluated) else evaluated;
    const source_value = try aggregate.bind(self, &body, qualified);
    const source = try lists.items(self, list_type, source_value);

    const reuse = try aggregate.bind(self, &body, if (self.plan.get(id).in_place)
        try self.builder.expression(.{ .boolean = true })
    else if (lists.selected(self, list_type))
        try lists.writable(self, source_value)
    else
        try self.builder.expression(.{ .boolean = false }));
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

    const result = try self.call(try self.field(try self.builder.identifier(name), "sort"), &.{ try self.builder.expression(.{ .address_of = try self.builder.identifier(context_name) }), source, reuse }, true);
    const headered = if (lists.selected(self, list_type)) try intrinsic.binary(self, .logical_and, reuse, try lists.headered(self, source_value)) else try self.builder.expression(.{ .boolean = false });

    return aggregate.finish(self, &body, try lists.owned(self, list_type, result, headered));
}
