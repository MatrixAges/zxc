const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("../analysis/types.zig");

pub fn validate(program: ir.Program) bool {
    if (!program.contracts.validStructure()) return false;

    var has_ensures = false;

    for (0..program.contracts.count()) |contract_index| {
        const contract = program.contracts.at(contract_index);

        if (!contract.symbols.validStructure() or !contract.expressions.validStructure()) return false;
        if (contract.kind == .requires and has_ensures) return false;

        has_ensures = has_ensures or contract.kind == .ensures;

        const parameter_count: usize = if (contract.kind == .requires) 1 else 2;

        if (contract.symbols.count() != parameter_count or @backingInt(contract.predicate) >= contract.expressions.count()) return false;
        if (!std.mem.eql(u8, contract.symbols.at(0).name, "in") or contract.symbols.at(0).type_id != program.input_type) return false;
        if (parameter_count == 2 and (!std.mem.eql(u8, contract.symbols.at(1).name, "out") or contract.symbols.at(1).type_id != program.output_type)) return false;
        if (contract.expressions.at(@backingInt(contract.predicate)).type_id != Types.scalarId(.bool)) return false;

        var view = program;

        view.symbols = contract.symbols;
        view.expressions = contract.expressions;
        view.stores = .{};
        view.functions = .{};

        for (0..contract.expressions.count()) |index| {
            const expression = contract.expressions.at(index);

            switch (expression.value) {
                .call, .store_get, .list_operation, .transform, .scope, .iteration, .list_update, .capture, .optional_value, .task, .await_task, .cancel_task, .parallel => return false,
                else => {},
            }

            if (!@import("expression_rules.zig").validate(view, index)) return false;
        }
    }

    return true;
}

pub fn tables(contracts: ir.ContractTable) bool {
    if (!contracts.validStructure()) return false;

    for (0..contracts.count()) |index| {
        const contract = contracts.at(index);

        if (!contract.expressions.validStructure() or !contract.symbols.validStructure()) return false;
    }

    return true;
}
