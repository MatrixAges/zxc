const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../nominal_origins.zig");
const Error = @import("../model.zig").Error;
const borrow = @import("../../../ir/canonical/borrow.zig");
const generated = @import("generated_artifact_tables");
const Input = std.meta.Child(generated.Input);
const Output = generated.Output;

pub fn materialize(allocator: std.mem.Allocator, program: *const ir.Program, nominal_types: Origins.Table, plan: @FieldType(Input, "plan")) Error!Output {
    const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "table")), program.types);
    const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "origins")), nominal_types);
    const declarations = borrow.columns(std.meta.Child(@FieldType(Input, "declarations")), ir.SignatureTable.fromFunctions(program.functions));

    const input: Input = .{
        .table = &table,
        .origins = &origins,
        .declarations = &declarations,
        .modules = borrow.pointer(@FieldType(Input, "modules"), &program.native_modules),
        .plan = plan,
    };

    return generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };
}
