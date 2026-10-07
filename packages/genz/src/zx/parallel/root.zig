const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const standardField = @import("../intrinsics.zig").standardField;

pub fn lower(self: *Lower, invocations: @FieldType(ir.StatementRow, "parallel")) Lower.Error![]const node.Statement {
    self.uses_parallel = true;
    self.uses_allocator = true;

    var output: std.ArrayList(node.Statement) = .empty;
    var spawning: std.ArrayList(node.Statement) = .empty;
    const workers = try self.allocator.alloc([]const u8, invocations.len);
    const shared = try self.fresh("parallel_allocator");

    try output.append(self.allocator, .{ .variable = .{ .name = shared, .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier("zx_parallel_allocator"), .fields = try self.allocator.dupe(node.Field, &.{.{ .name = "child", .value = try self.builder.identifier("allocator") }}) } }) } });

    for (0..invocations.len, workers) |invocation_index, *worker| {
        const invocation = invocations.at(invocation_index);
        const call = self.program.expression(invocation.value).value.call;
        const type_name = try self.fresh("ParallelWorker");
        const input_name = try self.fresh("parallel_input");
        worker.* = try self.fresh("parallel_worker");

        try output.append(self.allocator, .{ .constant = .{ .name = input_name, .value = try self.expr(call.argument) } });
        try output.append(self.allocator, .{ .constant = .{ .name = type_name, .value = try workerType(self, call.function) } });

        const fields = try self.allocator.dupe(node.Field, &.{
            .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier(shared), "allocator"), &.{}, false) },
            .{ .name = "input", .value = try self.builder.identifier(input_name) },
            .{ .name = "result", .value = try self.builder.expression(.undefined_value) },
        });

        try output.append(self.allocator, .{ .variable = .{ .name = worker.*, .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier(type_name), .fields = fields } }) } });

        const thread = try self.fresh("parallel_thread");
        const arguments = try self.builder.expression(.{ .tuple = try self.allocator.dupe(*const node.Expression, &.{try self.builder.expression(.{ .address_of = try self.builder.identifier(worker.*) })}) });
        const spawn = try self.call(try standardField(self, &.{ "Thread", "spawn" }), &.{ try self.builder.expression(.{ .object = .{ .fields = &.{} } }), try self.field(try self.builder.identifier(type_name), "run"), arguments }, true);

        try spawning.append(self.allocator, .{ .constant = .{ .name = thread, .value = spawn } });
        try spawning.append(self.allocator, .{ .defer_expression = try self.call(try self.field(try self.builder.identifier(thread), "join"), &.{}, false) });
    }

    try output.append(self.allocator, .{ .scope = try spawning.toOwnedSlice(self.allocator) });

    for (0..invocations.len, workers) |invocation_index, worker| {
        const invocation = invocations.at(invocation_index);
        const value = try self.builder.expression(.{ .try_value = try self.field(try self.builder.identifier(worker), "result") });
        const name = if (invocation.symbol) |symbol| if (self.used[@backingInt(symbol)]) self.names[@backingInt(symbol)] else null else null;

        try output.append(self.allocator, if (name) |used| .{ .constant = .{ .name = used, .value = value } } else .{ .discard = value });
    }

    return output.toOwnedSlice(self.allocator);
}

fn workerType(self: *Lower, id: ir.FunctionId) Lower.Error!*const node.Expression {
    const function = self.program.functions.at(@backingInt(id));
    const instance = try self.builder.identifier("self");

    const fields = try self.allocator.dupe(node.Field, &.{
        .{ .name = "allocator", .value = try standardField(self, &.{ "mem", "Allocator" }) },
        .{ .name = "input", .value = self.types[@backingInt(function.input_type)] },
        .{ .name = "result", .value = try self.builder.expression(.{ .error_union = .{ .payload = self.types[@backingInt(function.output_type)] } }) },
    });

    const parameters = try self.allocator.dupe(node.Field, &.{.{ .name = "self", .value = try self.builder.expression(.{ .pointer = try self.builtin(.This, &.{}) }) }});

    const body = try self.allocator.dupe(node.Statement, &.{.{ .assignment = .{
        .target = try self.field(instance, "result"),
        .value = try self.call(try self.functionReference(id), &.{ try self.field(instance, "allocator"), try self.field(instance, "input") }, false),
    } }});

    const declarations = try self.allocator.dupe(node.Declaration, &.{.{ .function = .{ .name = "run", .parameters = parameters, .return_type = try self.builder.expression(.{ .primitive = .void }), .body = body } }});

    return self.builder.expression(.{ .container_type = .{ .fields = fields, .declarations = declarations } });
}
