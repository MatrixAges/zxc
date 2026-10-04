const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Module = @import("module.zig");
const Builder = @import("program/builder.zig");
const inlineValue = @import("program/expression.zig").inlineValue;

pub const Options = struct {
    owner: []const u8,
    types: []const ir.Type,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    calls: []const Module.Call,
    result: ?ir.Program,
    native_modules: []const ir.NativeModule,
};

pub fn lower(allocator: std.mem.Allocator, contract: Options) Builder.Error!ir.Program {
    var builder = Builder{ .allocator = allocator, .types = contract.types, .native_modules = contract.native_modules };
    const start = zx.Span{ .start = 0, .end = 0 };
    const input = try builder.symbol("$in", contract.input_type, start);

    if (@intFromEnum(contract.input_type) != @intFromEnum(ir.Scalar.void)) try builder.bindings.append(allocator, input);

    for (contract.calls, 0..) |call, index| {
        const argument = try inlineValue(&builder, call.argument);
        const span = builder.expressions.items[@intFromEnum(argument)].span;
        const function = try builder.importFunction(call.callee);
        const value = try builder.expression(.{ .type_id = call.callee.output_type, .span = span, .value = .{ .call = .{ .function = function, .argument = argument } } });
        const name = call.out orelse try std.fmt.allocPrint(allocator, "discard_{d}", .{index});
        const symbol = try builder.symbol(name, call.callee.output_type, span);

        try builder.body.append(allocator, .{ .constant = .{ .symbol = symbol, .value = value } });
        if (call.out != null) try builder.bindings.append(allocator, symbol);
    }

    const returned = if (contract.result) |program| try inlineValue(&builder, program) else null;

    try builder.body.append(allocator, .{ .result = returned });

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
