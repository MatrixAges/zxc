const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");

pub fn statements(self: *Lower, values: ir.Block) Lower.Error![]const ir.SymbolId {
    var symbols: std.ArrayList(ir.SymbolId) = .empty;

    if (self.state_active) for (0..values.len) |value_index| {
        const value = values.at(value_index);

        switch (value) {
            .constant => |binding| try add(self, &symbols, binding.symbol),
            .destructure => |binding| for (0..binding.symbols.len) |symbol_index| {
                const symbol = binding.symbols.at(symbol_index);

                if (symbol) |id| {
                    try add(self, &symbols, id);
                }
            },
            else => {},
        }
    };

    return symbols.toOwnedSlice(self.allocator);
}

pub fn scope(self: *Lower, value: ir.ScopeRow) Lower.Error![]const ir.SymbolId {
    var symbols: std.ArrayList(ir.SymbolId) = .empty;

    if (self.state_active) for (0..value.bindings.len) |record_index| {
        const binding = value.bindings.at(record_index);

        if (binding.symbol) |symbol| {
            try add(self, &symbols, symbol);
        }
    };

    return symbols.toOwnedSlice(self.allocator);
}

pub fn parameters(self: *Lower, values: []const ir.SymbolId) Lower.Error![]const ir.SymbolId {
    var symbols: std.ArrayList(ir.SymbolId) = .empty;

    if (self.state_active) for (values) |id| try add(self, &symbols, id);

    return symbols.toOwnedSlice(self.allocator);
}

fn add(self: *Lower, symbols: *std.ArrayList(ir.SymbolId), id: ir.SymbolId) Lower.Error!void {
    if (!self.state_plan.represented(self.program, self.program.symbols.at(@backingInt(id)).type_id) or self.state_symbols.contains(id)) return;
    try symbols.append(self.allocator, id);
    try self.state_symbols.put(self.allocator, id, {});
}
