const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsic = @import("intrinsics.zig");
const growth = @import("growth.zig");
const Operation = @FieldType(@FieldType(ir.ExpressionRow, "value"), "list_operation");

pub fn lower(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    return lowerMode(self, id, null, false);
}

pub fn lowerValue(self: *Lower, id: ir.ExprId, layout: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lowerMode(self, id, layout, false);
}

pub fn projection(self: *Lower, target: ir.ExprId, index: usize) Lower.Error!?node.ExpressionId {
    if (index != 1 or self.cache.contains(target)) return null;
    if (self.iteration_value) |context| if (context.cache.contains(target)) return null;

    const value = self.program.expression(target);

    if (value.value != .list_operation or value.value.list_operation.kind != .splice) return null;

    return try lowerMode(self, target, null, true);
}

fn lowerMode(self: *Lower, id: ir.ExprId, layout: ?node.ExpressionId, removed_only: bool) Lower.Error!node.ExpressionId {
    const row = self.program.expression(id);
    const type_id = row.type_id;
    const operation: Operation = row.value.list_operation;
    const flags = self.plan.get(id);
    var body: std.ArrayList(node.Statement) = .empty;
    const source_type = self.program.expression(operation.target).type_id;
    const provenance = @import("state_value/list.zig");
    const evaluated_source = try self.expr(operation.target);
    const qualified_source = if (provenance.selected(self, source_type)) try @import("state_value/ownership.zig").clip(self, &body, operation.target, evaluated_source) else evaluated_source;
    const source_value = try aggregate.bind(self, &body, qualified_source);
    const source = try provenance.items(self, source_type, source_value);
    const source_headered = if (provenance.selected(self, source_type)) try provenance.headered(self, source_value) else try self.builder.expression(.{ .boolean = flags.frontier });
    const arguments = try self.allocator.alloc(node.ExpressionId, operation.arguments.len);

    for (operation.arguments, arguments) |argument, *value| {
        const evaluated = try aggregate.bind(self, &body, try self.expr(argument));

        value.* = if (operation.kind == .push)
            try @import("state_value/elements.zig").write(self, &body, source_type, evaluated)

        else if (operation.kind == .concat or (operation.kind == .splice and argument == operation.arguments[2]))
            try provenance.items(self, self.program.expression(argument).type_id, evaluated)
        else evaluated;
    }

    const child = self.program.typeOf(source_type).list;
    const child_type = try @import("state_value/elements.zig").typeExpr(self, source_type);
    const length = try self.field(source, "len");
    const unit = try self.builder.expression(.unit);
    var result: node.ExpressionId = undefined;

    switch (operation.kind) {
        .pop => {
            const last = try intrinsic.binary(self, .subtract, length, try self.builder.integer(1));
            const remaining = try listResult(self, source_type, try slice(self, source, null, last), source_headered);
            const selected = try self.builder.expression(.{ .index = .{ .target = source, .index = last } });
            var nonempty_body: std.ArrayList(node.Statement) = .empty;
            const element = try @import("state_value/elements.zig").read(self, &nonempty_body, source_type, selected);
            const values = try @import("state_value/origin.zig").tuple(self, type_id, try pair(self, remaining, element));
            const nonempty = if (nonempty_body.items.len == 0) values else try aggregate.finish(self, &nonempty_body, values);

            if (flags.retract) {
                var retract: std.ArrayList(node.Statement) = .empty;

                try growth.retract(self, &retract, child_type, source, last);
                try body.append(self.allocator, try self.builder.branch(try intrinsic.binary(self, .not_equal, length, try self.builder.integer(0)), retract.items, &.{}));
            }

            result = try self.builder.expression(.{ .conditional = .{ .condition = try intrinsic.binary(self, .equal, length, try self.builder.integer(0)), .yes = try pair(self, source_value, try self.builder.expression(.null_value)), .no = nonempty } });
        },
        .reverse, .sort => {
            const mutable = if (flags.in_place)
                try self.builtin(.constCast, &.{source})

            else if (flags.grow)
                try growth.reserve(self, &body, child_type, source, length, false)
            else
                try allocate(self, &body, child_type, length);

            if (!flags.in_place and !flags.grow) try copy(self, &body, mutable, source);

            const call = if (operation.kind == .reverse) try intrinsic.standard(self, &.{ "mem", "reverse" }, &.{ child_type, mutable }, false) else blk: {
                var found = false;

                for (self.comparisons.items) |previous| {
                    if (previous == child) found = true;
                }

                if (!found) try self.comparisons.append(self.allocator, child);

                const compare = try self.builder.identifier(try @import("comparison.zig").name(self, child));

                break :blk try intrinsic.standard(self, &.{ "mem", "sortUnstable" }, &.{ child_type, mutable, unit, compare }, false);
            };

            try body.append(self.allocator, .{ .expression = call });

            result = try pair(self, try listResult(self, source_type, mutable, if (flags.in_place) source_headered else try self.builder.expression(.{ .boolean = flags.grow })), unit);
        },
        .push, .concat => {
            const added = if (operation.kind == .push) try self.builder.integer(1) else try self.field(arguments[0], "len");
            const count = try aggregate.bind(self, &body, try addLength(self, length, added));
            var append: std.ArrayList(node.Statement) = .empty;

            const buffer = if (provenance.selected(self, source_type) and flags.lazy)
                try provenance.reserve(self, &append, source_type, source_value, count, true)
            else
                try growth.reserve(self, &append, child_type, source, count, flags.frontier);

            if (operation.kind == .push) {
                try append.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .index = .{ .target = buffer, .index = length } }), .value = arguments[0] } });
            } else try copy(self, &append, try slice(self, buffer, length, null), arguments[0]);

            const wrapped = if (provenance.selected(self, source_type)) wrapped: {
                const exclusive = if (flags.frontier or flags.lazy)
                    try intrinsic.binary(self, .logical_or, if (flags.frontier) try intrinsic.binary(self, .equal, length, try self.builder.integer(0)) else try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = source_headered } }), try provenance.exclusive(self, source_value))
                else
                    try self.builder.expression(.{ .boolean = true });

                break :wrapped try provenance.proven(self, source_type, buffer, try self.builder.expression(.{ .boolean = true }), exclusive);
            } else buffer;

            const appended = try aggregate.finish(self, &append, wrapped);

            const updated = if (operation.kind == .concat) try self.builder.expression(.{ .conditional = .{
                .condition = try intrinsic.binary(self, .equal, added, try self.builder.integer(0)),
                .yes = source_value,
                .no = appended,
            } }) else appended;

            result = try pair(self, updated, unit);
        },
        .splice => {
            const start = arguments[0];
            const count = arguments[1];
            const replacement = arguments[2];
            const outside = try intrinsic.binary(self, .logical_or, try intrinsic.binary(self, .greater, start, length), try intrinsic.binary(self, .greater, count, try intrinsic.binary(self, .subtract, length, start)));

            try intrinsic.failIf(self, &body, outside, "IndexOutOfBounds");

            const size_type = try self.builder.expression(.{ .primitive = .usize });
            const begin = try aggregate.bind(self, &body, try self.cast(size_type, try self.builtin(.intCast, &.{start})));
            const removed = try aggregate.bind(self, &body, try self.cast(size_type, try self.builtin(.intCast, &.{count})));
            const end = try intrinsic.binary(self, .add, begin, removed);
            const inserted = try self.field(replacement, "len");
            const total = try addLength(self, try intrinsic.binary(self, .subtract, length, removed), inserted);

            if (flags.retract) {
                var retract: std.ArrayList(node.Statement) = .empty;

                try growth.retract(self, &retract, child_type, source, end);
                try body.append(self.allocator, try self.builder.branch(try intrinsic.binary(self, .not_equal, length, try self.builder.integer(0)), retract.items, &.{}));
            }

            if (removed_only) {
                try body.append(self.allocator, .{ .discard = total });

                return aggregate.finish(self, &body, try listResult(self, source_type, try slice(self, source, begin, end), try intrinsic.binary(self, .logical_and, source_headered, try intrinsic.binary(self, .equal, begin, try self.builder.integer(0)))));
            }

            const buffer = try allocate(self, &body, child_type, total);
            const tail = try slice(self, buffer, begin, null);

            try copy(self, &body, try slice(self, buffer, null, begin), try slice(self, source, null, begin));
            try copy(self, &body, try slice(self, tail, null, inserted), replacement);
            try copy(self, &body, try slice(self, buffer, try intrinsic.binary(self, .add, begin, inserted), null), try slice(self, source, end, null));

            result = try pair(self, try provenance.wrap(self, source_type, buffer, false), try listResult(self, source_type, try slice(self, source, begin, end), try intrinsic.binary(self, .logical_and, source_headered, try intrinsic.binary(self, .equal, begin, try self.builder.integer(0)))));
        },
    }

    if (self.state_active and !self.state_plan.selected[@backingInt(type_id)]) {
        const tuple = try aggregate.bind(self, &body, result);
        const members = self.program.typeOf(type_id).tuple;
        const values = try self.allocator.alloc(node.ExpressionId, members.len);

        for (values, 0..) |*value, index| value.* = try @import("state_value/conversion.zig").convert(self, &body, members.at(index), try self.field(tuple, try std.fmt.allocPrint(self.allocator, "{d}", .{index})), .pointer);

        result = try self.builder.expression(.{ .tuple = values });
    }

    return aggregate.finish(self, &body, if (layout) |target| try self.cast(target, try @import("state_value/origin.zig").tuple(self, type_id, result)) else try self.construct(type_id, result));
}

fn slice(self: *Lower, target: node.ExpressionId, start: ?node.ExpressionId, end: ?node.ExpressionId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .slice = .{ .target = target, .start = start, .end = end } });
}

fn pair(self: *Lower, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .tuple = try self.allocator.dupe(node.ExpressionId, &.{ left, right }) });
}

fn addLength(self: *Lower, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    return intrinsic.standard(self, &.{ "math", "add" }, &.{ try self.builder.expression(.{ .primitive = .usize }), left, right }, true);
}

fn allocate(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, length: node.ExpressionId) Lower.Error!node.ExpressionId {
    return aggregate.bind(self, body, try self.call(try self.field(try self.builder.identifier("allocator"), "alloc"), &.{ element, length }, true));
}

fn copy(self: *Lower, body: *std.ArrayList(node.Statement), target: node.ExpressionId, source: node.ExpressionId) Lower.Error!void {
    try body.append(self.allocator, .{ .expression = try self.builtin(.memcpy, &.{ target, source }) });
}

fn listResult(self: *Lower, id: ir.TypeId, value: node.ExpressionId, headered: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("state_value/list.zig").selected(self, id)) return value;

    return @import("state_value/list.zig").create(self, id, value, headered);
}
