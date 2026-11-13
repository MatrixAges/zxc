const ir = @import("zx").ir;
const borrow = @import("../../../ir/canonical/borrow.zig");

pub fn functions(comptime Functions: type, program: *const ir.Program) Functions {
    return .{
        .count = program.functions.count(),
        .files = program.functions.files,
        .input_types = program.functions.input_types,
        .output_types = program.functions.output_types,
        .native_modules = program.functions.native_modules,
        .symbols = borrow.slice(@FieldType(Functions, "symbols"), program.functions.symbols),
        .expressions = borrow.slice(@FieldType(Functions, "expressions"), program.functions.expressions),
        .contracts = borrow.slice(@FieldType(Functions, "contracts"), program.functions.contracts),
        .stores = borrow.slice(@FieldType(Functions, "stores"), program.functions.stores),
    };
}

pub fn body(comptime Body: type, program: *const ir.Program) Body {
    return .{
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .symbols = borrow.pointer(@FieldType(Body, "symbols"), &program.symbols),
        .expressions = borrow.pointer(@FieldType(Body, "expressions"), &program.expressions),
        .contracts = borrow.pointer(@FieldType(Body, "contracts"), &program.contracts),
        .stores = borrow.pointer(@FieldType(Body, "stores"), &program.stores),
    };
}
