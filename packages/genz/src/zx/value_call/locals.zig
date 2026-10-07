const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const analysis = @import("analysis.zig");

pub fn register(self: *Lower, statements: ir.Block) Lower.Error![]const ir.SymbolId {
    if (!self.value_output and !analysis.scalarLocals(self.program, self.pure_functions)) return &.{};

    var symbols: std.ArrayList(ir.SymbolId) = .empty;

    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .constant => |binding| {
                const type_id = self.program.symbols.at(@backingInt(binding.symbol)).type_id;

                if (@import("../state_value/root.zig").selected(self, type_id)) continue;
                if (self.program.typeOf(type_id) != .object or analysis.containsDescendant(self.program, self.program.output_type, type_id)) continue;
                if (self.stack_symbols.contains(binding.symbol)) continue;
                try symbols.append(self.allocator, binding.symbol);
                try self.stack_symbols.put(self.allocator, binding.symbol, {});
            },
            else => {},
        }
    }

    return symbols.toOwnedSlice(self.allocator);
}
