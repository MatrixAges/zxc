const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Model = @import("../../artifact/model.zig");
const Nodes = @import("../../artifact/nodes.zig");
const generated = @import("parser_options").generated_parser;

pub const Tables = struct {
    types: ir.TypeTable,
    functions: ir.FunctionTable,
    native_modules: ir.NativeModuleTable,
};

pub const State = struct {
    input_type: ir.TypeId = @fromBackingInt(@as(u32, @backingInt(ir.Scalar.void))),
    output_type: ir.TypeId = @fromBackingInt(@as(u32, @backingInt(ir.Scalar.void))),
    ownership: ir.Ownership = .borrowed,
    store_mode: ir.StoreMode = .transaction,
    type_only: bool = true,
    recursive: ?ir.FunctionId = null,
};

pub fn materialize(allocator: std.mem.Allocator, temporary: std.mem.Allocator, module: *const Model.Module, body: ?*const ir.Function, state: State, tables: Tables, mapping: []const ir.TypeId) Model.Error!ir.Program {
    var program = try assemble(allocator, temporary, module, body, state, tables, mapping);

    if (state.recursive) |id| try @import("../../function_body.zig").entry(allocator, &program, id);
    if (try @import("../../../ir/validate.zig").validate(temporary, program) != null) return error.InvalidIr;

    return program;
}

pub fn assemble(allocator: std.mem.Allocator, temporary: std.mem.Allocator, module: *const Model.Module, body: ?*const ir.Function, state: State, tables: Tables, mapping: []const ir.TypeId) Model.Error!ir.Program {
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

    return .{
        .file_name = try allocator.dupe(u8, module.path),
        .types = tables.types,
        .input_type = state.input_type,
        .output_type = state.output_type,
        .output_ownership = state.ownership,
        .symbols = if (body) |value| value.symbols else .{},
        .expressions = if (body) |value| value.expressions else .{},
        .body = if (body) |value| value.body else .{},
        .contracts = if (body) |value| value.contracts else .{},
        .exports = exports,
        .constant_exports = constant_exports,
        .functions = tables.functions,
        .native_modules = tables.native_modules,
        .stores = stores,
        .store_mode = state.store_mode,
        .type_only = state.type_only,
    };
}

pub fn publish(temporary: std.mem.Allocator, body: ?*const ir.Function, candidate: ?ir.FunctionId) Model.Error!State {
    if (comptime !generated) return publishSeed(body, candidate);

    const result_header = @import("generated_artifact_result");
    const Root = std.meta.Child(result_header.Input);
    const Header = std.meta.Child(@typeInfo(@FieldType(Root, "body")).optional.child);
    const Calls = std.meta.Child(@typeInfo(@FieldType(Root, "calls")).optional.child);
    const Ownership = @FieldType(Header, "ownership");

    const header: ?Header = if (body) |function| .{
        .input_type = @backingInt(function.input_type),
        .output_type = @backingInt(function.output_type),
        .ownership = switch (function.output_ownership) {
            .copy => Ownership.Copy,
            .borrowed => Ownership.Borrowed,
            .owned => Ownership.Owned,
        },
        .store_mode = switch (function.store_mode) {
            .transaction => .transaction,
            .orchestration => .orchestration,
        },
    } else null;

    const calls: ?Calls = if (body) |function| if (candidate) |id| .{
        .kinds = zx.columns.slice(@FieldType(Calls, "kinds"), function.expressions.kinds),
        .payloads = function.expressions.payloads,
        .calls = function.expressions.call_functions,
        .id = @backingInt(id),
    } else null else null;

    const root: Root = .{
        .body = if (header) |*value| value else null,
        .calls = if (calls) |*value| value else null,
    };

    const result = zx.columns.invoke(result_header.executeValue, temporary, &root) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return .{
        .input_type = @fromBackingInt(result.header.input_type),
        .output_type = @fromBackingInt(result.header.output_type),
        .ownership = switch (result.header.ownership) {
            .Copy => .copy,
            .Borrowed => .borrowed,
            .Owned => .owned,
        },
        .store_mode = switch (result.header.store_mode) {
            .transaction => .transaction,
            .orchestration => .orchestration,
        },
        .type_only = result.type_only,
        .recursive = if (result.recursive) |id| @fromBackingInt(id) else null,
    };
}

fn publishSeed(body: ?*const ir.Function, candidate: ?ir.FunctionId) State {
    const function = body orelse return .{};
    const recursive = if (candidate) |id| if (@import("../../function_body.zig").calls(function.expressions, id)) id else null else null;

    return .{
        .input_type = function.input_type,
        .output_type = function.output_type,
        .ownership = function.output_ownership,
        .store_mode = function.store_mode,
        .type_only = false,
        .recursive = recursive,
    };
}
