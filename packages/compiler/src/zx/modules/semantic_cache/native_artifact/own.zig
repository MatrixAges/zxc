const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../artifact/model.zig");
const FunctionImport = @import("../../function_import.zig");
const Origins = @import("../../nominal_origins.zig");
const strings = @import("../../compiled/host/native.zig").strings;

pub fn artifact(allocator: std.mem.Allocator, value: anytype, key: []const u8, fingerprint: [32]u8) std.mem.Allocator.Error!Artifact.Module {
    const path = try allocator.dupe(u8, key);
    const types = try zx.columns.own(allocator, zx.columns.view(ir.TypeTable, value.types), .{});
    const names = try strings(allocator, value.exports.names);
    const ids = try allocator.dupe(u32, value.exports.ids);
    const exports = try allocator.alloc(ir.Export, names.len);

    for (exports, names, ids) |*target, name, id| target.* = .{ .name = name, .type_id = @fromBackingInt(id) };

    const raw = zx.columns.view(ir.NativeModuleTable, value.modules);
    const namespace = try strings(allocator, raw.type_namespaces[0]);

    const modules = try zx.columns.own(allocator, raw, .{
        .identities = try allocator.dupe(?[]const u8, &.{if (raw.identities[0] != null) path else null}),
        .type_ids = try allocator.dupe([]const u32, &.{ids}),
        .type_names = try allocator.dupe([]const []const u8, &.{names}),
        .type_namespaces = try allocator.dupe([]const []const u8, &.{namespace}),
    });

    const bindings = try allocator.alloc(FunctionImport, value.function_ids.len);
    const functions = try signatures(allocator, zx.columns.view(ir.SignatureTable, value.signatures), namespace, value.function_ids, bindings);

    return .{
        .path = path,
        .source_digest = fingerprint,
        .types = types,
        .nominal_types = try origins(allocator, types, value.origins, path),
        .exports = exports,
        .function_imports = bindings,
        .functions = functions,
        .native_modules = modules,
        .dependencies = &.{},
        .type_imports = &.{},
        .function = null,
        .stores = .{},
    };
}

fn origins(allocator: std.mem.Allocator, types: ir.TypeTable, source: anytype, owner: []const u8) std.mem.Allocator.Error!Origins.Table {
    const ids = try allocator.dupe(u32, source.ids);
    const owners = try allocator.alloc([]const u8, ids.len);
    const members = try allocator.alloc([]const u8, ids.len);
    const names = try allocator.alloc([]const u8, ids.len);

    @memset(owners, owner);
    @memset(members, "");
    for (ids, names) |id, *name| name.* = types.labels[id];

    return .{ .ids = ids, .kinds = try allocator.dupe(u8, source.kinds), .owners = owners, .members = members, .names = names };
}

fn signatures(allocator: std.mem.Allocator, table: ir.SignatureTable, namespace: []const []const u8, ids: []const u32, bindings: []FunctionImport) std.mem.Allocator.Error!ir.SignatureTable {
    if (table.count() == 0) return .{};

    const files = try allocator.alloc([]const u8, table.count());
    const file = try allocator.dupe(u8, table.files[0]);
    const members = try allocator.alloc([]const []const u8, table.count());
    const names = try allocator.alloc(?[]const u8, table.count());
    const inputs = try allocator.alloc(?[]const ?[]const u8, table.count());
    const errors = try allocator.alloc(?[]const []const u8, table.count());

    @memset(files, file);

    for (ids, bindings, members, names, inputs, errors, 0..) |id, *binding, *member, *name, *input, *error_set, index| {
        const source = table.at(index);
        var external = source.external.?;
        const owned = try allocator.dupe(u8, external.exportName());
        const parts = try allocator.alloc([]const u8, namespace.len + 1);

        @memcpy(parts[0..namespace.len], namespace);

        parts[namespace.len] = owned;
        external = try @import("../../compiled/host/function.zig").copyExternalDetails(allocator, external);
        member.* = parts;
        name.* = owned;
        input.* = if (external.input) |native_input| native_input.names else null;
        error_set.* = external.errors;
        binding.* = .{ .name = owned, .id = @fromBackingInt(id), .input_type = source.input_type, .output_type = source.output_type };
    }

    return zx.columns.own(allocator, table, .{
        .files = files,
        .native_members = members,
        .native_exports = names,
        .native_inputs = inputs,
        .native_errors = errors,
    });
}
