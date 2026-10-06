const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, values: []const ir.Statement) Lower.Error![]const node.Statement {
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

        switch (values[offset]) {
            .evaluate => |id| try output.append(self.allocator, .{ .discard = try @import("iteration.zig").discard(self, id) }),
            .parallel => |invocations| try output.appendSlice(self.allocator, try @import("parallel/root.zig").lower(self, invocations)),
            .constant => |binding| binding_block: {
                if (self.program.typeOf(self.program.expression(binding.value).type_id) == .task) {
                    try @import("tasks/root.zig").bind(self, &output, self.names[@backingInt(binding.symbol)], binding.value, false);

                    break :binding_block;
                }

                const value = if (self.stack_symbols.contains(binding.symbol)) try @import("value_call/root.zig").expression(self, binding.value) else try self.expr(binding.value);
                const index = @backingInt(binding.symbol);

                if (self.used[index]) try output.append(self.allocator, .{ .constant = .{ .name = self.names[index], .type_expr = if (self.stack_symbols.contains(binding.symbol)) self.layouts[@backingInt(self.program.symbols[index].type_id)] else self.types[@backingInt(self.program.symbols[index].type_id)], .value = value } }) else try output.append(self.allocator, .{ .discard = value });
            },
            .destructure => |binding| {
                const name = try self.fresh("tuple");
                const value = self.program.expression(binding.value);
                const tuple = if (value.value == .capture) try @import("capture.zig").lowerValue(self, value.type_id, value.value.capture) else try self.expr(binding.value);

                try output.append(self.allocator, .{ .constant = .{ .name = name, .value = tuple } });

                var used = false;

                for (binding.symbols, 0..) |symbol, index| {
                    if (symbol) |id| {
                        if (self.used[@backingInt(id)]) {
                            used = true;

                            try output.append(self.allocator, .{ .constant = .{ .name = self.names[@backingInt(id)], .value = try self.field(try self.builder.identifier(name), try std.fmt.allocPrint(self.allocator, "{d}", .{index})) } });
                        }
                    }
                }

                if (!used) try output.append(self.allocator, .{ .discard = try self.builder.identifier(name) });
            },
            .result => |value| {
                var returned: ?*const node.Expression = null;

                if (value) |id| {
                    if (offset + 1 == values.len and offset != 0 and values[offset - 1] == .constant) {
                        const binding = values[offset - 1].constant;
                        returned = try @import("iteration_consumer.zig").lower(self, binding.symbol, binding.value, id);
                        consumed_previous = returned != null;
                    }

                    if (returned == null) returned = if (self.value_output) try @import("value_call/root.zig").expression(self, id) else try self.expr(id);
                }

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
            .branch => |branch| try output.append(self.allocator, .{ .branch = .{ .condition = try self.expr(branch.condition), .yes = try lower(self, branch.yes), .no = try lower(self, branch.no) } }),
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

fn switchStatement(self: *Lower, selection: @FieldType(ir.Statement, "switch_stmt")) Lower.Error![]const node.Statement {
    const name = try self.fresh("switch");
    const subject = try self.expr(selection.subject);
    const old = self.cache.get(selection.subject);

    try self.cache.put(self.allocator, selection.subject, try self.builder.identifier(name));

    defer {
        if (old) |previous| self.cache.put(self.allocator, selection.subject, previous) catch unreachable else _ = self.cache.remove(selection.subject);
    }

    var tail: []const node.Statement = if (selection.exhaustive) try self.allocator.dupe(node.Statement, &.{.unreachable_stmt}) else &.{};

    for (selection.cases) |case| if (case.value == null) {
        tail = try lower(self, case.body);
    };

    var index = selection.cases.len;

    while (index > 0) {
        index -= 1;
        const case = selection.cases[index];

        if (case.value) |label| {
            tail = try self.allocator.dupe(node.Statement, &.{.{ .branch = .{ .condition = try self.binary(.{ .operator = .equal, .left = selection.subject, .right = label }), .yes = try lower(self, case.body), .no = tail } }});
        }
    }

    var result: std.ArrayList(node.Statement) = .empty;

    try result.append(self.allocator, .{ .constant = .{ .name = name, .value = subject } });
    if (selection.cases.len == 0 or (selection.cases.len == 1 and selection.cases[0].value == null)) try result.append(self.allocator, .{ .discard = try self.builder.identifier(name) });
    try result.appendSlice(self.allocator, tail);

    return result.toOwnedSlice(self.allocator);
}

pub fn writes(values: []const ir.Statement) bool {
    for (values) |value| {
        switch (value) {
            .store_set => return true,
            .branch => |branch| if (writes(branch.yes) or writes(branch.no)) {
                return true;
            },
            .switch_stmt => |selection| for (selection.cases) |case| {
                if (writes(case.body)) return true;
            },
            else => {},
        }
    }

    return false;
}
