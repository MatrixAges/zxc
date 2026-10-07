const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("../interface.zig").Native;
const Loaded = @import("../native.zig");
const Artifact = @import("../artifact/model.zig");
const Nodes = @import("../artifact/nodes.zig");
const Types = @import("../link/types.zig");
const Origins = @import("../nominal_origins.zig");
const native = @import("../link/native.zig");

pub const Current = struct { module: ir.NativeModuleId, types: ir.TypeTable, nominal_types: Origins.Table };
pub const Error = Types.Error || Artifact.Error;

pub fn restore(allocator: std.mem.Allocator, artifact: Artifact.Module, entry: Native, current: Current) Error!Loaded.Result {
    if (artifact.function != null or artifact.native_modules.len != 1 or artifact.dependencies.len != 0 or artifact.type_imports.len != 0 or artifact.stores.len != 0) return error.InvalidModule;
    if (!std.mem.eql(u8, artifact.path, entry.key()) or artifact.functions.len != artifact.function_imports.len) return error.InvalidModule;

    const descriptor = artifact.native_modules[0];

    if (!std.mem.eql(u8, descriptor.key(), entry.key())) return error.InvalidModule;
    if (!std.mem.eql(u8, descriptor.specifier, entry.specifier) or !std.mem.eql(u8, descriptor.import_name, entry.module) or !native.stringsEqual(descriptor.type_namespace, entry.namespace)) return error.InvalidModule;
    if (descriptor.types.len != artifact.exports.len) return error.InvalidModule;

    for (descriptor.types, artifact.exports) |left, right| {
        if (left.type_id != right.type_id or !std.mem.eql(u8, left.name, right.name)) return error.InvalidModule;
    }

    if (!artifact.nominal_types.hasValidShape()) return error.InvalidModule;

    for (0..artifact.nominal_types.count()) |origin_index| {
        const item = artifact.nominal_types.at(origin_index);

        if (item.origin != .native or !std.mem.eql(u8, item.origin.native, entry.key())) return error.InvalidModule;
    }

    const functions = try allocator.alloc(ir.Function, artifact.functions.len);

    for (artifact.functions, artifact.function_imports, functions, 0..) |signature, binding, *function, index| {
        const external = signature.external orelse return error.InvalidModule;

        if (!std.mem.eql(u8, signature.file_name, entry.path) or @backingInt(binding.id) != index or binding.namespace != null or binding.input_type != signature.input_type or binding.output_type != signature.output_type) return error.InvalidModule;
        if (external.module != @as(ir.NativeModuleId, @fromBackingInt(@intCast(0))) or external.member.len != entry.namespace.len + 1) return error.InvalidModule;
        if (!native.stringsEqual(external.member[0..entry.namespace.len], entry.namespace) or !std.mem.eql(u8, external.member[entry.namespace.len], external.exportName()) or !std.mem.eql(u8, binding.name, external.exportName())) return error.InvalidModule;

        function.* = .{ .file_name = signature.file_name, .input_type = signature.input_type, .output_type = signature.output_type, .output_ownership = signature.output_ownership, .external = external, .symbols = .{}, .expressions = .{}, .body = .{} };
    }

    const program = ir.Program{ .file_name = entry.path, .types = artifact.types, .input_type = @fromBackingInt(@intCast(0)), .output_type = @fromBackingInt(@intCast(0)), .symbols = .{}, .expressions = .{}, .body = .{}, .exports = artifact.exports, .native_modules = artifact.native_modules, .functions = functions, .type_only = true };

    if (try @import("../../ir/validate.zig").validate(allocator, program) != null) return error.InvalidIr;

    for (functions, artifact.function_imports) |function, binding| {
        if (function.external.?.expand_tuple) {
            const positional = binding.positional_types orelse return error.InvalidModule;

            if (positional.len != positional.values.len) return error.InvalidModule;
            if (!std.mem.eql(u32, positional.values, artifact.types.at(@backingInt(function.input_type)).tuple.values)) return error.InvalidModule;
        } else if (binding.positional_types != null) return error.InvalidModule;
    }

    var types = Types{ .allocator = allocator, .origins = .{ .allocator = allocator } };

    if (current.types.count() == 0) {
        types = try Types.init(allocator);
    } else {
        try types.items.appendDelta(allocator, current.types);
        try types.origins.items.appendTable(allocator, current.nominal_types);
    }

    const mapping = try types.append(allocator, artifact);
    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = &.{}, .native_modules = &.{current.module} };
    const exports = try allocator.dupe(ir.Export, artifact.exports);

    for (exports) |*item| {
        item.name = try allocator.dupe(u8, item.name);
        item.type_id = try nodes.types.include(item.type_id);
    }

    const members = try allocator.alloc(Loaded.Member, functions.len);

    for (functions, members) |function, *member| member.* = .{ .name = try allocator.dupe(u8, function.external.?.exportName()), .function = try nodes.function(function) };

    return .{ .types = types.items.view(), .exports = exports, .members = members };
}
