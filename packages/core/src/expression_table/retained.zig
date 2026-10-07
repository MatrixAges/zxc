const ir = @import("../ir.zig");
const Storage = @import("storage.zig");

pub fn offset(self: *const Storage, source: ir.Expression) ?usize {
    return switch (source.value) {
        .list, .tuple, .template => |values| locate(self.sequence_items.items, values),
        .task => |value| locate(self.task_captures.items, value.captures),
        .list_operation => |value| locate(self.collection_arguments.items, value.arguments),
        .transform => |value| locate(self.transform_parameters.items, value.parameters),
        .call => |value| locate(self.call_stores.items, value.stores),
        .object => |value| locate(self.object_evaluation_values.items, value.evaluation),
        else => null,
    };
}

pub fn restore(self: *const Storage, source: *ir.Expression, first: usize) void {
    switch (source.value) {
        .list => |values| source.value.list = slice(ir.ExprId, self.sequence_items.items, first, values.len),
        .tuple => |values| source.value.tuple = slice(ir.ExprId, self.sequence_items.items, first, values.len),
        .template => |values| source.value.template = slice(ir.ExprId, self.sequence_items.items, first, values.len),
        .task => |value| source.value.task.captures = slice(ir.SymbolId, self.task_captures.items, first, value.captures.len),
        .list_operation => |value| source.value.list_operation.arguments = slice(ir.ExprId, self.collection_arguments.items, first, value.arguments.len),
        .transform => |value| source.value.transform.parameters = slice(ir.SymbolId, self.transform_parameters.items, first, value.parameters.len),
        .call => |value| source.value.call.stores = self.call_stores.items[first..][0..value.stores.len],
        .object => |value| source.value.object.evaluation = slice(ir.ExprId, self.object_evaluation_values.items, first, value.evaluation.len),
        else => unreachable,
    }
}

fn locate(backing: []const u32, values: anytype) ?usize {
    if (values.len == 0) return null;
    if (@sizeOf(@typeInfo(@TypeOf(values)).pointer.child) != @sizeOf(u32)) @compileError("Incompatible retained ID slice");

    const start = @intFromPtr(backing.ptr);
    const pointer = @intFromPtr(values.ptr);

    if (pointer < start or (pointer - start) % @sizeOf(u32) != 0) return null;

    const first = (pointer - start) / @sizeOf(u32);

    if (first > backing.len or values.len > backing.len - first) return null;

    return first;
}

fn slice(comptime Id: type, values: []const u32, first: usize, count: usize) []const Id {
    if (@sizeOf(Id) != @sizeOf(u32) or @alignOf(Id) != @alignOf(u32)) @compileError("Incompatible retained ID representation");

    return @as([*]const Id, @ptrCast(values.ptr))[first..][0..count];
}
