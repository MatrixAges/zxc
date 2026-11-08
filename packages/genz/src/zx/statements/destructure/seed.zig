const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub fn append(self: *Lower, output: *std.ArrayList(node.Statement), binding: @FieldType(ir.StatementRow, "destructure")) Lower.Error!void {
    const name = try self.fresh("tuple");
    const value = self.program.expression(binding.value);
    const tuple = if (value.value == .capture) try @import("../../capture.zig").lowerValue(self, value.type_id, value.value.capture) else try self.expr(binding.value);

    try output.append(self.allocator, .{ .constant = .{ .name = name, .value = tuple } });

    var used = false;

    for (0..binding.symbols.len) |index| {
        const symbol = binding.symbols.at(index);

        if (symbol) |id| {
            if (self.used[@backingInt(id)]) {
                used = true;

                try output.append(self.allocator, .{ .constant = .{ .name = self.names[@backingInt(id)], .value = try self.field(try self.builder.identifier(name), try std.fmt.allocPrint(self.allocator, "{d}", .{index})) } });
            }
        }
    }

    if (!used) try output.append(self.allocator, .{ .discard = try self.builder.identifier(name) });
}
