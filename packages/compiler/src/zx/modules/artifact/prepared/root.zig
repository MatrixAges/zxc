const std = @import("std");
const zx = @import("zx");
const Analysis = @import("../../../analysis/analyze.zig");
const Record = @import("../../module_record.zig");
const Nodes = @import("../nodes.zig");
const model = @import("../model.zig");
const Origins = @import("../../nominal_origins.zig");
const contents = @import("contents.zig");

pub fn extract(allocator: std.mem.Allocator, scratch: std.mem.Allocator, analysis: *const Analysis.Result, record: Record) model.Error!model.Module {
    const program = &analysis.value.ir;
    const prepared = try @import("run.zig").execute(scratch, analysis, record);
    const body = prepared.body;

    const source = if (body.function_id) |row|
        program.functions.at(row)

    else if (body.use_entry)
        @import("../../function_body.zig").value(program.*)
    else
        null;

    var nodes = Nodes{
        .allocator = allocator,
        .types = .{ .planned = prepared.plan.state.mapping },
        .functions = .{ .planned = prepared.plan.functions.mapping },
        .native_modules = .{ .planned = prepared.plan.natives.mapping },
    };

    const materialized = try @import("materialize.zig").materialize(&nodes, program, analysis.nominal_types, prepared, if (source) |*value| value else null);
    const types = zx.columns.view(zx.ir.TypeTable, materialized.table);
    const origins = zx.columns.view(Origins.Table, materialized.origins);
    const native_modules = zx.columns.view(zx.ir.NativeModuleTable, materialized.natives orelse return error.InvalidModule);
    const functions = zx.columns.view(zx.ir.SignatureTable, materialized.signatures orelse return error.InvalidModule);
    const function = if (materialized.function) |mapped| try nodes.ownFunction(&source.?, mapped, .validated) else null;

    const stores: @import("zx").ir.StoreTable = if (materialized.entry_store_types) |mapped|
        try @import("zx").columns.own(allocator, program.stores, .{ .types = mapped })

    else if (function) |value|
        value.stores
    else
        .{};

    const surface = try @import("../surface.zig").copy(&nodes, .{
        .exports = record.exports,
        .constant_exports = record.constant_exports,
        .constant_imports = record.constant_imports,
        .type_imports = record.type_imports,
        .function_imports = record.function_imports,
        .members = record.reexports.functions,
    });

    return .{
        .path = try allocator.dupe(u8, record.path),
        .source_digest = record.source_digest,
        .dependencies = try contents.dependencies(allocator, record.imports),
        .types = types,
        .nominal_types = origins,
        .exports = surface.exports,
        .constant_exports = surface.constant_exports,
        .constant_imports = surface.constant_imports,
        .type_imports = surface.type_imports,
        .function_imports = surface.function_imports,
        .members = surface.members,
        .functions = functions,
        .native_modules = native_modules,
        .function = function,
        .stores = stores,
    };
}
