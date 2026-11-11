const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const emitting = @import("worker/emitting.zig");

pub fn lower(self: *Lower, id: ir.ExprId, process: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("worker_seed.zig").lower(self, id, process);

    const declaration_index = self.task_declarations.count();
    const name = try emitting.reserve(self, declaration_index);
    const expression = self.program.expression(id);
    const task = expression.value.task;
    const task_type = self.program.typeOf(expression.type_id).task;
    var worker = self.*;
    worker.state_symbols = self.state_symbols.inherit();
    worker.names = try self.allocator.dupe([]const u8, self.names);
    worker.used = try self.allocator.alloc(bool, self.used.len);
    worker.cache_reads = try self.allocator.alloc(u64, self.cache_reads.len);
    worker.cache = .empty;
    worker.stack_symbols = .empty;
    worker.reference_storage = .empty;
    worker.iteration_value = null;
    worker.capture = null;
    worker.uses_allocator = false;
    worker.uses_io = false;
    worker.uses_process = false;

    @memset(worker.used, false);
    @memset(worker.cache_reads, 0);

    const parameters = try emitting.prepare(self, task.captures, process);

    for (task.captures, 0..) |symbol, index| {
        worker.names[@backingInt(symbol)] = self.builder.nodes.field_columns.get(parameters.capture_first + index).name;
    }

    const result = try worker.expr(task.body);
    const output_type = try self.typeExpr(task_type.result);
    const errors = self.program.typeOf(task_type.errors).error_set;
    const body_first: u32 = @intCast(self.builder.nodes.statements.tags.items.len);

    try emitting.discard(self, &worker, task.captures, process);

    _ = try self.builder.statements(worker.reference_storage.items);

    return emitting.finish(self, .{
        .name = name,
        .value = result,
        .output_type = output_type,
        .errors = errors,
        .parameters_first = parameters.first,
        .parameters_count = parameters.count,
        .body_first = body_first,
        .slot = declaration_index,
    });
}
