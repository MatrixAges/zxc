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

pub const Current = struct { module: ir.NativeModuleId, types: *ir.TypeStorage, origins: *Origins };
pub const Error = Types.Error || Artifact.Error;

pub fn restore(allocator: std.mem.Allocator, artifact: Artifact.Module, entry: Native, current: Current) Error!Loaded.Result {
    if (!artifact.functions.validStructure() or !artifact.native_modules.validStructure() or artifact.function != null or artifact.native_modules.count() != 1 or artifact.dependencies.len != 0 or artifact.type_imports.len != 0 or artifact.stores.count() != 0) return error.InvalidModule;
    if (!std.mem.eql(u8, artifact.path, entry.key()) or artifact.functions.count() != artifact.function_imports.len) return error.InvalidModule;

    const descriptor = artifact.native_modules.at(0);

    if (!std.mem.eql(u8, descriptor.key(), entry.key())) return error.InvalidModule;
    if (!std.mem.eql(u8, descriptor.specifier, entry.specifier) or !std.mem.eql(u8, descriptor.import_name, entry.module) or !native.stringsEqual(descriptor.type_namespace, entry.namespace)) return error.InvalidModule;
    if (descriptor.types.count() != artifact.exports.len) return error.InvalidModule;

    for (0..descriptor.types.count(), artifact.exports) |binding_index, right| {
        const left = descriptor.types.at(binding_index);

        if (left.type_id != right.type_id or !std.mem.eql(u8, left.name, right.name)) return error.InvalidModule;
    }

    if (!artifact.nominal_types.hasValidShape()) return error.InvalidModule;

    for (0..artifact.nominal_types.count()) |origin_index| {
        const item = artifact.nominal_types.at(origin_index);

        if (item.origin != .native or !std.mem.eql(u8, item.origin.native, entry.key())) return error.InvalidModule;
    }

    var functions: ir.FunctionStorage = .{};

    defer functions.deinit(allocator);

    for (artifact.function_imports, 0..) |binding, index| {
        const signature = artifact.functions.at(index);
        const external = signature.external orelse return error.InvalidModule;

        if (!std.mem.eql(u8, signature.file_name, entry.path) or @backingInt(binding.id) != index or binding.namespace != null or binding.input_type != signature.input_type or binding.output_type != signature.output_type) return error.InvalidModule;
        if (external.module != @as(ir.NativeModuleId, @fromBackingInt(@intCast(0))) or external.member.len != entry.namespace.len + 1) return error.InvalidModule;
        if (!native.stringsEqual(external.member[0..entry.namespace.len], entry.namespace) or !std.mem.eql(u8, external.member[entry.namespace.len], external.exportName()) or !std.mem.eql(u8, binding.name, external.exportName())) return error.InvalidModule;
        try functions.append(allocator, .{ .file_name = signature.file_name, .input_type = signature.input_type, .output_type = signature.output_type, .output_ownership = signature.output_ownership, .external = external, .symbols = .{}, .expressions = .{}, .body = .{} });
    }

    const program = ir.Program{ .file_name = entry.path, .types = artifact.types, .input_type = @fromBackingInt(@intCast(0)), .output_type = @fromBackingInt(@intCast(0)), .symbols = .{}, .expressions = .{}, .body = .{}, .exports = artifact.exports, .native_modules = artifact.native_modules, .functions = functions.view(), .type_only = true };

    if (try @import("../../ir/validate.zig").validate(allocator, program) != null) return error.InvalidIr;

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

    const mapping = try types.append(allocator, artifact);
    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = &.{} }, .native_modules = .{ .indexed = &.{current.module} } };
    const exports = try allocator.dupe(ir.Export, artifact.exports);

    for (exports) |*item| {
        item.name = try allocator.dupe(u8, item.name);
        item.type_id = try nodes.types.include(item.type_id);
    }

    const members = try allocator.alloc(Loaded.Member, functions.count());

    for (members, 0..) |*member, index| {
        const function = functions.at(index);
        member.* = .{ .name = try allocator.dupe(u8, function.external.?.exportName()), .function = try nodes.function(function) };
    }

    return .{ .types = types.items.view(), .exports = exports, .members = members };
}
