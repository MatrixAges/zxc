const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Model = @import("../../artifact/model.zig");
const Nodes = @import("../../artifact/nodes.zig");

pub const Entry = struct {
    body: ?ir.Function = null,
    recursive: ?ir.FunctionId = null,
};

pub const Tables = struct {
    types: ir.TypeTable,
    functions: ir.FunctionTable,
    native_modules: ir.NativeModuleTable,
};

const State = struct {
    input_type: ir.TypeId = @fromBackingInt(@as(u32, @backingInt(ir.Scalar.void))),
    output_type: ir.TypeId = @fromBackingInt(@as(u32, @backingInt(ir.Scalar.void))),
    ownership: ir.Ownership = .borrowed,
    store_mode: ir.StoreMode = .transaction,
    type_only: bool = true,
    recursive: ?ir.FunctionId = null,
};

pub fn materialize(allocator: std.mem.Allocator, temporary: std.mem.Allocator, module: *const Model.Module, entry: *const Entry, tables: Tables, mapping: []const ir.TypeId) Model.Error!ir.Program {
    const body = if (entry.body) |*value| value else null;
    const program = try assemble(allocator, temporary, module, body, entry.recursive, tables, mapping);

    if (try @import("../../../ir/validate.zig").validate(temporary, program) != null) return error.InvalidIr;

    return program;
}

pub fn assemble(allocator: std.mem.Allocator, temporary: std.mem.Allocator, module: *const Model.Module, body: ?*const ir.Function, recursive: ?ir.FunctionId, tables: Tables, mapping: []const ir.TypeId) Model.Error!ir.Program {
    var nodes: Nodes = .{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = &.{} }, .native_modules = .{ .indexed = &.{} } };
    const exports = try allocator.alloc(ir.Export, module.exports.len);
    const stores = try nodes.stores(module.stores);

    const state = if (comptime @import("parser_options").generated_parser)
        try publish(allocator, temporary, exports, module.exports, body, recursive, mapping)
    else
        try publishSeed(allocator, exports, module.exports, body, recursive, nodes.types);

    var program: ir.Program = .{
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
        .constant_exports = try nodes.constants(module.constant_exports),
        .functions = tables.functions,
        .native_modules = tables.native_modules,
        .stores = stores,
        .store_mode = state.store_mode,
        .type_only = state.type_only,
    };

    if (state.recursive) |id| try @import("../../function_body.zig").entry(allocator, &program, id);

    return program;
}

fn publish(allocator: std.mem.Allocator, temporary: std.mem.Allocator, exports: []ir.Export, source: []const ir.Export, body: ?*const ir.Function, recursive: ?ir.FunctionId, mapping: []const ir.TypeId) Model.Error!State {
    const generated = @import("generated_artifact_result");
    const Input = std.meta.Child(generated.Input);
    const Root = std.meta.Child(@FieldType(Input, "root"));
    const Header = std.meta.Child(@typeInfo(@FieldType(Root, "body")).optional.child);
    const Ownership = @FieldType(Header, "ownership");
    var arena = std.heap.ArenaAllocator.init(temporary);
    var buffer: [1024]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const ids = try memory.alloc(u32, source.len);

    for (source, ids) |item, *id| id.* = @backingInt(item.type_id);

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

    const root: Root = .{
        .body = if (header) |*value| value else null,
        .recursive = if (recursive) |id| @backingInt(id) else null,
    };

    const input: Input = .{ .root = &root, .ids = ids, .mapping = @ptrCast(mapping) };

    const result = zx.columns.invoke(generated.executeValue, memory, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    for (exports, source, result.exports) |*item, original, type_id| {
        item.* = .{ .name = try allocator.dupe(u8, original.name), .type_id = @fromBackingInt(type_id) };
    }

    return .{
        .input_type = @fromBackingInt(result.state.header.input_type),
        .output_type = @fromBackingInt(result.state.header.output_type),
        .ownership = switch (result.state.header.ownership) {
            .Copy => .copy,
            .Borrowed => .borrowed,
            .Owned => .owned,
        },
        .store_mode = switch (result.state.header.store_mode) {
            .transaction => .transaction,
            .orchestration => .orchestration,
        },
        .type_only = result.state.type_only,
        .recursive = if (result.state.recursive) |id| @fromBackingInt(id) else null,
    };
}

fn publishSeed(allocator: std.mem.Allocator, exports: []ir.Export, source: []const ir.Export, body: ?*const ir.Function, recursive: ?ir.FunctionId, mapping: Nodes.TypeMap) Model.Error!State {
    for (exports, source) |*item, original| {
        item.* = .{ .name = try allocator.dupe(u8, original.name), .type_id = try mapping.include(original.type_id) };
    }

    const function = body orelse return .{};

    return .{
        .input_type = function.input_type,
        .output_type = function.output_type,
        .ownership = function.output_ownership,
        .store_mode = function.store_mode,
        .type_only = false,
        .recursive = recursive,
    };
}
