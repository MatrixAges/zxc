const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Context = @import("context.zig");
const borrow = @import("../../../ir/canonical/borrow.zig");
const own = @import("../../../modules/artifact/nodes/columns.zig").own;
const model = @import("model.zig");

pub fn apply(analyzer: *Context, output: *const model.Output, file_name: []const u8) zx.Error!ir.Program {
    const allocator = analyzer.allocator;

    if (analyzer.mode != .project) {
        analyzer.types.* = try @import("../../type_table.zig").storage(allocator, analyzer.base_types);

        try analyzer.origins.copyValidated(analyzer.types.view(), analyzer.base_origins);
    }

    try @import("../../semantic/merging/commit.zig").append(allocator, analyzer.types, &analyzer.origins.items, output.type_delta.*, output.nominal_delta.*);

    const control = try allocator.create(ir.ControlTable);
    control.* = try own(allocator, borrow.columns(ir.ControlTable, output.body.control.*), .{});
    const exports = try allocator.alloc(ir.Export, output.export_names.len);

    for (output.export_names, output.export_types, exports) |name, type_id, *exported| {
        exported.* = .{ .name = try allocator.dupe(u8, name), .type_id = @fromBackingInt(type_id) };
    }

    return .{
        .file_name = try allocator.dupe(u8, file_name),
        .types = analyzer.types.view(),
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
        .contracts = try @import("contracts.zig").copy(allocator, borrow.columns(ir.ContractTable, output.contracts.*)),
        .exports = exports,
        .type_only = output.type_only,
    };
}
