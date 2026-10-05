const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("flow.zig");
const Trace = @import("trace.zig");
const may = @import("may.zig");
const Error = std.mem.Allocator.Error;
pub const Rejection = enum { borrowed_input, contracts, parallel, nested_transform, duplicate, container_escape, element_read, unsupported_read, unsupported_operation, detached_append, cached_append, unsupported_call, detached_call };

pub fn check(trace: *Trace, lane: flow.Lane) Error!?Rejection {
    if (!trace.function.consumes_input) return .borrowed_input;
    if (trace.function.contracts.len != 0) return .contracts;
    if (parallel(trace.function.body)) return .parallel;

    for (trace.function.expressions, 0..) |expression, position| {
        const id: ir.ExprId = @fromBackingInt(@intCast(position));

        switch (expression.value) {
            .transform, .iteration => return .nested_transform,
            .scope, .list_update, .capture, .optional_value => return .unsupported_operation,
            .index => |value| if (try count(trace, value.target, lane) != 0) return .element_read,
            .some => |value| if (try count(trace, value, lane) != 0) return .container_escape,
            .list => |values| for (values) |value| {
                if (try count(trace, value, lane) != 0) return .container_escape;
            },
            .object => |object| {
                if (try count(trace, id, lane) > 1) return .duplicate;

                for (object.evaluation) |cached| for (lane.appends) |projection| {
                    if (trace.function.expressions[@backingInt(projection)].value.tuple_field.target == cached) return .cached_append;
                };
            },
            .tuple => if (try count(trace, id, lane) > 1) return .duplicate,
            .binary => |value| if (try count(trace, value.left, lane) != 0 or try count(trace, value.right, lane) != 0) return .unsupported_read,
            .unary => |value| if (try count(trace, value.operand, lane) != 0) return .unsupported_read,
            .template => |values| for (values) |value| {
                if (try count(trace, value, lane) != 0) return .unsupported_read;
            },
            .list_operation => |operation| {
                for (operation.arguments) |argument| {
                    if (try count(trace, argument, lane) != 0) return .container_escape;
                }

                if (try count(trace, operation.target, lane) == 0) continue;
                if (operation.kind != .push and operation.kind != .concat) return .unsupported_operation;

                const transferred = for (lane.appends) |projection| {
                    if (trace.function.expressions[@backingInt(projection)].value.tuple_field.target == id) break true;
                } else false;

                if (!transferred) return .detached_append;
            },
            .call => |call| {
                const references = try count(trace, call.argument, lane);

                if (references == 0) continue;
                if (references != 1) return .duplicate;

                const index = @backingInt(call.function);

                if (index >= trace.summaries.len or call.stores.len != 0) return .unsupported_call;

                const selected = for (trace.summaries[index], 0..) |callee, lane_index| {
                    const origin = try trace.trace(call.argument, callee.input) orelse continue;

                    if (std.mem.eql(u32, origin, lane.input) and callee.rejection == null) break lane_index;
                } else return .unsupported_call;

                const transferred = for (lane.calls) |saved| {
                    if (saved.expression == id and saved.lane == selected) break true;
                } else false;

                if (!transferred) return .detached_call;
            },
            else => {},
        }
    }

    return null;
}

fn count(trace: *Trace, id: ir.ExprId, lane: flow.Lane) Error!usize {
    var paths: std.ArrayList([]const u32) = .empty;

    try flow.leaves(trace.allocator, trace.program, trace.function.expressions[@backingInt(id)].type_id, &.{}, true, &paths);

    var total: usize = 0;

    for (paths.items) |path| {
        if (try may.contains(trace, id, path, lane.input)) total += 1;
    }

    return total;
}

fn parallel(statements: []const ir.Statement) bool {
    for (statements) |statement| switch (statement) {
        .parallel => return true,
        .branch => |branch| if (parallel(branch.yes) or parallel(branch.no)) return true,
        .switch_stmt => |selection| for (selection.cases) |case| {
            if (parallel(case.body)) return true;
        },
        else => {},
    };

    return false;
}
