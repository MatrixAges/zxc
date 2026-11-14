const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const strings = @import("native.zig").strings;
const Error = std.mem.Allocator.Error || error{InvalidModule};
const generated = @import("generated_compiled_owned_function");
const Input = std.meta.Child(generated.Input);
const External = std.meta.Child(@typeInfo(@FieldType(Input, "external")).optional.child);

pub fn append(allocator: std.mem.Allocator, functions: *ir.FunctionStorage, source: ir.Function) Error!void {
    try functions.reserve(allocator, 1);

    const external: ?External = if (source.external) |value| .{
        .members = value.member,
        .errors = value.errors,
        .export_name = value.export_name,
        .parameters = if (value.input) |native| native.names else null,
    } else null;

    const input: Input = .{
        .file = source.file_name,
        .symbols = zx.columns.pointer(@FieldType(Input, "symbols"), &source.symbols),
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &source.expressions),
        .control = zx.columns.pointer(@FieldType(Input, "control"), source.body.control),
        .stores = zx.columns.pointer(@FieldType(Input, "stores"), &source.stores),
        .contracts = zx.columns.pointer(@FieldType(Input, "contracts"), &source.contracts),
        .external = if (external) |*value| value else null,
    };

    const owned = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    var result = source;
    result.file_name = owned.file;
    result.body.control = zx.columns.pointer(*const ir.ControlTable, owned.control);

    if (owned.external) |details| {
        const target = &result.external.?;

        target.member = details.members;
        target.errors = details.errors;
        target.export_name = details.export_name;
        target.input = if (details.parameters) |names| .{ .names = names } else null;
    }

    functions.appendOwnedAssumeCapacity(result, .{
        .symbols = zx.columns.pointer(*const ir.SymbolTable, owned.symbols),
        .expressions = zx.columns.pointer(*const ir.ExpressionTable, owned.expressions),
        .stores = zx.columns.pointer(*const ir.StoreTable, owned.stores),
        .contracts = zx.columns.pointer(*const ir.ContractTable, owned.contracts),
    });
}

pub fn copyExternalDetails(allocator: std.mem.Allocator, source: ir.External) std.mem.Allocator.Error!ir.External {
    var result = source;
    result.errors = if (source.errors) |errors| try strings(allocator, errors) else null;

    if (source.input) |input| {
        const names = try allocator.alloc(?[]const u8, input.names.len);

        for (input.names, names) |name, *owned| owned.* = if (name) |text| try allocator.dupe(u8, text) else null;

        result.input = .{ .names = names };
    }

    return result;
}
