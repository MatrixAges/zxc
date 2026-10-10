const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("flow.zig");
const Trace = @import("trace.zig");
const Batch = @import("batch.zig");
const Error = std.mem.Allocator.Error;
pub const Rejection = enum { stale_version, contracts, parallel, nested_transform, duplicate, container_escape, element_read, unsupported_read, unsupported_operation, detached_append, detached_pop, cached_append, unsupported_call, detached_call };

pub fn check(batch: *Batch, slot: usize, lane: flow.Lane) Error!?Rejection {
    const trace = batch.trace;

    if (trace.function.contracts.count() != 0) return .contracts;
    if (parallel(trace.function.body.block())) return .parallel;

    var reads = batch.reads(slot);

    for (0..trace.function.expressions.count()) |position| {
        const expression = trace.function.expressions.at(position);
        const id: ir.ExprId = @fromBackingInt(@intCast(position));

        switch (expression.value) {
            .transform => return .nested_transform,
            .iteration => {
                const selected = for (lane.iterations) |iteration| {
                    if (iteration.expression == id) break true;
                } else false;

                if (!selected and !try reads.independent(id)) return .nested_transform;
            },
            .capture, .task, .await_task, .cancel_task, .parallel => return .unsupported_operation,
            .list_update => |value| {
                if (try reads.classify(value.value) != .none) return .container_escape;
                if (try reads.classify(value.target) != .none and std.mem.indexOfScalar(ir.ExprId, lane.updates, id) == null) return .unsupported_operation;
            },
            .index => |value| if (!flow.detached(trace.program, expression.type_id) and try reads.classify(value.target) != .none) return .element_read,
            .some, .optional_value => |value| if (try reads.classify(value) != .none) return .container_escape,
            .list => |values| for (values) |value| {
                if (try reads.classify(value) != .none) return .container_escape;
            },
            .object => |object| {
                for (object.evaluation) |cached| for (lane.appends) |projection| {
                    if (trace.function.expressions.at(@backingInt(projection)).value.tuple_field.target == cached) return .cached_append;
                };
            },
            .binary => |value| if (try reads.classify(value.left) != .none or try reads.classify(value.right) != .none) return .unsupported_read,
            .unary => |value| if (try reads.classify(value.operand) != .none) return .unsupported_read,
            .template => |values| for (values) |value| {
                if (try reads.classify(value) != .none) return .unsupported_read;
            },
            .list_operation => |operation| {
                for (operation.arguments) |argument| {
                    if (try reads.classify(argument) != .none) return .container_escape;
                }

                if (try reads.classify(operation.target) == .none) continue;
                if (operation.kind == .splice) continue;

                if (operation.kind == .pop) {
                    if (std.mem.indexOfScalar(ir.ExprId, lane.pops, id) == null) return .detached_pop;

                    continue;
                }

                if (operation.kind != .push and operation.kind != .concat) return .unsupported_operation;

                const forwarded = for (lane.appends) |projection| {
                    if (trace.function.expressions.at(@backingInt(projection)).value.tuple_field.target == id) break true;
                } else false;

                if (!forwarded) return .detached_append;
            },
            .call => |call| {
                const index = @backingInt(call.function);

                if (index < trace.summaries.len and call.stores.len == 0 and index < trace.readers.len and trace.readers[index]) continue;

                const references = try reads.classify(call.argument);

                if (references == .none) continue;
                if (index >= trace.summaries.len or call.stores.len != 0) return .unsupported_call;

                const buffered = for (lane.calls) |saved| {
                    if (saved.expression == id) break true;
                } else false;

                if (!buffered) continue;
                if (references != .one) return .duplicate;

                const selected = for (try batch.calls(id, call)) |candidate| {
                    if (std.mem.eql(u32, candidate.origin, lane.input)) break candidate.lane;
                } else return .unsupported_call;

                const forwarded = for (lane.calls) |saved| {
                    if (saved.expression == id and saved.lane == selected) break true;
                } else false;

                if (!forwarded) return .detached_call;
            },
            else => {},
        }
    }

    return if (try @import("versions.zig").check(trace, lane, batch.versionsAllocator())) null else .stale_version;
}

fn parallel(statements: ir.Block) bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .parallel => return true,
            .branch => |branch| if (parallel(branch.yes) or parallel(branch.no)) return true,
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (parallel(case.body)) return true;
            },
            else => {},
        }
    }

    return false;
}
