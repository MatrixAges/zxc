const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, values: []const ir.Statement) Lower.Error![]const node.Statement {
    const chunks = try self.allocator.alloc([]const node.Statement, values.len);
    var offset = values.len;

    while (offset > 0) {
        offset -= 1;

        var output: std.ArrayList(node.Statement) = .empty;

        if (try @import("store/begin.zig").statement(self, values, offset)) |begin| try output.append(self.allocator, begin);

        switch (values[offset]) {
            .evaluate => |id| try output.append(self.allocator, .{ .discard = try self.expr(id) }),
            .parallel => |invocations| try output.appendSlice(self.allocator, try @import("parallel/root.zig").lower(self, invocations)),
            .constant => |binding| {
                const value = try self.expr(binding.value);
                const index = @intFromEnum(binding.symbol);

                if (self.used[index]) try output.append(self.allocator, .{ .constant = .{ .name = self.names[index], .type_expr = self.types[@intFromEnum(self.program.symbols[index].type_id)], .value = value } }) else try output.append(self.allocator, .{ .discard = value });
            },
            .destructure => |binding| {
                const name = try self.fresh("tuple");

                try output.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.expr(binding.value) } });

                var used = false;

                for (binding.symbols, 0..) |symbol, index| {
                    if (symbol) |id| {
                        if (self.used[@intFromEnum(id)]) {
                            used = true;

                            try output.append(self.allocator, .{ .constant = .{ .name = self.names[@intFromEnum(id)], .value = try self.field(try self.builder.identifier(name), try std.fmt.allocPrint(self.allocator, "{d}", .{index})) } });
                        }
                    }
                }

                if (!used) try output.append(self.allocator, .{ .discard = try self.builder.identifier(name) });
            },
            .result => |value| {
                var returned: ?*const node.Expression = if (value) |id| if (self.value_output) try @import("value_call/root.zig").expression(self, id) else try self.expr(id) else null;

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
