const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Module = @import("module.zig");
const Builder = @import("program/builder.zig");

pub const Options = struct {
    owner: []const u8,
    types: ir.TypeTable,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    captures: ?[]const @import("frontend").expressions.Binding = null,
    calls: []const Module.Call,
    native_modules: ir.NativeModuleTable,
    steps: []const @import("program/flow.zig").Step,
};

pub const Result = struct { program: ir.Program, store_initializers: []const @import("frontend").project.compiled.StoreInitializer };

pub fn lower(allocator: std.mem.Allocator, contract: Options) Builder.Error!Result {
    var builder = Builder{ .allocator = allocator, .types = contract.types, .native_modules = contract.native_modules };

    defer builder.body.deinit(allocator);

    const start = zx.Span{ .start = 0, .end = 0 };

    if (contract.captures) |captures| {
        try @import("program/capture.zig").bind(&builder, contract.input_type, captures, start);
    } else {
        const input = try builder.symbol("$in", contract.input_type, start);

        if (@backingInt(contract.input_type) != @backingInt(ir.Scalar.void)) try builder.bindings.append(allocator, input);
    }

    try @import("program/statements.zig").lower(&builder, contract.steps, contract.calls);

    if (!builder.control.terminates(builder.body.items)) {
        if (@backingInt(contract.output_type) != @backingInt(ir.Scalar.void)) return error.IncompleteFlow;
        try builder.body.append(allocator, .{ .result = null });
    }

    const root = try builder.control.appendBlock(allocator, builder.body.items);

    return .{ .store_initializers = builder.store_initializers.items, .program = .{
        .file_name = try allocator.dupe(u8, contract.owner),
        .types = contract.types,
        .symbols = builder.symbols.view(),
        .expressions = builder.expressions.view(),
        .input_type = contract.input_type,
        .output_type = contract.output_type,
        .body = try builder.control.finish(allocator, root),
        .functions = builder.functions.view(),
        .stores = builder.stores.view(),
        .store_mode = .orchestration,
        .native_modules = contract.native_modules,
    } };
}
