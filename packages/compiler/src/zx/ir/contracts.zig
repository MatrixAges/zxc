const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");

pub fn validate(program: ir.Program) bool {
    if (comptime !options.generated_parser) return @import("seed_contracts.zig").validate(program);

    const generated = @import("generated_ir_contracts");
    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "table"));
    const table = ir.TypeTable.borrow(Table, program.types);

    const input: Input = .{
        .table = &table,
        .contracts = borrow.pointer(@FieldType(Input, "contracts"), &program.contracts),
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .max_offset = std.math.maxInt(usize),
    };

    return execute(generated, &input);
}

pub fn tables(contracts: ir.ContractTable) bool {
    if (comptime !options.generated_parser) return @import("seed_contracts.zig").tables(contracts);

    const generated = @import("generated_ir_contract_tables");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .contracts = borrow.pointer(@FieldType(Input, "contracts"), &contracts),
        .max_offset = std.math.maxInt(usize),
    };

    return execute(generated, &input);
}

fn execute(comptime generated: type, input: generated.Input) bool {
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, input) catch unreachable;
}
