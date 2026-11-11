const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const generated = @import("genz_options").generated_analysis;

pub fn preconditions(self: *Lower) Lower.Error![]const node.Statement {
    var statements: std.ArrayList(node.Statement) = .empty;
    const contracts = self.program.contracts;
    var start: usize = 0;

    while (start < contracts.count()) {
        const index = if (generated) next(contracts.kinds, start) orelse break else start;

        start = index + 1;

        if (!generated and contracts.kinds[index] != .Requires) continue;

        const contract = contracts.at(index);
        var predicate = self.*;
        predicate.state_symbols = self.state_symbols.inherit();
        predicate.program.symbols = contract.symbols;
        predicate.program.expressions = contract.expressions;

        try predicate.refreshEntry();

        predicate.names = try self.allocator.dupe([]const u8, &.{"in"});
        predicate.used = try self.allocator.alloc(bool, 1);
        predicate.cache_reads = try self.allocator.alloc(u64, contract.expressions.count());
        predicate.cache = .empty;
        predicate.stack_symbols = .empty;
        predicate.uses_allocator = false;
        predicate.uses_io = false;

        @memset(predicate.used, false);
        @memset(predicate.cache_reads, 0);

        const value = try predicate.expr(contract.predicate);

        if (generated) {
            try @import("intrinsics/guard.zig").precondition(self, &statements, value);
        } else {
            try @import("intrinsics.zig").failIf(self, &statements, try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = value } }), "PreconditionFailed");
        }

        self.used[0] = self.used[0] or predicate.used[0];
        self.uses_allocator = self.uses_allocator or predicate.uses_allocator;
        self.uses_io = self.uses_io or predicate.uses_io;
        self.serial = predicate.serial;
        self.reference_storage = predicate.reference_storage;
    }

    return statements.toOwnedSlice(self.allocator);
}

fn next(kinds: []const zx.ir.ContractTable.Kind, start: usize) ?usize {
    const entry = @import("generated_precondition_next");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .kinds = zx.columns.slice(@FieldType(Input, "kinds"), kinds), .start = start };
    var memory = std.heap.FixedBufferAllocator.init(&.{});
    const index = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;

    return if (index) |value| @intCast(value) else null;
}
