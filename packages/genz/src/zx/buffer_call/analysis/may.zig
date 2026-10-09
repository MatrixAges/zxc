const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
const flow = @import("flow.zig");
const Error = std.mem.Allocator.Error;

pub fn contains(trace: *Trace, id: ir.ExprId, path: []const u32, origin: []const u32) Error!bool {
    const parent = trace.queries.current;
    const query = try trace.queries.lookup(trace.allocator, .{ .expression = id, .path = path, .origin = origin });

    if (query.existing) {
        const node = trace.queries.nodes.items[query.index];

        if (node.active) if (parent) |caller| trace.queries.connect(caller, query.index);

        return node.value;
    }

    trace.queries.current = query.index;
    defer trace.queries.current = parent;

    const value = try evaluate(trace, id, path, origin);

    trace.queries.finish(query.index, value);

    if (parent) |caller| trace.queries.connect(caller, trace.queries.nodes.items[query.index].low);

    return trace.queries.nodes.items[query.index].value;
}

fn evaluate(trace: *Trace, id: ir.ExprId, path: []const u32, origin: []const u32) Error!bool {
    const expression = trace.function.expressions.at(@backingInt(id));
    var selected = expression.type_id;

    for (path) |index| {
        while (trace.program.typeOf(selected) == .optional) selected = trace.program.typeOf(selected).optional;

        selected = switch (trace.program.typeOf(selected)) {
            .object => |fields| if (index < fields.len) fields.at(index).type_id else return false,
            .tuple => |items| if (index < items.len) items.at(index) else return false,
            else => return false,
        };
    }

    if (flow.detached(trace.program, selected) or trace.program.typeOf(selected) == .native_reference) return false;

    const owner = originType(trace, origin);

    if (trace.program.typeOf(owner) == .list and selected != owner and !@import("../../value_call/analysis.zig").containsDescendant(trace.program, selected, owner)) return false;

    return switch (expression.value) {
        .iteration => |value| blk: {
            for (trace.selected_loops) |loop| if (loop.expression == id and std.mem.eql(u32, loop.path, path)) {
                break :blk try contains(trace, value.initial, path, origin);
            };

            break :blk try contains(trace, value.initial, path, origin) or try contains(trace, value.body, path, origin);
        },
        .list_update => |value| try contains(trace, value.target, &.{}, origin) or try contains(trace, value.value, &.{}, origin),
        .scope => |scope| contains(trace, scope.result, path, origin),
        .reference => |symbol| if (@backingInt(symbol) == 0)
            prefix(path, origin) or prefix(origin, path)
        else if (trace.bindings[@backingInt(symbol)]) |binding|
            contains(trace, binding, path, origin)
        else if (trace.iterations[@backingInt(symbol)]) |iteration_id|
            contains(trace, iteration_id, path, origin)
        else
            true,
        .conditional => |value| try contains(trace, value.yes, path, origin) or try contains(trace, value.no, path, origin),
        .match_expr => |value| blk: {
            if (try contains(trace, value.fallback, path, origin)) break :blk true;

            for (0..value.arms.len) |record_index| {
                const arm = value.arms.at(record_index);

                if (try contains(trace, arm.result, path, origin)) break :blk true;
            }

            break :blk false;
        },
        .field, .tuple_field => |projection| blk: {
            const nested = try trace.queryAllocator().alloc(u32, path.len + 1);

            nested[0] = projection.index;

            @memcpy(nested[1..], path);

            break :blk try contains(trace, projection.target, nested, origin);
        },
        .object => |object| blk: {
            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (path.len != 0 and field.index != path[0]) continue;
                if (try contains(trace, field.value, if (path.len == 0) &.{} else path[1..], origin)) break :blk true;
            }

            break :blk false;
        },
        .tuple => |items| if (path.len != 0) contains(trace, items[path[0]], path[1..], origin) else any(trace, items, origin),
        .list => |items| any(trace, items, origin),
        .some, .optional_value => |child| contains(trace, child, path, origin),
        .capture => |child| if (path.len == 0 or path[0] == 1) contains(trace, child, if (path.len == 0) &.{} else path[1..], origin) else false,
        .binary => |value| try contains(trace, value.left, path, origin) or try contains(trace, value.right, path, origin),
        .index => |value| contains(trace, value.target, &.{}, origin),
        .list_operation => |operation| blk: {
            if (operation.kind == .pop and path.len != 0 and path[0] == 1) {
                if (owner == trace.function.expressions.at(@backingInt(operation.target)).type_id) break :blk false;
            }

            break :blk try contains(trace, operation.target, &.{}, origin) or try any(trace, operation.arguments, origin);
        },
        .call => |call| blk: {
            const index = @backingInt(call.function);

            if (index < trace.summaries.len) for (trace.summaries[index]) |lane| {
                if (!std.mem.eql(u32, lane.output, path)) continue;
                if (try contains(trace, call.argument, lane.input, origin)) break :blk true;
                if (trace.program.typeOf(selected) == .list and selected == owner) break :blk false;
            };

            const callee = trace.program.functions.at(index);

            if (callee.external != null or callee.stores.count() != 0 or index >= trace.summaries.len) break :blk try contains(trace, call.argument, &.{}, origin);

            const nested = try trace.callee(index);
            const inputs = try nested.inputPaths();

            for (inputs) |input| {
                const dependent = for (nested.results.items) |result| {
                    if (try contains(nested, result, path, input)) break true;
                } else false;

                if (dependent and try contains(trace, call.argument, input, origin)) break :blk true;
            }

            break :blk false;
        },
        .transform => |value| try contains(trace, value.target, &.{}, origin) or try contains(trace, value.body, &.{}, origin) or (if (value.initial) |initial| try contains(trace, initial, &.{}, origin) else false),
        else => false,
    };
}

fn any(trace: *Trace, items: []const ir.ExprId, origin: []const u32) Error!bool {
    for (items) |item| if (try contains(trace, item, &.{}, origin)) return true;

    return false;
}

fn prefix(left: []const u32, right: []const u32) bool {
    return left.len <= right.len and std.mem.eql(u32, left, right[0..left.len]);
}

fn originType(trace: *const Trace, origin: []const u32) ir.TypeId {
    var id = trace.function.input_type;

    for (origin) |part| id = switch (trace.program.typeOf(id)) {
        .object => |fields| fields.at(part).type_id,
        .tuple => |items| items.at(part),
        else => unreachable,
    };

    return id;
}
