const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Module = @import("module.zig");
const Builder = @import("program/builder.zig");

pub const Options = struct {
    owner: []const u8,
    types: []const ir.Type,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    calls: []const Module.Call,
    native_modules: []const ir.NativeModule,
    steps: []const @import("program/flow.zig").Step,
};

pub fn lower(allocator: std.mem.Allocator, contract: Options) Builder.Error!ir.Program {
    var builder = Builder{ .allocator = allocator, .types = contract.types, .native_modules = contract.native_modules };
    const start = zx.Span{ .start = 0, .end = 0 };
    const input = try builder.symbol("$in", contract.input_type, start);

    if (@intFromEnum(contract.input_type) != @intFromEnum(ir.Scalar.void)) try builder.bindings.append(allocator, input);
    try @import("program/statements.zig").lower(&builder, contract.steps, contract.calls);

    if (!ir.terminates(builder.body.items)) {
        if (@intFromEnum(contract.output_type) != @intFromEnum(ir.Scalar.void)) return error.IncompleteFlow;
        try builder.body.append(allocator, .{ .result = null });
    }

    return .{
        .file_name = try allocator.dupe(u8, contract.owner),
        .types = contract.types,
        .symbols = builder.symbols.items,
        .expressions = builder.expressions.items,
        .input_type = contract.input_type,
        .output_type = contract.output_type,
        .body = builder.body.items,
        .functions = builder.functions.items,
        .native_modules = contract.native_modules,
    };
}
