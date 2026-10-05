const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("../analysis/types.zig");

pub fn validate(program: ir.Program) bool {
    var has_ensures = false;

    for (program.contracts) |contract| {
        if (contract.kind == .requires and has_ensures) return false;

        has_ensures = has_ensures or contract.kind == .ensures;

        const parameter_count: usize = if (contract.kind == .requires) 1 else 2;

        if (contract.symbols.len != parameter_count or @backingInt(contract.predicate) >= contract.expressions.len) return false;
        if (!std.mem.eql(u8, contract.symbols[0].name, "in") or contract.symbols[0].type_id != program.input_type) return false;
        if (parameter_count == 2 and (!std.mem.eql(u8, contract.symbols[1].name, "out") or contract.symbols[1].type_id != program.output_type)) return false;
        if (contract.expressions[@backingInt(contract.predicate)].type_id != Types.scalarId(.bool)) return false;

        var view = program;

        view.symbols = contract.symbols;
        view.expressions = contract.expressions;
        view.stores = &.{};
        view.functions = &.{};

        for (contract.expressions, 0..) |expression, index| {
            switch (expression.value) {
                .call, .store_get, .list_operation, .transform, .scope, .iteration, .list_update, .capture, .optional_value => return false,
                else => {},
            }

            if (!@import("expression_rules.zig").validate(view, expression, index)) return false;
        }
    }

    return true;
}
