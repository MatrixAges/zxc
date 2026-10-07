const std = @import("std");
const ir = @import("zx").ir;
const model = @import("model.zig");
const Storage = @import("storage.zig");
const enumeration = @import("enumeration.zig");

pub fn expression(self: *Storage, allocator: std.mem.Allocator, input: ir.Expression) std.mem.Allocator.Error!u32 {
    var source = input;
    const retained = @import("retained.zig").offset(self, source);

    try @import("reserve.zig").expression(self, allocator, source);
    if (retained) |first| @import("retained.zig").restore(self, &source, first);

    const id: u32 = @intCast(self.kinds.items.len);

    const row: struct { model.ExpressionKind, usize } = switch (source.value) {
        .none => .{ .None, 0 },
        .unit => .{ .Unit, 0 },
        .integer => |value| blk: {
            const payload = self.integers.items.len;

            self.integers.appendAssumeCapacity(value);

            break :blk .{ .Integer, payload };
        },
        .negative_integer => |value| blk: {
            const payload = self.negative_integers.items.len;

            self.negative_integers.appendAssumeCapacity(value);

            break :blk .{ .NegativeInteger, payload };
        },
        .float => |value| blk: {
            const payload = self.floats.items.len;

            self.floats.appendAssumeCapacity(value);

            break :blk .{ .Float, payload };
        },
        .string => |value| blk: {
            const payload = self.strings.items.len;

            self.strings.appendAssumeCapacity(value);

            break :blk .{ .String, payload };
        },
        .boolean => |value| blk: {
            const payload = self.booleans.items.len;

            self.booleans.appendAssumeCapacity(value);

            break :blk .{ .Boolean, payload };
        },
        .some => |value| blk: {
            const payload = self.some.items.len;

            self.some.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .Some, payload };
        },
        .capture => |value| blk: {
            const payload = self.captures.items.len;

            self.captures.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .Capture, payload };
        },
        .await_task => |value| blk: {
            const payload = self.awaits.items.len;

            self.awaits.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .AwaitTask, payload };
        },
        .cancel_task => |value| blk: {
            const payload = self.cancellations.items.len;

            self.cancellations.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .CancelTask, payload };
        },
        .optional_value => |value| blk: {
            const payload = self.optional_values.items.len;

            self.optional_values.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .OptionalValue, payload };
        },
        .enum_value => |value| blk: {
            const payload = self.enumerations.items.len;

            self.enumerations.appendAssumeCapacity(value);

            break :blk .{ .EnumValue, payload };
        },
        .error_value => |value| blk: {
            const payload = self.errors.items.len;

            self.errors.appendAssumeCapacity(value);

            break :blk .{ .ErrorValue, payload };
        },
        .reference => |value| blk: {
            const payload = self.references.items.len;

            self.references.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .Reference, payload };
        },
        .store_get => |value| blk: {
            const payload = self.stores.items.len;

            self.stores.appendAssumeCapacity(value);

            break :blk .{ .StoreGet, payload };
        },
        .length => |value| blk: {
            const payload = self.lengths.items.len;

            self.lengths.appendAssumeCapacity(@backingInt(value));

            break :blk .{ .Length, payload };
        },
        .field => |value| blk: {
            const payload = self.projection_targets.items.len;

            self.projection_targets.appendAssumeCapacity(@backingInt(value.target));
            self.projection_indices.appendAssumeCapacity(value.index);

            break :blk .{ .Field, payload };
        },
        .tuple_field => |value| blk: {
            const payload = self.projection_targets.items.len;

            self.projection_targets.appendAssumeCapacity(@backingInt(value.target));
            self.projection_indices.appendAssumeCapacity(value.index);

            break :blk .{ .TupleField, payload };
        },
        .index => |value| blk: {
            const payload = self.index_targets.items.len;

            self.index_targets.appendAssumeCapacity(@backingInt(value.target));
            self.index_values.appendAssumeCapacity(@backingInt(value.index));

            break :blk .{ .Index, payload };
        },
        .unary => |value| blk: {
            const payload = self.unary_operands.items.len;

            self.unary_operators.appendAssumeCapacity(enumeration.convert(model.UnaryOperator, value.operator));
            self.unary_operands.appendAssumeCapacity(@backingInt(value.operand));

            break :blk .{ .Unary, payload };
        },
        .binary => |value| blk: {
            const payload = self.binary_left.items.len;

            self.binary_operators.appendAssumeCapacity(enumeration.convert(model.BinaryOperator, value.operator));
            self.binary_left.appendAssumeCapacity(@backingInt(value.left));
            self.binary_right.appendAssumeCapacity(@backingInt(value.right));

            break :blk .{ .Binary, payload };
        },
        .conditional => |value| blk: {
            const payload = self.conditional_conditions.items.len;

            self.conditional_conditions.appendAssumeCapacity(@backingInt(value.condition));
            self.conditional_yes.appendAssumeCapacity(@backingInt(value.yes));
            self.conditional_no.appendAssumeCapacity(@backingInt(value.no));

            break :blk .{ .Conditional, payload };
        },
        .list_update => |value| blk: {
            const payload = self.update_targets.items.len;

            self.update_targets.appendAssumeCapacity(@backingInt(value.target));
            self.update_indices.appendAssumeCapacity(@backingInt(value.index));
            self.update_values.appendAssumeCapacity(@backingInt(value.value));

            break :blk .{ .ListUpdate, payload };
        },
        .list => |value| .{ .List, @import("append/collections.zig").sequence(self, value) },
        .tuple => |value| .{ .Tuple, @import("append/collections.zig").sequence(self, value) },
        .template => |value| .{ .Template, @import("append/collections.zig").sequence(self, value) },
        .list_operation => |value| .{ .ListOperation, @import("append/collections.zig").collection(self, value) },
        .transform => |value| .{ .Transform, @import("append/collections.zig").transform(self, value) },
        .task => |value| .{ .Task, @import("append/control.zig").task(self, value) },
        .parallel => |value| .{ .Parallel, @import("append/control.zig").parallel(self, value) },
        .iteration => |value| .{ .Iteration, @import("append/control.zig").iteration(self, value) },
        .scope => |value| .{ .Scope, @import("append/aggregates.zig").scope(self, value) },
        .call => |value| .{ .Call, @import("append/aggregates.zig").call(self, value) },
        .match_expr => |value| .{ .Match, @import("append/aggregates.zig").match(self, value) },
        .object => |value| .{ .Object, @import("append/aggregates.zig").object(self, value) },
    };

    self.kinds.appendAssumeCapacity(row[0]);
    self.payloads.appendAssumeCapacity(@intCast(row[1]));
    self.types.appendAssumeCapacity(@backingInt(source.type_id));
    self.span_start.appendAssumeCapacity(source.span.start);
    self.span_end.appendAssumeCapacity(source.span.end);

    return id;
}
