const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, values: ir.Block) Lower.Error![]const node.Statement {
    const state_symbols = try @import("state_value/locals.zig").statements(self, values);

    defer for (state_symbols) |symbol| {
        _ = self.state_symbols.remove(symbol);
    };

    const locals = @import("value_call/locals.zig");
    const stacked = try locals.register(self, values);

    defer for (stacked) |symbol| {
        _ = self.stack_symbols.remove(symbol);
    };

    const chunks = try self.allocator.alloc([]const node.Statement, values.len);
    var offset = values.len;

    while (offset > 0) {
        offset -= 1;
        var output: std.ArrayList(node.Statement) = .empty;
        var consumed_previous = false;

        if (try @import("store/begin.zig").statement(self, values, offset)) |begin| try output.append(self.allocator, begin);

        switch (values.at(offset)) {
            .evaluate => |id| try output.append(self.allocator, .{ .discard = try @import("iteration.zig").discard(self, id) }),
            .parallel => |invocations| try output.appendSlice(self.allocator, try @import("parallel/root.zig").lower(self, invocations)),
            .constant => |binding| binding_block: {
                if (@import("binding.zig").before(self, binding.value, binding.symbol, false) == .Task) {
                    try @import("tasks/root.zig").bind(self, &output, self.names[@backingInt(binding.symbol)], binding.value, false);

                    break :binding_block;
                }

                const borrowed = try locals.optionalCall(self, &output, binding.symbol, binding.value, self.program.output_type);
                const value = borrowed orelse if (self.stack_symbols.contains(binding.symbol)) try @import("value_call/root.zig").expression(self, binding.value) else try self.expr(binding.value);

                try @import("binding.zig").append(self, &output, .{
                    .symbol = binding.symbol,
                    .value = value,
                    .by_value = self.stack_symbols.contains(binding.symbol),
                });
            },
            .destructure => |binding| try @import("statements/destructure/lower.zig").append(self, &output, binding),
            .result => |value| {
                var returned: ?node.ExpressionId = null;

                if (value) |id| {
                    if (offset + 1 == values.len and offset != 0 and values.at(offset - 1) == .constant) {
                        const binding = values.at(offset - 1).constant;
                        returned = try @import("iteration_consumer.zig").lower(self, binding.symbol, binding.value, id, self.value_output);
                        consumed_previous = returned != null;
                    }

                    if (returned == null) returned = if (self.value_output) try @import("value_call/root.zig").expression(self, id) else try self.expr(id);
                    if (self.state_active) returned = try @import("state_value/ownership.zig").clip(self, &output, id, returned.?);
                }

                if (self.public_value_output and self.state_active) if (returned) |result| {
                    const boundary = try @import("aggregate.zig").bind(self, &output, result);
                    returned = try @import("state_value/conversion.zig").convert(self, &output, self.program.output_type, boundary, .view_layout);
                };

                if (self.transaction()) {
                    if (returned) |result| {
                        const name = try self.fresh("output");

                        try output.append(self.allocator, .{ .constant = .{ .name = name, .value = result } });

                        returned = try self.builder.identifier(name);
                    }

                    try output.append(self.allocator, .{ .expression = try self.commit() });
                }

                try output.append(self.allocator, .{ .result = returned });
            },
            .branch => |branch| try output.append(self.allocator, .{ .branch = .{ .condition = try self.expr(branch.condition), .yes = try self.builder.statements(try lower(self, branch.yes)), .no = try self.builder.statements(try lower(self, branch.no)) } }),
            .switch_stmt => |selection| try output.appendSlice(self.allocator, try switchStatement(self, selection)),
            .store_set => |setter| {
                const name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{setter.slot});

                try output.append(self.allocator, .{ .assignment = .{ .target = try self.field(try self.builder.identifier("pending"), name), .value = try self.expr(setter.value) } });
            },
        }

        chunks[offset] = try output.toOwnedSlice(self.allocator);

        if (consumed_previous) {
            offset -= 1;
            chunks[offset] = &.{};
        }
    }

    var output: std.ArrayList(node.Statement) = .empty;

    for (chunks) |chunk| try output.appendSlice(self.allocator, chunk);

    return output.toOwnedSlice(self.allocator);
}

fn switchStatement(self: *Lower, selection: @FieldType(ir.StatementRow, "switch_stmt")) Lower.Error![]const node.Statement {
    return @import("statements/switch/lower.zig").lower(self, selection);
}

pub const writes = @import("control/writes.zig").writes;
