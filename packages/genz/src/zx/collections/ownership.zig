const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const Graph = @import("../iteration_buffer/ownership/graph.zig");
const flow = @import("../buffer_call/analysis/flow.zig");

pub fn consumable(lowering: *Lower, source: ir.ExprId) std.mem.Allocator.Error!bool {
    if (lowering.iteration_value != null) return false;

    var arena = std.heap.ArenaAllocator.init(lowering.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    const program = lowering.program;
    const graph = try Graph.create(allocator, program);
    const region = graph.regions[@backingInt(source)] orelse return false;
    var current = source;
    var path: std.ArrayList(usize) = .empty;
    var readers: ?[]bool = null;
    var depth: usize = 0;

    while (depth < program.expressions.count()) : (depth += 1) {
        const index = @backingInt(current);

        if (!graph.exclusive[index] or graph.regions[index] != region) return false;
        if (lowering.cache.contains(current) or lowering.buffer_calls.contains(current) or lowering.collection_buffers.contains(current) or lowering.list_update_buffers.contains(current)) return false;

        switch (program.expression(current).value) {
            .reference => |symbol| {
                if (graph.references[@backingInt(symbol)] != 1) return false;

                current = graph.bindings[@backingInt(symbol)] orelse return false;
            },
            .field, .tuple_field => |field| {
                try path.insert(allocator, 0, field.index);

                current = field.target;
            },
            .object => |object| {
                if (path.items.len == 0) return false;

                current = for (0..object.fields.len) |field_index| {
                    const field = object.fields.at(field_index);

                    if (field.index == path.items[0]) break field.value;
                } else return false;

                _ = path.orderedRemove(0);
            },
            .tuple => |items| {
                if (path.items.len == 0 or path.items[0] >= items.len) return false;

                current = items[path.orderedRemove(0)];
            },
            .scope => |scope| current = scope.result,
            .iteration => |iteration| {
                if (readers == null) {
                    readers = try allocator.alloc(bool, program.functions.count());

                    for (readers.?, 0..) |*reader, function_index| {
                        reader.* = function_index < lowering.pure_functions.len and lowering.pure_functions[function_index] and flow.detached(program, program.functions.at(function_index).output_type);
                    }
                }

                const analyzed = try @import("../iteration_buffer/analysis.zig").analyzeWithCalls(allocator, lowering.workspace, program, iteration, path.items, .{
                    .selected = &.{},
                    .summaries = lowering.buffer_functions,
                    .readers = readers.?,
                    .discover = true,
                });

                if (analyzed == null) return false;

                current = iteration.initial;
            },
            .transform => |transform| return path.items.len == 0 and (transform.kind == .map or transform.kind == .filter),
            .list => |items| return path.items.len == 0 and items.len == 0,
            else => return false,
        }
    }

    return false;
}
