const std = @import("std");
const ir = @import("zx").ir;

pub fn value(program: ir.Program) ir.Function {
    return .{
        .stores = program.stores,
        .store_mode = program.store_mode,
        .output_ownership = program.output_ownership,
        .file_name = program.file_name,
        .input_type = program.input_type,
        .output_type = program.output_type,
        .symbols = program.symbols,
        .expressions = program.expressions,
        .body = program.body,
        .contracts = program.contracts,
    };
}

pub fn calls(expressions: ir.ExpressionTable, id: ir.FunctionId) bool {
    for (0..expressions.count()) |index| {
        if (expressions.callee(index)) |callee| if (callee == id) return true;
    }

    return false;
}

pub fn own(program: ir.Program) ?ir.FunctionId {
    if (program.type_only or program.functions.count() == 0) return null;

    const index = program.functions.count() - 1;
    const id: ir.FunctionId = @fromBackingInt(@intCast(index));

    return if (calls(program.expressions, id) and std.meta.eql(value(program), program.functions.at(index))) id else null;
}

pub fn entry(allocator: std.mem.Allocator, program: *ir.Program, id: ir.FunctionId) std.mem.Allocator.Error!void {
    const span = program.symbols.at(0).span;
    program.symbols = try ir.SymbolTable.fromValues(allocator, &.{program.symbols.at(0)});

    program.expressions = try ir.ExpressionTable.fromValues(allocator, &.{
        .{ .type_id = program.input_type, .span = span, .value = .{ .reference = @fromBackingInt(@as(u32, 0)) } },
        .{ .type_id = program.output_type, .span = span, .value = .{ .call = .{ .function = id, .argument = @fromBackingInt(@as(u32, 0)) } } },
    });

    program.body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(@as(u32, 1)) }});
    program.contracts = .{};
}

pub fn complete(allocator: std.mem.Allocator, program: *ir.Program, functions: ir.FunctionTable) std.mem.Allocator.Error!void {
    const id: ir.FunctionId = @fromBackingInt(@intCast(functions.count()));

    if (program.type_only or !calls(program.expressions, id)) {
        program.functions = functions;

        return;
    }

    var storage: ir.FunctionStorage = .{};

    try storage.append(allocator, value(program.*));

    program.functions = try @import("link/function_table.zig").join(allocator, functions, try storage.finish(allocator));
}
