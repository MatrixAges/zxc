const std = @import("std");
const ir = @import("zx").ir;
const Options = @import("../../expression.zig").Options;
const Output = std.meta.Child(@import("generated_expression_analysis").Output);
const borrow = @import("../../../ir/canonical/borrow.zig");
const own = @import("../../../modules/artifact/nodes/columns.zig").own;
const type_table = @import("../../type_table.zig");

pub fn apply(allocator: std.mem.Allocator, output: *const Output, options: Options, file_name: []const u8) std.mem.Allocator.Error!ir.Program {
    const control = try allocator.create(ir.ControlTable);
    control.* = try own(allocator, borrow.columns(ir.ControlTable, output.body.control.*), .{});

    return .{
        .file_name = try allocator.dupe(u8, file_name),
        .types = try extended(allocator, output, options),
        .native_modules = try @import("../../../modules/native_context.zig").copy(allocator, options.native_modules),
        .input_type = @fromBackingInt(output.input_type),
        .output_type = @fromBackingInt(output.output_type),
        .output_ownership = switch (output.output_ownership) {
            .Copy => .copy,
            .Borrowed => .borrowed,
            .Owned => .owned,
        },
        .symbols = try own(allocator, borrow.columns(ir.SymbolTable, output.body.symbols.*), .{}),
        .expressions = try own(allocator, borrow.columns(ir.ExpressionTable, output.body.expressions.*), .{}),
        .body = .{ .control = control, .root = if (output.body.root) |root| @fromBackingInt(root) else null },
        .stores = try own(allocator, borrow.columns(ir.StoreTable, output.body.stores.*), .{}),
    };
}

pub fn expression(allocator: std.mem.Allocator, output: *const Output, options: Options) std.mem.Allocator.Error!@import("../../expression.zig").Expression {
    return .{
        .types = try extended(allocator, output, options),
        .symbols = try own(allocator, borrow.columns(ir.SymbolTable, output.body.symbols.*), .{}),
        .expressions = try own(allocator, borrow.columns(ir.ExpressionTable, output.body.expressions.*), .{}),
        .value = @fromBackingInt(output.value),
    };
}

/// The table of `options` with the types the expression added: in the storage the caller lends, or in a copy.
fn extended(allocator: std.mem.Allocator, output: *const Output, options: Options) std.mem.Allocator.Error!ir.TypeTable {
    var types = if (options.type_storage) |storage| storage.* else if (options.borrow_types) try type_table.columns(allocator, options.types) else try type_table.storage(allocator, options.types);

    try types.appendDelta(allocator, try type_table.copy(allocator, borrow.columns(ir.TypeTable, output.type_delta.*)));
    if (options.type_storage) |storage| storage.* = types;

    return types.view();
}
