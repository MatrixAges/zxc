const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const analysis = @import("analysis.zig");

pub fn register(self: *Lower, statements: ir.Block) Lower.Error![]const ir.SymbolId {
    if (!self.value_output and !self.entry_flags.scalar) return &.{};

    var symbols: std.ArrayList(ir.SymbolId) = .empty;

    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .constant => |binding| {
                const type_id = self.program.symbols.at(@backingInt(binding.symbol)).type_id;

                if (@import("../state_value/root.zig").selected(self, type_id)) continue;
                if (self.program.typeOf(type_id) != .object or analysis.containsDescendant(self.program, self.program.output_type, type_id)) continue;
                if (self.stack_symbols.contains(binding.symbol)) continue;
                if (try borrowed(self, binding.symbol, binding.value)) continue;
                try symbols.append(self.allocator, binding.symbol);
                try self.stack_symbols.put(self.allocator, binding.symbol, {});
            },
            else => {},
        }
    }

    return symbols.toOwnedSlice(self.allocator);
}

pub fn borrowed(self: *Lower, symbol: ir.SymbolId, value: ir.ExprId) Lower.Error!bool {
    const type_id = self.program.symbols.at(@backingInt(symbol)).type_id;

    if (!self.state_active or self.state_plan.represented(self.program, type_id)) return false;

    switch (self.program.expression(value).value) {
        .reference, .field, .tuple_field, .index, .optional_value => {},
        else => return false,
    }

    if (inputProjection(self.program, value)) return true;
    if (self.projected_symbols == null) self.projected_symbols = try @import("projections.zig").symbols(self.allocator, self.program);

    return self.projected_symbols.?[@backingInt(symbol)];
}

fn inputProjection(program: ir.Program, id: ir.ExprId) bool {
    var current = id;

    while (true) switch (program.expression(current).value) {
        .field, .tuple_field => |projection| current = projection.target,
        .optional_value => |child| current = child,
        .reference => |symbol| return @backingInt(symbol) == 0,
        else => return false,
    };
}
