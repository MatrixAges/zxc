const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const standardField = @import("../intrinsics.zig").standardField;

pub fn lower(self: *Lower, id: ir.ExprId, process: bool) Lower.Error!*const node.Expression {
    const declaration_index = self.task_declarations.items.len;
    const name = try std.fmt.allocPrint(self.allocator, "zx_task_worker_{d}", .{declaration_index});

    try self.task_declarations.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.builder.expression(.undefined_value) } });

    const expression = self.program.expression(id);
    const task = expression.value.task;
    const task_type = self.program.typeOf(expression.type_id).task;
    var worker = self.*;
    worker.names = try self.allocator.dupe([]const u8, self.names);
    worker.used = try self.allocator.alloc(bool, self.used.len);
    worker.cache_reads = try self.allocator.alloc(usize, self.cache_reads.len);
    worker.cache = .empty;
    worker.append_overrides = .empty;
    worker.list_update_buffers = .empty;
    worker.buffer_calls = .empty;
    worker.stack_symbols = .empty;
    worker.iteration_value = null;
    worker.capture = null;
    worker.uses_allocator = false;
    worker.uses_io = false;
    worker.uses_process = false;

    @memset(worker.used, false);
    @memset(worker.cache_reads, 0);

    var parameters: std.ArrayList(node.Field) = .empty;

    try parameters.append(self.allocator, .{ .name = "allocator", .value = try standardField(self, &.{ "mem", "Allocator" }) });
    try parameters.append(self.allocator, .{ .name = "io", .value = try standardField(self, &.{"Io"}) });
    if (process) try parameters.append(self.allocator, .{ .name = "process", .value = try standardField(self, &.{ "process", "Init", "Minimal" }) });

    for (task.captures) |symbol| {
        const index = @backingInt(symbol);

        worker.names[index] = try std.fmt.allocPrint(self.allocator, "capture_{d}", .{index});

        try parameters.append(self.allocator, .{ .name = worker.names[index], .value = self.types[@backingInt(self.program.symbols[index].type_id)] });
    }

    const result = try worker.expr(task.body);
    var body: std.ArrayList(node.Statement) = .empty;

    if (!worker.uses_allocator) try body.append(self.allocator, .{ .discard = try self.builder.identifier("allocator") });
    if (!worker.uses_io) try body.append(self.allocator, .{ .discard = try self.builder.identifier("io") });
    if (process and !worker.uses_process) try body.append(self.allocator, .{ .discard = try self.builder.identifier("process") });

    for (task.captures) |symbol| {
        if (!worker.used[@backingInt(symbol)]) try body.append(self.allocator, .{ .discard = try self.builder.identifier(worker.names[@backingInt(symbol)]) });
    }

    try body.append(self.allocator, .{ .result = result });

    const function: node.Declaration = .{ .function = .{ .name = "run", .parameters = try parameters.toOwnedSlice(self.allocator), .return_type = try self.builder.expression(.{ .error_union = .{ .payload = self.types[@backingInt(task_type.result)], .errors = self.program.typeOf(task_type.errors).error_set } }), .body = try body.toOwnedSlice(self.allocator) } };
    self.task_declarations.items[declaration_index] = .{ .constant = .{ .name = name, .value = try self.builder.expression(.{ .namespace_type = try self.allocator.dupe(node.Declaration, &.{function}) }) } };

    return self.builder.identifier(name);
}
