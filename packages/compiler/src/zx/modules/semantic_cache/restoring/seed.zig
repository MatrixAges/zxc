const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../../artifact/model.zig");
const Nodes = @import("../../artifact/nodes.zig");
const native = @import("../../link/native.zig");
const Record = @import("../../module_record.zig");
const FunctionImport = @import("../../function_import.zig");
const Error = model.Error;

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

pub fn sameSignature(previous: ir.Signature, current: ir.Signature, types: Nodes.TypeMap) Error!bool {
    return std.mem.eql(u8, previous.file_name, current.file_name) and
        try types.include(previous.input_type) == current.input_type and
        try types.include(previous.output_type) == current.output_type and
        previous.output_ownership == current.output_ownership;
}

pub fn restoreNative(modules: ir.NativeModuleTable, previous: ir.NativeModule, types: Nodes.TypeMap) Error!ir.NativeModuleId {
    for (0..modules.count()) |index| {
        const candidate = modules.at(index);

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
