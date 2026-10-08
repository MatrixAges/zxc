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
    types: *ir.TypeStorage,
    origins: *Origins,
    functions: ir.FunctionTable,
    native_modules: ir.NativeModuleTable,
    aliases: []const ir.Export,
    imports: []const FunctionImport,
    dependencies: []const Record.Import,
};

pub const Result = struct { program: ir.Program, nominal_types: Origins.Table };
const Error = Types.Error || model.Error;

pub fn restore(module: model.Module, current: Current) std.mem.Allocator.Error!?Result {
    return restoreChecked(module, current) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return null;
    };
}

fn restoreChecked(module: model.Module, current: Current) Error!Result {
    if (!module.native_modules.validStructure() or !current.native_modules.validStructure()) return error.InvalidModule;
    if (!sameDependencies(module.dependencies, current.dependencies)) return error.InvalidModule;
    if (module.type_imports.len != current.aliases.len or module.function_imports.len != current.imports.len) return error.InvalidModule;

    const allocator = current.allocator;
    const first_type = current.types.count();
    const first_origin = current.origins.items.view().count();
    var types = Types{ .allocator = allocator, .items = current.types.*, .origins = current.origins.* };

    current.types.* = .{};
    current.origins.items = .{};

    defer {
        current.types.* = types.items;
        current.origins.* = types.origins;
    }

    errdefer {
        types.items.retainPrefix(first_type);
        types.origins.items.retainPrefix(first_origin);
    }

    if (types.items.count() == 0) {
        for (std.enums.values(ir.Scalar)) |scalar| try types.items.append(allocator, .{ .scalar = scalar });
    }

    const mapping = try types.append(allocator, module);
    const function_mapping = try allocator.alloc(?ir.FunctionId, module.functions.len);
    const native_mapping = try allocator.alloc(?ir.NativeModuleId, module.native_modules.count());

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = function_mapping, .native_modules = native_mapping };

    for (module.type_imports, current.aliases) |previous, alias| {
        if (!std.mem.eql(u8, previous.name, alias.name) or try nodes.types.include(previous.type_id) != alias.type_id) return error.InvalidModule;
    }

    for (0..module.native_modules.count(), native_mapping) |previous_row, *id| {
        const previous = module.native_modules.at(previous_row);

        for (0..current.native_modules.count()) |index| {
            const candidate = current.native_modules.at(index);

            if (!std.mem.eql(u8, previous.key(), candidate.key()) or !std.mem.eql(u8, previous.import_name, candidate.import_name)) continue;
            if (!native.stringsEqual(previous.type_namespace, candidate.type_namespace) or previous.types.count() != candidate.types.count()) return error.InvalidModule;

            for (0..previous.types.count()) |binding_index| {
                const a = previous.types.at(binding_index);
                const b = candidate.types.at(binding_index);

                if (!std.mem.eql(u8, a.name, b.name) or try nodes.types.include(a.type_id) != b.type_id) return error.InvalidModule;
            }

            id.* = @fromBackingInt(@intCast(index));

            break;
        }

        if (id.* == null) return error.InvalidModule;
    }

    for (module.function_imports, current.imports) |previous, binding| {
        if (!std.mem.eql(u8, previous.name, binding.name) or !optionalName(previous.namespace, binding.namespace)) return error.InvalidModule;
        if (try nodes.types.include(previous.input_type) != binding.input_type or try nodes.types.include(previous.output_type) != binding.output_type) return error.InvalidModule;

        const index = @backingInt(previous.id);

        if (index >= function_mapping.len or @backingInt(binding.id) >= current.functions.count()) return error.InvalidModule;

        if (function_mapping[index]) |mapped| {
            if (mapped != binding.id) return error.InvalidModule;
        }

        function_mapping[index] = binding.id;
    }

    for (module.functions, function_mapping) |signature, id| {
        const function = current.functions.at(@backingInt(id orelse return error.InvalidModule));

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
    const stores = try nodes.stores(module.stores);

    for (exports) |*item| {
        item.name = try allocator.dupe(u8, item.name);
        item.type_id = try nodes.types.include(item.type_id);
    }

    const result = Result{ .nominal_types = types.origins.items.view(), .program = .{
        .file_name = try allocator.dupe(u8, module.path),
        .types = types.items.view(),
        .input_type = if (function) |value| value.input_type else @fromBackingInt(@intCast(0)),
        .output_type = if (function) |value| value.output_type else @fromBackingInt(@intCast(0)),
        .output_ownership = if (function) |value| value.output_ownership else .borrowed,
        .symbols = if (function) |value| value.symbols else .{},
        .expressions = if (function) |value| value.expressions else .{},
        .body = if (function) |value| value.body else .{},
        .contracts = if (function) |value| value.contracts else .{},
        .exports = exports,
        .stores = stores,
        .store_mode = if (function) |value| value.store_mode else .transaction,
        .functions = try current.functions.snapshot(allocator),
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

        if (a.target == .compiled) {
            const left_target = a.target.compiled;
            const right_target = b.target.compiled;

            if (!std.mem.eql(u8, left_target.instance, right_target.instance) or !std.mem.eql(u8, left_target.artifact, right_target.artifact) or !std.mem.eql(u8, left_target.name, right_target.name)) return false;
        }
    }

    return true;
}
