const ir = @import("zx").ir;
const Value = @FieldType(ir.ExpressionRow, "value");
const Self = @This();

value: Value,
len: usize,
pub fn init(value: Value) Self {
    const len: usize = switch (value) {
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value, .reference, .store_get => 0,
        .some, .capture, .task, .await_task, .cancel_task, .optional_value, .field, .length, .tuple_field, .call, .unary => 1,
        .index, .binary => 2,
        .iteration, .list_update, .conditional => 3,
        .parallel => |items| items.len,
        .list, .tuple, .template => |items| items.len,
        .list_operation => |item| 1 + item.arguments.len,
        .transform => |item| 2 + @as(usize, @intFromBool(item.initial != null)),
        .scope => |item| item.bindings.len + 1,
        .match_expr => |item| @as(usize, @intFromBool(item.subject != null)) + item.arms.len * 2 + 1,
        .object => |item| item.fields.len + item.evaluation.len,
    };

    return .{ .value = value, .len = len };
}

pub fn at(self: Self, index: usize) ir.ExprId {
    return switch (self.value) {
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value, .reference, .store_get => unreachable,
        .some, .capture, .await_task, .cancel_task, .optional_value, .length => |id| id,
        .field, .tuple_field => |item| item.target,
        .task => |item| item.body,
        .parallel => |items| items.at(index).task,
        .list, .tuple, .template => |items| items[index],
        .index => |item| if (index == 0) item.target else item.index,
        .list_operation => |item| if (index == 0) item.target else item.arguments[index - 1],
        .transform => |item| switch (index) {
            0 => item.target,
            1 => item.body,
            else => item.initial.?,
        },
        .scope => |item| if (index < item.bindings.len) item.bindings.at(index).value else item.result,
        .iteration => |item| switch (index) {
            0 => item.initial,
            1 => item.condition,
            else => item.body,
        },
        .list_update => |item| switch (index) {
            0 => item.target,
            1 => item.index,
            else => item.value,
        },
        .call => |item| item.argument,
        .unary => |item| item.operand,
        .binary => |item| if (index == 0) item.left else item.right,
        .conditional => |item| switch (index) {
            0 => item.condition,
            1 => item.yes,
            else => item.no,
        },
        .match_expr => |item| blk: {
            if (index == 0) {
                if (item.subject) |subject| break :blk subject;
            }

            const position = index - @intFromBool(item.subject != null);

            if (position == item.arms.len * 2) break :blk item.fallback;

            const arm = item.arms.at(position / 2);

            break :blk if (position % 2 == 0) arm.condition else arm.result;
        },
        .object => |item| if (index < item.fields.len) item.fields.at(index).value else item.evaluation[index - item.fields.len],
    };
}
