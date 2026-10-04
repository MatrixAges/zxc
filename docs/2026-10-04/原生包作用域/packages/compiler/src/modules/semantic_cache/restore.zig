const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../artifact/model.zig");
const Nodes = @import("../artifact/nodes.zig");
const Types = @import("../link/types.zig");
const native = @import("../link/native.zig");
const Origins = @import("../nominal_origins.zig");
const Record = @import("../module_record.zig");
const FunctionImport = @import("../function_import.zig");

pub const Current = struct {
    allocator: std.mem.Allocator,
    types: []const ir.Type,
    nominal_types: []const Origins.Item,
    functions: []const ir.Function,
    native_modules: []const ir.NativeModule,
    aliases: []const ir.Export,
    imports: []const FunctionImport,
    dependencies: []const Record.Import,
};

pub const Result = struct { program: ir.Program, nominal_types: []const Origins.Item };
const Error = Types.Error || model.Error;

pub fn restore(module: model.Module, current: Current) std.mem.Allocator.Error!?Result {
    return restoreChecked(module, current) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return null;
    };
}

fn restoreChecked(module: model.Module, current: Current) Error!Result {
    if (!sameDependencies(module.dependencies, current.dependencies)) return error.InvalidModule;
    if (module.type_imports.len != current.aliases.len or module.function_imports.len != current.imports.len) return error.InvalidModule;

    const allocator = current.allocator;
    var types = Types{ .allocator = allocator, .origins = .{ .allocator = allocator } };

    if (current.types.len == 0) {
        types = try Types.init(allocator);
    } else {
        try types.items.appendSlice(allocator, current.types);
        try types.origins.items.appendSlice(allocator, current.nominal_types);
    }

    const mapping = try types.append(allocator, module);
    const function_mapping = try allocator.alloc(?ir.FunctionId, module.functions.len);
    const native_mapping = try allocator.alloc(?ir.NativeModuleId, module.native_modules.len);

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = function_mapping, .native_modules = native_mapping };

    for (module.type_imports, current.aliases) |previous, alias| {
        if (!std.mem.eql(u8, previous.name, alias.name) or try nodes.types.include(previous.type_id) != alias.type_id) return error.InvalidModule;
    }

    for (module.native_modules, native_mapping) |previous, *id| {
        for (current.native_modules, 0..) |candidate, index| {
            if (!std.mem.eql(u8, previous.key(), candidate.key()) or !std.mem.eql(u8, previous.import_name, candidate.import_name)) continue;
            if (!native.stringsEqual(previous.type_namespace, candidate.type_namespace) or previous.types.len != candidate.types.len) return error.InvalidModule;

            for (previous.types, candidate.types) |a, b| {
                if (!std.mem.eql(u8, a.name, b.name) or try nodes.types.include(a.type_id) != b.type_id) return error.InvalidModule;
            }

            id.* = @enumFromInt(index);

            break;
        }

        if (id.* == null) return error.InvalidModule;
    }

    for (module.function_imports, current.imports) |previous, binding| {
        if (!std.mem.eql(u8, previous.name, binding.name) or !optionalName(previous.namespace, binding.namespace)) return error.InvalidModule;
        if (try nodes.types.include(previous.input_type) != binding.input_type or try nodes.types.include(previous.output_type) != binding.output_type) return error.InvalidModule;
        if ((previous.positional_types == null) != (binding.positional_types == null)) return error.InvalidModule;

        if (previous.positional_types) |positional| {
            if (positional.len != binding.positional_types.?.len) return error.InvalidModule;

            for (positional, binding.positional_types.?) |a, b| {
                if (try nodes.types.include(a) != b) return error.InvalidModule;
            }
        }

        const index = @intFromEnum(previous.id);

        if (index >= function_mapping.len or @intFromEnum(binding.id) >= current.functions.len) return error.InvalidModule;

        if (function_mapping[index]) |mapped| {
            if (mapped != binding.id) return error.InvalidModule;
        }

        function_mapping[index] = binding.id;
    }

    for (module.functions, function_mapping) |signature, id| {
        const function = current.functions[@intFromEnum(id orelse return error.InvalidModule)];

        if (!std.mem.eql(u8, signature.file_name, function.file_name) or try nodes.types.include(signature.input_type) != function.input_type or try nodes.types.include(signature.output_type) != function.output_type or signature.output_ownership != function.output_ownership) return error.InvalidModule;

        if (signature.external) |external| {
            if (external.member.len == 0) return error.InvalidModule;

            const implementation = function.external orelse return error.InvalidModule;
            const mapped = try nodes.external(external);

            if (!std.mem.eql(u8, mapped.exportName(), implementation.exportName()) or !native.sameExternal(mapped, implementation)) return error.InvalidModule;
        } else if (function.external != null) return error.InvalidModule;
    }

    const function = if (module.function) |value| try nodes.function(value) else null;
    const exports = try allocator.dupe(ir.Export, module.exports);
    const stores = try allocator.dupe(ir.StoreSlot, module.stores);
    const contexts = try allocator.dupe(ir.ContextSlot, module.contexts);

    for (exports) |*item| {
        item.name = try allocator.dupe(u8, item.name);
        item.type_id = try nodes.types.include(item.type_id);
    }

    for (stores) |*item| {
        item.path = try allocator.dupe(u8, item.path);
        item.handle = try allocator.dupe(u8, item.handle);
        item.type_id = try nodes.types.include(item.type_id);
    }

    for (contexts) |*item| {
        item.id = try allocator.dupe(u8, item.id);
        item.type_id = try nodes.types.include(item.type_id);
    }

    const result = Result{ .nominal_types = types.origins.items.items, .program = .{
        .file_name = try allocator.dupe(u8, module.path),
        .types = types.items.items,
        .input_type = if (function) |value| value.input_type else @enumFromInt(0),
        .output_type = if (function) |value| value.output_type else @enumFromInt(0),
        .output_ownership = if (function) |value| value.output_ownership else .borrowed,
        .symbols = if (function) |value| value.symbols else &.{},
        .expressions = if (function) |value| value.expressions else &.{},
        .body = if (function) |value| value.body else &.{},
        .contracts = if (function) |value| value.contracts else &.{},
        .exports = exports,
        .stores = stores,
        .contexts = contexts,
        .functions = try allocator.dupe(ir.Function, current.functions),
        .native_modules = current.native_modules,
        .type_only = function == null,
    } };

    if (try @import("../../ir/validate.zig").validate(allocator, result.program) != null) return error.InvalidIr;

    return result;
}

fn optionalName(left: ?[]const u8, right: ?[]const u8) bool {
    if (left) |name| return std.mem.eql(u8, name, right orelse return false);

    return right == null;
}

fn sameDependencies(left: []const Record.Import, right: []const Record.Import) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!std.mem.eql(u8, a.identity orelse a.specifier, b.identity orelse b.specifier)) return false;
        if (a.kind != b.kind or !std.mem.eql(u8, a.specifier, b.specifier) or !native.stringsEqual(a.names, b.names) or std.meta.activeTag(a.target) != std.meta.activeTag(b.target)) return false;
        if (a.target == .source and !std.mem.eql(u8, a.target.source, b.target.source)) return false;
    }

    return true;
}
