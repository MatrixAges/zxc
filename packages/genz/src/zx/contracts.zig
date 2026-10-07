const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn preconditions(self: *Lower) Lower.Error![]const node.Statement {
    var statements: std.ArrayList(node.Statement) = .empty;

    for (0..self.program.contracts.count()) |contract_index| {
        const contract = self.program.contracts.at(contract_index);

        if (contract.kind != .requires) continue;

        var predicate = self.*;

        predicate.program.symbols = contract.symbols;
        predicate.program.expressions = contract.expressions;
        predicate.names = try self.allocator.dupe([]const u8, &.{"in"});
        predicate.used = try self.allocator.alloc(bool, 1);
        predicate.cache_reads = try self.allocator.alloc(usize, contract.expressions.count());
        predicate.cache = .empty;
        predicate.stack_symbols = .empty;
        predicate.uses_allocator = false;
        predicate.uses_io = false;

        @memset(predicate.used, false);
        @memset(predicate.cache_reads, 0);

        const value = try predicate.expr(contract.predicate);

        try @import("intrinsics.zig").failIf(self, &statements, try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = value } }), "PreconditionFailed");

        self.used[0] = self.used[0] or predicate.used[0];
        self.uses_allocator = self.uses_allocator or predicate.uses_allocator;
        self.uses_io = self.uses_io or predicate.uses_io;
        self.serial = predicate.serial;
    }

    return statements.toOwnedSlice(self.allocator);
}
