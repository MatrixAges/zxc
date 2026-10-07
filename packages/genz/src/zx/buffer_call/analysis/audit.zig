const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("flow.zig");
const Trace = @import("trace.zig");
const may = @import("may.zig");
const Error = std.mem.Allocator.Error;
pub const Rejection = enum { stale_version, contracts, parallel, nested_transform, duplicate, container_escape, element_read, unsupported_read, unsupported_operation, detached_append, detached_pop, cached_append, unsupported_call, detached_call };

pub fn check(trace: *Trace, lane: flow.Lane) Error!?Rejection {
    if (trace.function.contracts.len != 0) return .contracts;
    if (parallel(trace.function.body)) return .parallel;

    for (trace.function.expressions, 0..) |expression, position| {
        const id: ir.ExprId = @fromBackingInt(@intCast(position));

        switch (expression.value) {
            .transform => return .nested_transform,
            .iteration => if (!try @import("independent.zig").prove(trace, id, lane.input)) return .nested_transform,
            .capture, .task, .await_task, .cancel_task, .parallel => return .unsupported_operation,
            .list_update => |value| if (try count(trace, value.target, lane) != 0 or try count(trace, value.value, lane) != 0) return .unsupported_operation,
            .index => |value| if (!flow.detached(trace.program, expression.type_id) and try count(trace, value.target, lane) != 0) return .element_read,
            .some, .optional_value => |value| if (try count(trace, value, lane) != 0) return .container_escape,
            .list => |values| for (values) |value| {
                if (try count(trace, value, lane) != 0) return .container_escape;
            },
            .object => |object| {
                for (object.evaluation) |cached| for (lane.appends) |projection| {
                    if (trace.function.expressions[@backingInt(projection)].value.tuple_field.target == cached) return .cached_append;
                };
            },
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
                if (operation.kind == .splice) continue;

                if (operation.kind == .pop) {
                    if (std.mem.indexOfScalar(ir.ExprId, lane.pops, id) == null) return .detached_pop;

                    continue;
                }

                if (operation.kind != .push and operation.kind != .concat) return .unsupported_operation;

                const forwarded = for (lane.appends) |projection| {
                    if (trace.function.expressions[@backingInt(projection)].value.tuple_field.target == id) break true;
                } else false;

                if (!forwarded) return .detached_append;
            },
            .call => |call| {
                const references = try count(trace, call.argument, lane);

                if (references == 0) continue;

                const index = @backingInt(call.function);

                if (index >= trace.summaries.len or call.stores.len != 0) return .unsupported_call;
                if (index < trace.readers.len and trace.readers[index]) continue;

                const buffered = for (lane.calls) |saved| {
                    if (saved.expression == id) break true;
                } else false;

                if (!buffered) continue;
                if (references != 1) return .duplicate;

                const selected = for (trace.summaries[index], 0..) |callee, lane_index| {
                    const origin = try trace.trace(call.argument, callee.input) orelse continue;

                    if (std.mem.eql(u32, origin, lane.input) and callee.rejection == null) break lane_index;
                } else return .unsupported_call;

                const forwarded = for (lane.calls) |saved| {
                    if (saved.expression == id and saved.lane == selected) break true;
                } else false;

                if (!forwarded) return .detached_call;
            },
            else => {},
        }
    }

    return if (try @import("versions.zig").check(trace, lane)) null else .stale_version;
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
