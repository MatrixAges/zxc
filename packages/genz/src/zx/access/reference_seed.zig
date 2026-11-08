const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, symbol: ir.SymbolId, type_id: ir.TypeId) Lower.Error!node.ExpressionId {
    self.used[@backingInt(symbol)] = true;

    const reference = try self.builder.identifier(self.names[@backingInt(symbol)]);
    const value_reference = if (self.stack_symbols.contains(symbol)) try self.builder.expression(.{ .address_of = reference }) else reference;

    if (self.state_active and !self.state_symbols.contains(symbol)) {
        var body: std.ArrayList(node.Statement) = .empty;
        const converted = try @import("../state_value/conversion.zig").convert(self, &body, type_id, value_reference, if (self.public_value_output and @backingInt(symbol) == 0) .view_value else .value);

        return @import("../aggregate.zig").finish(self, &body, converted);
    }

    return value_reference;
}
