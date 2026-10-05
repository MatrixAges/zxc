const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
const flow = @import("flow.zig");
const Error = std.mem.Allocator.Error;

pub fn contains(trace: *Trace, id: ir.ExprId, path: []const u32, origin: []const u32) Error!bool {
    const expression = trace.function.expressions[@backingInt(id)];
    var selected = expression.type_id;

    for (path) |index| {
        while (trace.program.typeOf(selected) == .optional) selected = trace.program.typeOf(selected).optional;

        selected = switch (trace.program.typeOf(selected)) {
            .object => |fields| if (index < fields.len) fields[index].type_id else return false,
            .tuple => |items| if (index < items.len) items[index] else return false,
            else => return false,
        };
    }

    switch (trace.program.typeOf(selected)) {
        .scalar, .enumeration => return false,
        else => {},
    }

    return switch (expression.value) {
        .reference => |symbol| if (@backingInt(symbol) == 0)
            prefix(path, origin) or prefix(origin, path)
        else if (trace.bindings[@backingInt(symbol)]) |binding|
            contains(trace, binding, path, origin)
        else
            true,
        .conditional => |value| try contains(trace, value.yes, path, origin) or try contains(trace, value.no, path, origin),
        .match_expr => |value| blk: {
            if (try contains(trace, value.fallback, path, origin)) break :blk true;
            for (value.arms) |arm| if (try contains(trace, arm.result, path, origin)) break :blk true;

            break :blk false;
        },
        .field, .tuple_field => |projection| blk: {
            const nested = try trace.allocator.alloc(u32, path.len + 1);

            nested[0] = projection.index;

            @memcpy(nested[1..], path);

            break :blk try contains(trace, projection.target, nested, origin);
        },
        .object => |object| blk: {
            for (object.fields) |field| {
                if (path.len != 0 and field.index != path[0]) continue;
                if (try contains(trace, field.value, if (path.len == 0) &.{} else path[1..], origin)) break :blk true;
            }

            break :blk false;
        },
        .tuple => |items| if (path.len != 0) contains(trace, items[path[0]], path[1..], origin) else any(trace, items, origin),
        .list => |items| any(trace, items, origin),
        .some => |child| contains(trace, child, path, origin),
        .binary => |value| try contains(trace, value.left, path, origin) or try contains(trace, value.right, path, origin),
        .index => |value| contains(trace, value.target, &.{}, origin),
        .list_operation => |operation| try contains(trace, operation.target, &.{}, origin) or try any(trace, operation.arguments, origin),
        .call => |call| blk: {
            const index = @backingInt(call.function);

            if (index < trace.summaries.len and path.len != 0) for (trace.summaries[index]) |lane| {
                if (std.mem.eql(u32, lane.output, path) and try contains(trace, call.argument, lane.input, origin)) break :blk true;
            };

            const callee = trace.program.functions[index];

            if (callee.external != null or callee.stores.len != 0 or index >= trace.summaries.len or optional(trace.program, callee.input_type)) break :blk try contains(trace, call.argument, &.{}, origin);

            var nested = try Trace.init(trace.allocator, trace.program, callee, trace.summaries[0..index]);
            var inputs: std.ArrayList([]const u32) = .empty;

            try flow.leaves(trace.allocator, trace.program, callee.input_type, &.{}, true, &inputs);

            for (inputs.items) |input| {
                if (!try contains(trace, call.argument, input, origin)) continue;

                for (nested.results.items) |result| {
                    if (try contains(&nested, result, path, input)) break :blk true;
                }
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

fn optional(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .optional => true,
        .object => |fields| blk: {
            for (fields) |field| if (optional(program, field.type_id)) break :blk true;

            break :blk false;
        },
        .tuple => |items| blk: {
            for (items) |item| if (optional(program, item)) break :blk true;

            break :blk false;
        },
        else => false,
    };
}
