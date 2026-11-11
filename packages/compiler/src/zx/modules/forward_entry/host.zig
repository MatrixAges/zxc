const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn replace(allocator: std.mem.Allocator, program: *ir.Program, id: ir.FunctionId) std.mem.Allocator.Error!void {
    const generated = @import("generated_recursive_forward_entry");
    const Input = std.meta.Child(generated.Input);
    const Parameter = std.meta.Child(@FieldType(Input, "parameter"));
    const Ownership = @FieldType(Parameter, "ownership");
    const source = program.symbols.at(0);

    const parameter: Parameter = .{
        .name = source.name,
        .type_id = @backingInt(source.type_id),
        .ownership = switch (source.ownership) {
            .copy => Ownership.Copy,
            .borrowed => Ownership.Borrowed,
            .owned => Ownership.Owned,
        },
        .span_start = source.span.start,
        .span_end = source.span.end,
    };

    const input: Input = .{
        .parameter = &parameter,
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .function_id = @backingInt(id),
        .unit = false,
    };

    const wrapper = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    try install(allocator, program, &wrapper);
}

pub fn install(allocator: std.mem.Allocator, program: *ir.Program, wrapper: anytype) std.mem.Allocator.Error!void {
    const control = try allocator.create(ir.ControlTable);

    control.* = zx.columns.borrow(ir.ControlTable, &wrapper.control);
    program.symbols = zx.columns.borrow(ir.SymbolTable, &wrapper.symbols);
    program.expressions = zx.columns.borrow(ir.ExpressionTable, &wrapper.expressions);
    program.body = .{ .control = control, .root = @fromBackingInt(wrapper.root) };
    program.contracts = zx.columns.borrow(ir.ContractTable, &wrapper.contracts);
}
