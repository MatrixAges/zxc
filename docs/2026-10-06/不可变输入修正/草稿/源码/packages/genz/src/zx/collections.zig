const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsic = @import("intrinsics.zig");
const Capacity = @import("iteration_buffer/capacity.zig");

pub fn lower(self: *Lower, type_id: ir.TypeId, operation: @FieldType(@FieldType(ir.Expression, "value"), "list_operation"), storage: ?Capacity) Lower.Error!*const node.Expression {
    return lowerMode(self, type_id, operation, null, storage);
}

pub fn lowerValue(self: *Lower, type_id: ir.TypeId, operation: @FieldType(@FieldType(ir.Expression, "value"), "list_operation"), layout: *const node.Expression, storage: ?Capacity) Lower.Error!*const node.Expression {
    return lowerMode(self, type_id, operation, layout, storage);
}

fn lowerMode(self: *Lower, type_id: ir.TypeId, operation: @FieldType(@FieldType(ir.Expression, "value"), "list_operation"), layout: ?*const node.Expression, storage: ?Capacity) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(operation.target));
    const arguments = try self.allocator.alloc(*const node.Expression, operation.arguments.len);

    for (operation.arguments, arguments) |argument, *value| value.* = try aggregate.bind(self, &body, try self.expr(argument));

    const child = self.program.typeOf(self.program.expression(operation.target).type_id).list;
    const child_type = self.types[@backingInt(child)];
    const length = try self.field(source, "len");
    const unit = try self.builder.expression(.unit);
    var result: *const node.Expression = undefined;

    switch (operation.kind) {
        .pop => {
            const last = try intrinsic.binary(self, .subtract, length, try self.builder.integer(1));
            const nonempty = try pair(self, try slice(self, source, null, last), try self.builder.expression(.{ .index = .{ .target = source, .index = last } }));

            result = try self.builder.expression(.{ .conditional = .{ .condition = try intrinsic.binary(self, .equal, length, try self.builder.integer(0)), .yes = try pair(self, source, try self.builder.expression(.null_value)), .no = nonempty } });
        },
        .reverse, .sort => {
            const mutable = try allocate(self, &body, child_type, length);

            try copy(self, &body, mutable, source);

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

            result = try pair(self, mutable, unit);
        },
        .push, .concat => append: {
            const added = if (operation.kind == .push) try self.builder.integer(1) else try self.field(arguments[0], "len");
            const count = try addLength(self, length, added);

            if (storage) |capacity| {
                try body.append(self.allocator, .{ .discard = count });
                try capacity.prepare(self, &body, source);
                try body.append(self.allocator, .{ .expression = try capacity.method(self, if (operation.kind == .push) "append" else "appendSlice", arguments, true) });

                result = try pair(self, try capacity.items(self), unit);

                break :append;
            }

            const buffer = try allocate(self, &body, child_type, count);

            try copy(self, &body, try slice(self, buffer, null, length), source);

            if (operation.kind == .push) {
                try body.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .index = .{ .target = buffer, .index = length } }), .value = arguments[0] } });
            } else try copy(self, &body, try slice(self, buffer, length, null), arguments[0]);

            result = try pair(self, buffer, unit);
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
            const buffer = try allocate(self, &body, child_type, total);
            const tail = try slice(self, buffer, begin, null);

            try copy(self, &body, try slice(self, buffer, null, begin), try slice(self, source, null, begin));
            try copy(self, &body, try slice(self, tail, null, inserted), replacement);
            try copy(self, &body, try slice(self, buffer, try intrinsic.binary(self, .add, begin, inserted), null), try slice(self, source, end, null));

            result = try pair(self, buffer, try slice(self, source, begin, end));
        },
    }

    return aggregate.finish(self, &body, if (layout) |target| try self.cast(target, try @import("state_value/origin.zig").tuple(self, type_id, result)) else try self.construct(type_id, result));
}

fn slice(self: *Lower, target: *const node.Expression, start: ?*const node.Expression, end: ?*const node.Expression) Lower.Error!*const node.Expression {
    return self.builder.expression(.{ .slice = .{ .target = target, .start = start, .end = end } });
}

fn pair(self: *Lower, left: *const node.Expression, right: *const node.Expression) Lower.Error!*const node.Expression {
    return self.builder.expression(.{ .tuple = try self.allocator.dupe(*const node.Expression, &.{ left, right }) });
}

fn addLength(self: *Lower, left: *const node.Expression, right: *const node.Expression) Lower.Error!*const node.Expression {
    return intrinsic.standard(self, &.{ "math", "add" }, &.{ try self.builder.expression(.{ .primitive = .usize }), left, right }, true);
}

fn allocate(self: *Lower, body: *std.ArrayList(node.Statement), element: *const node.Expression, length: *const node.Expression) Lower.Error!*const node.Expression {
    return aggregate.bind(self, body, try self.call(try self.field(try self.builder.identifier("allocator"), "alloc"), &.{ element, length }, true));
}

fn copy(self: *Lower, body: *std.ArrayList(node.Statement), target: *const node.Expression, source: *const node.Expression) Lower.Error!void {
    try body.append(self.allocator, .{ .expression = try self.builtin(.memcpy, &.{ target, source }) });
}
