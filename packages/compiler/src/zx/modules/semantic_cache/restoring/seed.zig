const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../../artifact/model.zig");
const Nodes = @import("../../artifact/nodes.zig");
const native = @import("../../link/native.zig");
const Record = @import("../../module_record.zig");
const FunctionImport = @import("../../function_import.zig");
const Error = model.Error;

pub fn preflight(module: *const model.Module, current: *const @import("../restore.zig").Current) bool {
    return module.native_modules.validStructure() and module.functions.validStructure() and
        current.native_modules.validStructure() and sameDependencies(module.dependencies, current.dependencies) and

        module.type_imports.len == current.aliases.len and module.function_imports.len == current.imports.len and
        module.constant_imports.len == current.constant_imports.len;
}

pub fn rebind(module: *const model.Module, current: *const @import("../restore.zig").Current, nodes: *Nodes, mapping: []?ir.FunctionId, native_mapping: []?ir.NativeModuleId) Error!?ir.FunctionId {
    for (module.type_imports, current.aliases) |*previous, *alias| {
        if (!std.mem.eql(u8, previous.name, alias.name) or try nodes.types.include(previous.type_id) != alias.type_id) return error.InvalidModule;
    }

    try modules(module.native_modules, current.native_modules, nodes.types, native_mapping);

    const imported = mapping[0..module.functions.count()];

    for (module.function_imports, current.imports) |*previous, *binding| try bind(previous, binding, imported, nodes.types, current.functions.count());

    const linked = ir.SignatureTable.fromFunctions(current.functions.view());

    try signatures(nodes, module.functions, linked, imported);

    return own(mapping, module.functions.count(), current.functions.count(), module.function != null);
}

pub fn own(mapping: []?ir.FunctionId, local_count: usize, linked_count: usize, has_body: bool) Error!?ir.FunctionId {
    if (!has_body) return null;
    if (linked_count >= std.math.maxInt(u32)) return error.OutOfMemory;

    const id: ir.FunctionId = @fromBackingInt(@as(u32, @intCast(linked_count)));

    mapping[local_count] = id;

    return id;
}

pub fn bind(previous: *const FunctionImport, binding: *const FunctionImport, mapping: []?ir.FunctionId, types: Nodes.TypeMap, current_count: usize) Error!void {
    if (!previous.valid() or !binding.valid() or previous.intrinsic != binding.intrinsic) return error.InvalidModule;
    if (!std.mem.eql(u8, previous.name, binding.name) or !optionalName(previous.namespace, binding.namespace)) return error.InvalidModule;
    if (previous.intrinsic != null) return;
    if (try types.include(previous.input_type.?) != binding.input_type or try types.include(previous.output_type.?) != binding.output_type) return error.InvalidModule;

    const index = @backingInt(previous.id.?);

    if (index >= mapping.len or @backingInt(binding.id.?) >= current_count) return error.InvalidModule;

    if (mapping[index]) |mapped| {
        if (mapped != binding.id) return error.InvalidModule;
    }

    mapping[index] = binding.id;
}

pub fn signatures(nodes: *Nodes, previous: ir.SignatureTable, current: ir.SignatureTable, mapping: []const ?ir.FunctionId) Error!void {
    for (mapping, 0..) |id, row| {
        const original = previous.at(row);
        const linked = current.at(@backingInt(id orelse return error.InvalidModule));

        if (!try sameSignature(original, linked, nodes.types)) return error.InvalidModule;

        if (original.external) |external| {
            if (external.member.len == 0) return error.InvalidModule;

            const implementation = linked.external orelse return error.InvalidModule;
            const mapped = try nodes.external(external);

            if (!std.mem.eql(u8, mapped.exportName(), implementation.exportName()) or !native.sameExternalSeed(mapped, implementation)) return error.InvalidModule;
        } else if (linked.external != null) return error.InvalidModule;
    }
}

fn sameSignature(previous: ir.Signature, current: ir.Signature, types: Nodes.TypeMap) Error!bool {
    return std.mem.eql(u8, previous.file_name, current.file_name) and
        try types.include(previous.input_type) == current.input_type and
        try types.include(previous.output_type) == current.output_type and
        previous.output_ownership == current.output_ownership;
}

pub fn constants(temporary: std.mem.Allocator, module: *const model.Module, current: []const ir.Constant, mapping: []const ir.TypeId) std.mem.Allocator.Error!bool {
    const validate = @import("../../../analysis/constants/check.zig").validate;

    if (!try validate(temporary, module.types, module.constant_exports)) return false;
    if (!try validate(temporary, module.types, module.constant_imports)) return false;

    return try @import("../../../analysis/constants/bindings.zig").compare(temporary, .{ .previous = module.constant_imports, .current = current, .mapping = mapping }) == .Equal;
}

pub fn modules(previous: ir.NativeModuleTable, current: ir.NativeModuleTable, types: Nodes.TypeMap, mapping: []?ir.NativeModuleId) Error!void {
    for (mapping, 0..) |*id, index| id.* = try restoreNative(current, previous.at(index), types);
}

fn restoreNative(current: ir.NativeModuleTable, previous: ir.NativeModule, types: Nodes.TypeMap) Error!ir.NativeModuleId {
    for (0..current.count()) |index| {
        const candidate = current.at(index);

        if (!std.mem.eql(u8, previous.key(), candidate.key()) or !std.mem.eql(u8, previous.import_name, candidate.import_name)) continue;
        if (!native.stringsEqual(previous.type_namespace, candidate.type_namespace) or previous.types.count() != candidate.types.count()) return error.InvalidModule;

        for (0..previous.types.count()) |binding_index| {
            const a = previous.types.at(binding_index);
            const b = candidate.types.at(binding_index);

            if (!std.mem.eql(u8, a.name, b.name) or try types.include(a.type_id) != b.type_id) return error.InvalidModule;
        }

        return @fromBackingInt(@intCast(index));
    }

    return error.InvalidModule;
}

fn optionalName(left: ?[]const u8, right: ?[]const u8) bool {
    if (left) |name| return std.mem.eql(u8, name, right orelse return false);

    return right == null;
}

pub fn sameDependencies(left: []const Record.Import, right: []const Record.Import) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!std.mem.eql(u8, a.identity orelse a.specifier, b.identity orelse b.specifier)) return false;
        if (a.exported != b.exported or a.wildcard != b.wildcard) return false;
        if (!native.stringsEqual(if (a.source_names.len == 0) a.names else a.source_names, if (b.source_names.len == 0) b.names else b.source_names)) return false;
        if (a.kind != b.kind or !std.mem.eql(u8, a.specifier, b.specifier) or !native.stringsEqual(a.names, b.names) or std.meta.activeTag(a.target) != std.meta.activeTag(b.target)) return false;
        if (a.target == .source and !std.mem.eql(u8, a.target.source, b.target.source)) return false;

        if (a.target == .compiled) {
            const left_target = a.target.compiled;
            const right_target = b.target.compiled;

            if (!std.mem.eql(u8, left_target.instance, right_target.instance) or !std.mem.eql(u8, left_target.artifact, right_target.artifact) or !std.mem.eql(u8, left_target.name, right_target.name)) return false;
        }
    }

    return true;
}
