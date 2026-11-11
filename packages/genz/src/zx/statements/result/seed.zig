const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub fn append(self: *Lower, output: *std.ArrayList(node.Statement), values: ir.Block, offset: usize, value: ?ir.ExprId) Lower.Error!bool {
    var consumed_previous = false;
    var returned: ?node.ExpressionId = null;

    if (value) |id| {
        if (offset + 1 == values.len and offset != 0 and values.at(offset - 1) == .constant) {
            const binding = values.at(offset - 1).constant;
            returned = try @import("../../iteration_consumer.zig").lower(self, binding.symbol, binding.value, id, self.value_output);
            consumed_previous = returned != null;
        }

        if (returned == null) returned = if (self.value_output) try @import("../../value_call/root.zig").expression(self, id) else try self.expr(id);
        if (self.state_active) returned = try @import("../../state_value/ownership.zig").clip(self, output, id, returned.?);
    }

    if (self.public_value_output and self.state_active) if (returned) |result| {
        const boundary = try @import("../../aggregate.zig").bind(self, output, result);
        returned = try @import("../../state_value/conversion.zig").convert(self, output, self.program.output_type, boundary, .view_layout);
    };

    if (self.transaction()) {
        if (returned) |result| {
            const name = try self.fresh("output");

            try output.append(self.allocator, .{ .constant = .{ .name = name, .value = result } });

            returned = try self.builder.identifier(name);
        }

        try output.append(self.allocator, .{ .expression = try @import("../../store/transaction_seed.zig").commit(self) });
    }

    try output.append(self.allocator, .{ .result = returned });

    return consumed_previous;
}
