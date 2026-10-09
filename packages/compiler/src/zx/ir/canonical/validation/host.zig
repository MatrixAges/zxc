const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("generated_ir_validation");
const borrow = @import("../borrow.zig");
const Input = std.meta.Child(generated.Input);
const Context = std.meta.Child(@FieldType(Input, "context"));
const Unit = std.meta.Child(@FieldType(Input, "unit"));
const Body = std.meta.Child(@FieldType(Unit, "body"));

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Context, "table")), program.types);
    const functions = @import("../functions/input.zig").view(std.meta.Child(@FieldType(Context, "functions")), program.functions);

    const context = Context{
        .table = &table,
        .functions = &functions,
        .modules = borrow.pointer(@FieldType(Context, "modules"), &program.native_modules),
        .max_offset = std.math.maxInt(usize),
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    const body = Body{
        .stores = borrow.pointer(@FieldType(Body, "stores"), &program.stores),
        .symbols = borrow.pointer(@FieldType(Body, "symbols"), &program.symbols),
        .expressions = borrow.pointer(@FieldType(Body, "expressions"), &program.expressions),
        .control = borrow.pointer(@FieldType(Body, "control"), program.body.control),
        .root = if (program.body.root) |root| @backingInt(root) else null,
    };

    const unit = Unit{
        .body = &body,
        .contracts = borrow.pointer(@FieldType(Unit, "contracts"), &program.contracts),
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .output_ownership = switch (program.output_ownership) {
            .copy => .Copy,
            .borrowed => .Borrowed,
            .owned => .Owned,
        },
        .transaction = program.store_mode == .transaction,
        .type_only = program.type_only,
    };

    const names = try arena.allocator().alloc([]const u8, program.exports.len);
    const ids = try arena.allocator().alloc(u32, program.exports.len);

    for (program.exports, names, ids) |exported, *name, *id| {
        name.* = exported.name;
        id.* = @backingInt(exported.type_id);
    }

    const input = Input{
        .version = program.version,
        .expected_version = zx.ir_version,
        .context = &context,
        .unit = &unit,
        .export_names = names,
        .export_types = ids,
    };

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return false,
    };
}
