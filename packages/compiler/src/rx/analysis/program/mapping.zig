const std = @import("std");
const ir = @import("zx").ir;
const Error = @import("builder.zig").Error;
const missing = @import("linking.zig").missing;
const operands = @import("linking/operands.zig");
const Self = @This();
const Value = @FieldType(ir.Expression, "value");

allocator: std.mem.Allocator,
bindings: []const u32,
locals_base: usize,
symbol_count: usize,
expressions: []const u32,

available: usize = 0,
pub fn id(self: *const Self, value: ir.ExprId) Error!ir.ExprId {
    return self.scalar(ir.ExprId, value);
}

pub fn seedId(self: *const Self, value: ir.ExprId) Error!ir.ExprId {
    const index = @backingInt(value);

    if (index >= self.available) return error.InvalidModule;

    const target = self.expressions[index];

    return if (target == missing) error.InvalidModule else @fromBackingInt(target);
}

pub fn seedSymbol(self: *const Self, value: ir.SymbolId) Error!ir.SymbolId {
    const index = @backingInt(value);

    if (index == 0 or index >= self.symbol_count) return error.InvalidModule;

    const offset = index - 1;

    if (offset >= self.bindings.len) return @fromBackingInt(@intCast(self.locals_base + (offset - self.bindings.len)));

    const target = self.bindings[offset];

    return if (target == missing) error.InvalidModule else @fromBackingInt(target);
}

pub fn expression(self: *const Self, value: ir.ExpressionRow) Error!ir.Expression {
    return .{
        .type_id = value.type_id,
        .span = value.span,
        .value = switch (value.value) {
            .string => |text| .{ .string = try self.allocator.dupe(u8, text) },
            .list, .tuple, .template, .list_operation, .transform, .scope, .match_expr, .object, .store_get, .call, .task, .await_task, .cancel_task, .parallel => unreachable,
            inline else => |item, tag| @unionInit(Value, @tagName(tag), try self.fixed(item)),
        },
    };
}

fn fixed(self: *const Self, value: anytype) Error!@TypeOf(value) {
    const T = @TypeOf(value);

    if (comptime T == ir.ExprId or T == ir.SymbolId) return self.scalar(T, value);
    if (comptime @typeInfo(T) != .@"struct") return value;

    return self.fields(ir.SymbolId, try self.fields(ir.ExprId, value));
}

fn scalar(self: *const Self, comptime Id: type, value: Id) Error!Id {
    var output: [1]Id = undefined;

    try self.transfer(Id, &.{value}, &output);

    return output[0];
}

fn fields(self: *const Self, comptime Id: type, value: anytype) Error!@TypeOf(value) {
    const T = @TypeOf(value);
    const names = @typeInfo(T).@"struct".field_names;

    const capacity = comptime count: {
        var total: usize = 0;

        for (names) |name| {
            const Field = @FieldType(T, name);

            if (Field == Id or Field == ?Id) total += 1;
        }

        break :count total;
    };

    if (comptime capacity == 0) return value;

    var input: [capacity]Id = undefined;
    var output: [capacity]Id = undefined;
    var length: usize = 0;

    inline for (names) |name| {
        const Field = @FieldType(T, name);

        if (comptime Field == Id or Field == ?Id) {
            const source: ?Id = @field(value, name);

            if (source) |operand| {
                input[length] = operand;
                length += 1;
            }
        }
    }

    try self.transfer(Id, input[0..length], output[0..length]);

    var result = value;
    var cursor: usize = 0;

    inline for (names) |name| {
        const Field = @FieldType(T, name);

        if (comptime Field == Id or Field == ?Id) {
            const source: ?Id = @field(value, name);

            if (source != null) {
                @field(result, name) = output[cursor];

                cursor += 1;
            }
        }
    }

    return result;
}

fn transfer(self: *const Self, comptime Id: type, source: []const Id, target: []Id) Error!void {
    if (comptime Id == ir.ExprId) return operands.expressions(self, @ptrCast(source), @ptrCast(target));

    return operands.symbols(self, @ptrCast(source), @ptrCast(target));
}
