const std = @import("std");
const ir = @import("zx").ir;
const Model = @import("../../artifact/model.zig");
const Nodes = @import("../../artifact/nodes.zig");
const generated = @import("parser_options").generated_parser;

pub const Tables = struct {
    types: ir.TypeTable,
    functions: ir.FunctionTable,
    native_modules: ir.NativeModuleTable,
};

pub fn materialize(allocator: std.mem.Allocator, temporary: std.mem.Allocator, module: *const Model.Module, body: ?*const ir.Function, recursive: ?ir.FunctionId, tables: Tables, mapping: []const ir.TypeId) Model.Error!ir.Program {
    var program = try assemble(allocator, temporary, module, body, tables, mapping);

    if (recursive) |id| try @import("../../function_body.zig").entry(allocator, &program, id);
    if (try @import("../../../ir/validate.zig").validate(temporary, program) != null) return error.InvalidIr;

    return program;
}

pub fn assemble(allocator: std.mem.Allocator, temporary: std.mem.Allocator, module: *const Model.Module, body: ?*const ir.Function, tables: Tables, mapping: []const ir.TypeId) Model.Error!ir.Program {
    var nodes: Nodes = .{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = &.{} }, .native_modules = .{ .indexed = &.{} } };
    const stores = try nodes.stores(module.stores);

    const exports, const constant_exports = if (comptime generated) source: {
        const surface = try @import("../../artifact/surface.zig").linked(temporary, &nodes, module.exports, module.constant_exports);

        break :source .{ surface.exports, surface.constant_exports };
    } else seed: {
        const aliases = try allocator.alloc(ir.Export, module.exports.len);

        for (aliases, module.exports) |*item, original| {
            item.* = .{ .name = try allocator.dupe(u8, original.name), .type_id = try nodes.types.include(original.type_id) };
        }

        break :seed .{ @as([]const ir.Export, aliases), try nodes.constants(module.constant_exports) };
    };

    const unit: ir.TypeId = @fromBackingInt(@as(u32, @backingInt(ir.Scalar.void)));

    return .{
        .file_name = try allocator.dupe(u8, module.path),
        .types = tables.types,
        .input_type = if (body) |value| value.input_type else unit,
        .output_type = if (body) |value| value.output_type else unit,
        .output_ownership = if (body) |value| value.output_ownership else .borrowed,
        .symbols = if (body) |value| value.symbols else .{},
        .expressions = if (body) |value| value.expressions else .{},
        .body = if (body) |value| value.body else .{},
        .contracts = if (body) |value| value.contracts else .{},
        .exports = exports,
        .constant_exports = constant_exports,
        .functions = tables.functions,
        .native_modules = tables.native_modules,
        .stores = stores,
        .store_mode = if (body) |value| value.store_mode else .transaction,
        .type_only = body == null,
    };
}
