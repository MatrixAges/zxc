const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Binding = @import("../function_import.zig");
const Nodes = @import("nodes.zig");
const remap = @import("nodes/remap.zig");
const Error = @import("model.zig").Error;
const declarations = @import("generated_artifact_surface_declaration");
const bindings = @import("generated_artifact_surface_binding");
const Declaration = std.meta.Child(declarations.Input);
const OwnedDeclaration = @typeInfo(@TypeOf(declarations.executeValue(undefined, undefined))).error_union.payload;
pub const Mapping = std.meta.Child(@FieldType(Declaration, "types"));
const BindingInput = std.meta.Child(bindings.Input);
const BindingMapping = std.meta.Child(@FieldType(BindingInput, "types"));

const Surface = struct {
    exports: []const ir.Export = &.{},
    constant_exports: []const ir.Constant = &.{},
    constant_imports: []const ir.Constant = &.{},
    type_imports: []const ir.Export = &.{},
    function_imports: []const Binding = &.{},
    members: []const Binding = &.{},
};

pub fn copy(nodes: *const Nodes, source: Surface) Error!Surface {
    const allocator = nodes.allocator;
    const types = remap.typeMapping(Mapping, nodes.types);
    const binding_types = remap.typeMapping(BindingMapping, nodes.types);
    const functions = remap.idMapping(BindingMapping, nodes.functions);
    var result: Surface = .{};

    result.exports = try copyExports(allocator, source.exports, &types);
    result.constant_exports = try copyConstants(allocator, source.constant_exports, &types);
    result.constant_imports = try copyConstants(allocator, source.constant_imports, &types);
    result.type_imports = try copyExports(allocator, source.type_imports, &types);
    result.function_imports = try copyBindings(allocator, source.function_imports, &binding_types, &functions);
    result.members = try copyBindings(allocator, source.members, &binding_types, &functions);

    return result;
}

pub fn copyExports(allocator: std.mem.Allocator, source: []const ir.Export, types: *const Mapping) Error![]const ir.Export {
    const result = try allocator.alloc(ir.Export, source.len);

    for (source, result) |*item, *target| {
        const mapped = try ownDeclaration(allocator, .{ .name = item.name, .type_id = @backingInt(item.type_id), .text = null, .types = types });

        target.* = .{ .name = mapped.name, .type_id = @fromBackingInt(mapped.type_id) };
    }

    return result;
}

pub fn copyConstants(allocator: std.mem.Allocator, source: []const ir.Constant, types: *const Mapping) Error![]const ir.Constant {
    const result = try allocator.alloc(ir.Constant, source.len);

    for (source, result) |*item, *target| {
        const text = if (item.value == .string) item.value.string else null;
        const mapped = try ownDeclaration(allocator, .{ .name = item.name, .type_id = @backingInt(item.type_id), .text = text, .types = types });

        target.* = .{ .name = mapped.name, .type_id = @fromBackingInt(mapped.type_id), .value = item.value };

        if (mapped.text) |value| target.value = .{ .string = value };
    }

    return result;
}

fn ownDeclaration(allocator: std.mem.Allocator, input: Declaration) Error!OwnedDeclaration {
    return zx.columns.invoke(declarations.executeValue, allocator, &input) catch |err| return failure(err);
}

fn copyBindings(allocator: std.mem.Allocator, source: []const Binding, types: *const BindingMapping, functions: *const BindingMapping) Error![]const Binding {
    const result = try allocator.alloc(Binding, source.len);

    for (source, result) |*item, *target| {
        const input: BindingInput = .{
            .name = item.name,
            .namespace = item.namespace,
            .id = if (item.id) |id| @backingInt(id) else null,
            .input_type = if (item.input_type) |id| @backingInt(id) else null,
            .output_type = if (item.output_type) |id| @backingInt(id) else null,
            .types = types,
            .functions = functions,
        };

        const row = zx.columns.invoke(bindings.executeValue, allocator, &input) catch |err| return failure(err);

        target.* = .{
            .name = row.name,
            .namespace = row.namespace,
            .id = if (row.id) |id| @fromBackingInt(id) else null,
            .input_type = if (row.input_type) |id| @fromBackingInt(id) else null,
            .output_type = if (row.output_type) |id| @fromBackingInt(id) else null,
            .intrinsic = item.intrinsic,
        };
    }

    return result;
}

fn failure(err: anyerror) Error {
    return if (err == error.OutOfMemory) error.OutOfMemory else error.InvalidModule;
}
