const std = @import("std");
const ir = @import("zx").ir;
const forward = @import("forward_entry/host.zig").write;

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
    try forward(allocator, program, .{ .id = id, .parameter = program.symbols.at(0), .unit = false });

    program.contracts = .{};
}

pub fn externalEntry(allocator: std.mem.Allocator, program: *ir.Program, id: ir.FunctionId) std.mem.Allocator.Error!void {
    const parameter: ir.Symbol = .{ .name = "$in", .type_id = program.input_type, .span = .{ .start = 0, .end = 0 } };

    try forward(allocator, program, .{
        .id = id,
        .parameter = parameter,
        .unit = @backingInt(program.input_type) == @backingInt(ir.Scalar.void),
    });
}

pub fn complete(allocator: std.mem.Allocator, program: *ir.Program, functions: ir.FunctionTable) std.mem.Allocator.Error!void {
    const id: ir.FunctionId = @fromBackingInt(@intCast(functions.count()));
    program.functions = functions;

    if (!program.type_only and calls(program.expressions, id)) try appendEntry(allocator, program);
}

pub fn appendEntry(allocator: std.mem.Allocator, program: *ir.Program) std.mem.Allocator.Error!void {
    var storage: ir.FunctionStorage = .{};

    try storage.append(allocator, value(program.*));

    program.functions = try @import("link/function_table.zig").join(allocator, program.functions, try storage.finish(allocator));
}
