const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../artifact/model.zig");
const Nodes = @import("../artifact/nodes.zig");
const native = @import("native.zig");
const Self = @This();
pub const Error = model.Error || error{ConflictingInterface};

allocator: std.mem.Allocator,
temporary: std.mem.Allocator,
modules: []const model.Module,
type_mappings: []const []const ir.TypeId,
functions: std.ArrayList(ir.Function) = .empty,
native_modules: std.ArrayList(ir.NativeModule) = .empty,
module_functions: []?ir.FunctionId,
pub fn module(self: *Self, index: usize) Error!?ir.Function {
    const value = self.modules[index];
    const function_mapping = try self.temporary.alloc(?ir.FunctionId, value.functions.len);
    const native_mapping = try self.temporary.alloc(?ir.NativeModuleId, value.native_modules.len);

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = self.allocator, .types = .{ .mapped = self.type_mappings[index] }, .functions = function_mapping, .native_modules = native_mapping };

    try checkExports(value.exports, nodes.types);
    try checkExports(value.type_imports, nodes.types);
    for (value.native_modules, native_mapping) |item, *id| id.* = try native.append(self.allocator, &self.native_modules, item, &nodes);

    for (value.functions, function_mapping) |signature, *id| {
        const input = try nodes.types.include(signature.input_type);
        const output = try nodes.types.include(signature.output_type);

        if (signature.external) |external| {
            if (external.member.len == 0) return error.InvalidModule;

            const mapped = try nodes.external(external);

            id.* = try self.importExternal(signature, input, output, mapped);
        } else {
            const target = self.find(signature.file_name) orelse return error.InvalidModule;

            if (!sourceDependency(value, signature.file_name)) return error.InvalidModule;

            const target_id = self.module_functions[target] orelse return error.InvalidModule;
            const callee = self.functions.items[@intFromEnum(target_id)];

            if (callee.input_type != input or callee.output_type != output or callee.output_ownership != signature.output_ownership) return error.ConflictingInterface;

            id.* = target_id;
        }
    }

    try self.imports(index, &nodes);

    if (value.function) |function| {
        if (function.external != null or !std.mem.eql(u8, function.file_name, value.path)) return error.InvalidModule;

        return try nodes.function(function);
    }

    return null;
}

fn imports(self: *Self, index: usize, nodes: *Nodes) Error!void {
    const value = self.modules[index];

    for (value.function_imports) |binding| {
        const id = try nodes.functionId(binding.id);
        const function = self.functions.items[@intFromEnum(id)];

        if (try nodes.types.include(binding.input_type) != function.input_type or try nodes.types.include(binding.output_type) != function.output_type) return error.ConflictingInterface;
    }

    for (value.dependencies) |dependency| {
        if (dependency.target != .source) {
            var found = false;

            for (value.native_modules) |item| {
                if (std.mem.eql(u8, item.specifier, dependency.specifier)) found = true;
            }

            if (!found) return error.InvalidModule;

            continue;
        }

        const target_index = self.find(dependency.target.source) orelse return error.InvalidModule;
        const target = self.modules[target_index];

        if (dependency.kind == .function) {
            if (target.function == null or dependency.names.len != 1) return error.InvalidModule;

            continue;
        }

        if (target.function != null) return error.InvalidModule;

        for (dependency.names) |name| {
            var exported: ?ir.TypeId = null;
            var imported: ?ir.TypeId = null;

            for (target.exports) |item| {
                if (!std.mem.eql(u8, item.name, name)) continue;
                if (@intFromEnum(item.type_id) >= self.type_mappings[target_index].len) return error.InvalidModule;
                if (dependency.kind == .enumeration and target.types[@intFromEnum(item.type_id)] != .enumeration) return error.ConflictingInterface;

                exported = self.type_mappings[target_index][@intFromEnum(item.type_id)];
            }

            for (value.type_imports) |item| {
                if (std.mem.eql(u8, item.name, name)) imported = try nodes.types.include(item.type_id);
            }

            if (exported == null or imported == null or exported.? != imported.?) return error.ConflictingInterface;
        }
    }
}

fn checkExports(values: []const ir.Export, mapping: Nodes.TypeMap) Error!void {
    for (values, 0..) |item, index| {
        if (item.name.len == 0) return error.InvalidModule;

        _ = try mapping.include(item.type_id);

        for (values[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, item.name)) return error.InvalidModule;
        }
    }
}

fn importExternal(self: *Self, signature: model.Signature, input: ir.TypeId, output: ir.TypeId, implementation: ir.External) Error!ir.FunctionId {
    for (self.functions.items, 0..) |existing, index| {
        const other = existing.external orelse continue;

        if (!std.mem.eql(u8, self.native_modules.items[@intFromEnum(other.module)].specifier, self.native_modules.items[@intFromEnum(implementation.module)].specifier)) continue;
        if (!std.mem.eql(u8, other.exportName(), implementation.exportName())) continue;
        if (existing.input_type != input or existing.output_type != output or existing.output_ownership != signature.output_ownership or !native.sameExternal(other, implementation)) return error.ConflictingInterface;

        return @enumFromInt(index);
    }

    const id: ir.FunctionId = @enumFromInt(self.functions.items.len);

    try self.functions.append(self.allocator, .{ .file_name = try self.allocator.dupe(u8, signature.file_name), .input_type = input, .output_type = output, .output_ownership = signature.output_ownership, .external = implementation, .symbols = &.{}, .expressions = &.{}, .body = &.{} });

    return id;
}

fn find(self: *const Self, path: []const u8) ?usize {
    for (self.modules, 0..) |value, index| {
        if (std.mem.eql(u8, value.path, path)) return index;
    }

    return null;
}

fn sourceDependency(value: model.Module, path: []const u8) bool {
    for (value.dependencies) |dependency| {
        if (dependency.target == .source and dependency.kind == .function and std.mem.eql(u8, dependency.target.source, path)) return true;
    }

    return false;
}
