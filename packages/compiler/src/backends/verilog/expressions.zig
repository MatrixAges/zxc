const std = @import("std");
const ir = @import("../hardware/ir.zig");

pub fn write(writer: *std.Io.Writer, module: ir.Module, node: ir.Node) std.Io.Writer.Error!void {
    switch (node.value) {
        .input => |index| try writer.writeAll(module.inputs[index].name),
        .constant => |value| try writer.print("{d}'d{d}", .{ node.sort.width, value }),
        .invert => |operand| try writer.print("!n_{d}", .{@intFromEnum(operand)}),
        .negate => |operand| try writer.print("-n_{d}", .{@intFromEnum(operand)}),
        .select => |selection| try writer.print("n_{d} ? n_{d} : n_{d}", .{ @intFromEnum(selection.condition), @intFromEnum(selection.yes), @intFromEnum(selection.no) }),
        .extend => |extension| {
            const index = @intFromEnum(extension.operand);
            const width = module.nodes[index].sort.width;

            if (extension.extra == 0) {
                try writer.print("n_{d}", .{index});
            } else if (extension.signed) {
                try writer.print("{{{{{d}{{n_{d}[{d}]}}}}, n_{d}}}", .{ extension.extra, index, width - 1, index });
            } else try writer.print("{{{d}'d0, n_{d}}}", .{ extension.extra, index });
        },
        .binary => |binary| {
            const left = @intFromEnum(binary.left);
            const right = @intFromEnum(binary.right);
            const operator = binary.operator;

            const token: []const u8 = switch (operator) {
                .logical_and => "&&",
                .logical_or => "||",
                .equal => "==",
                .add => "+",
                .subtract => "-",
                .multiply => "*",
                .unsigned_divide, .signed_divide => "/",
                .unsigned_remainder, .signed_remainder => "%",
                .unsigned_less, .signed_less => "<",
                .unsigned_less_equal, .signed_less_equal => "<=",
                .unsigned_greater, .signed_greater => ">",
                .unsigned_greater_equal, .signed_greater_equal => ">=",
            };

            if (operator == .signed_remainder) {
                const width = module.nodes[left].sort.width;

                try writer.print("$signed({{n_{d}[{d}], n_{d}}}) % $signed({{n_{d}[{d}], n_{d}}})", .{ left, width - 1, left, right, width - 1, right });
            } else if (operator == .signed_divide or @intFromEnum(operator) >= @intFromEnum(ir.Operator.signed_less)) {
                try writer.print("$signed(n_{d}) {s} $signed(n_{d})", .{ left, token, right });
            } else try writer.print("n_{d} {s} n_{d}", .{ left, token, right });
        },
    }
}
