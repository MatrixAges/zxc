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
plan: @import("graph.zig").Plan,
type_mappings: []const []const ir.TypeId,
functions: ir.FunctionStorage = .{},
native_modules: ir.NativeModuleStorage = .{},
module_functions: []?ir.FunctionId,
pub fn module(self: *Self, index: usize, detect_recursion: bool) Error!?Nodes.FunctionEntry {
    const value = &self.modules[index];

    if (!value.native_modules.validStructure() or !value.functions.validStructure()) return error.InvalidModule;

    const function_mapping = try self.temporary.alloc(?ir.FunctionId, value.functions.count() + @intFromBool(value.function != null));
    const native_mapping = try self.temporary.alloc(?ir.NativeModuleId, value.native_modules.count());

    @memset(function_mapping, null);
    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = self.allocator, .types = .{ .mapped = self.type_mappings[index] }, .functions = .{ .indexed = function_mapping }, .native_modules = .{ .indexed = native_mapping } };

    if (comptime @import("parser_options").generated_parser) {
        try @import("surface/host.zig").admit(self.temporary, value.exports, value.type_imports, self.type_mappings[index].len);
    } else {
        try checkExportsSeed(value.exports, nodes.types);
        try checkExportsSeed(value.type_imports, nodes.types);
    }

    const constants = @import("../../analysis/constants/check.zig");

    if (!try constants.validate(self.temporary, value.types, value.constant_exports)) return error.InvalidModule;
    if (!try constants.validate(self.temporary, value.types, value.constant_imports)) return error.InvalidModule;

    for (0..value.native_modules.count(), native_mapping) |item_row, *id| {
        const item = value.native_modules.at(item_row);

        id.* = try native.append(self.allocator, &self.native_modules, item, &nodes);
    }

    const imports = function_mapping[0..value.functions.count()];

    if (comptime @import("parser_options").generated_parser) {
        try @import("signature/host.zig").bind(self, index, imports, native_mapping, &nodes);
    } else {
        try self.bindSignaturesSeed(index, imports, &nodes);
    }

    if (comptime @import("parser_options").generated_parser) {
        try @import("dependencies/host.zig").verify(self, index, function_mapping);
    } else {
        for ([_][]const @import("../function_import.zig"){ value.function_imports, value.members }) |bindings| for (bindings) |binding| {
            if (!binding.valid()) return error.InvalidModule;
            if (binding.intrinsic == null and @backingInt(binding.id.?) >= value.functions.count()) return error.InvalidModule;
        };

        try self.importsSeed(index, &nodes);
    }

    if (value.function) |function| {
        const own: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

        function_mapping[value.functions.count()] = own;

        if (function.external != null or !std.mem.eql(u8, function.file_name, value.path)) return error.InvalidModule;

        return try nodes.functionEntry(function, if (detect_recursion) own else null);
    }

    return null;
}

fn bindSignaturesSeed(self: *Self, index: usize, mapping: []?ir.FunctionId, nodes: *Nodes) Error!void {
    const value = &self.modules[index];

    for (mapping, 0..) |*id, row| {
        const signature = value.functions.at(row);
        const input = try nodes.types.include(signature.input_type);
        const output = try nodes.types.include(signature.output_type);

        if (signature.external) |external| {
            if (external.member.len == 0) return error.InvalidModule;

            id.* = try self.importExternalSeed(signature, input, output, try nodes.external(external));

            continue;
        }

        const target = self.findSeed(signature.file_name) orelse return error.InvalidModule;

        if (!self.sourceDependencySeed(value, signature.file_name)) return error.InvalidModule;

        const target_id = self.module_functions[target] orelse return error.InvalidModule;
        const callee = self.functions.at(@backingInt(target_id));

        if (callee.input_type != input or callee.output_type != output or callee.output_ownership != signature.output_ownership) return error.ConflictingInterface;

        id.* = target_id;
    }
}

fn importsSeed(self: *Self, index: usize, nodes: *Nodes) Error!void {
    const value = &self.modules[index];

    for (value.function_imports) |binding| {
        if (!binding.valid()) return error.InvalidModule;
        if (binding.intrinsic != null) continue;

        const id = try nodes.functionId(binding.id.?);
        const function = self.functions.at(@backingInt(id));

        if (try nodes.types.include(binding.input_type.?) != function.input_type or try nodes.types.include(binding.output_type.?) != function.output_type) return error.ConflictingInterface;
    }

    for (value.dependencies) |dependency| {
        if (dependency.target == .intrinsic) {
            if (!std.mem.eql(u8, dependency.specifier, @import("../intrinsic.zig").specifier) or dependency.kind == .type_only) return error.InvalidModule;

            continue;
        }

        if (dependency.target != .source) {
            var found = false;

            for (0..value.native_modules.count()) |item_row| {
                const item = value.native_modules.at(item_row);

                if (std.mem.eql(u8, item.specifier, dependency.specifier)) found = true;
            }

            if (!found) return error.InvalidModule;

            continue;
        }

        const target_index = self.findSeed(dependency.target.source) orelse return error.InvalidModule;
        const target = &self.modules[target_index];
        const members = @import("members.zig");
        const consumers = if (dependency.exported) value.members else value.function_imports;

        if (dependency.kind == .function) {
            if (dependency.names.len != 1) return error.InvalidModule;

            if (members.find(target, "")) |member| {
                try members.check(target, member, consumers, dependency.names[0], nodes, self.functions.view(), self.type_mappings[target_index]);
            } else if (target.function == null) return error.InvalidModule;

            continue;
        }

        if (dependency.wildcard and dependency.kind != .type_only) for (target.members) |member| {
            if (member.name.len != 0) try members.check(target, member, consumers, member.name, nodes, self.functions.view(), self.type_mappings[target_index]);
        };

        if (target.function != null and dependency.kind != .enumeration) return error.InvalidModule;

        const Bindings = @import("../../analysis/constants/bindings.zig");

        var constants: ?Bindings.Prepared = if (dependency.kind == .enumeration and target.constant_exports.len != 0) try Bindings.prepare(self.temporary, .{
            .previous = target.constant_exports,
            .current = value.constant_imports,
            .mapping = self.type_mappings[target_index],
            .current_mapping = self.type_mappings[index],
        }) else null;

        defer if (constants) |*prepared| prepared.deinit();

        if (dependency.source_names.len != 0 and dependency.source_names.len != dependency.names.len) return error.InvalidModule;

        for (dependency.names, 0..) |name, name_index| {
            const original = if (dependency.source_names.len == 0) name else dependency.source_names[name_index];

            if (dependency.kind != .type_only) if (members.find(target, original)) |member| {
                try members.check(target, member, consumers, name, nodes, self.functions.view(), self.type_mappings[target_index]);

                continue;
            };

            if (constants) |*prepared| {
                const comparison = try prepared.compare(name);

                switch (comparison) {
                    .Equal => continue,
                    .Different => return error.ConflictingInterface,
                    .Missing => {},
                }
            }

            if (target.function != null) return error.InvalidModule;

            var exported: ?ir.TypeId = null;
            var imported: ?ir.TypeId = null;

            for (target.exports) |item| {
                if (!std.mem.eql(u8, item.name, original)) continue;
                if (@backingInt(item.type_id) >= self.type_mappings[target_index].len) return error.InvalidModule;
                if (dependency.kind == .enumeration and target.types.at(@backingInt(item.type_id)) != .enumeration) return error.ConflictingInterface;

                exported = self.type_mappings[target_index][@backingInt(item.type_id)];
            }

            for (value.type_imports) |item| {
                if (std.mem.eql(u8, item.name, name)) imported = try nodes.types.include(item.type_id);
            }

            if (exported == null or imported == null or exported.? != imported.?) return error.ConflictingInterface;
        }
    }
}

fn checkExportsSeed(values: []const ir.Export, mapping: Nodes.TypeMap) Error!void {
    for (values, 0..) |item, index| {
        if (item.name.len == 0) return error.InvalidModule;

        _ = try mapping.include(item.type_id);

        for (values[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, item.name)) return error.InvalidModule;
        }
    }
}

fn importExternalSeed(self: *Self, signature: model.Signature, input: ir.TypeId, output: ir.TypeId, implementation: ir.External) Error!ir.FunctionId {
    for (0..self.functions.count()) |index| {
        const existing = self.functions.at(index);
        const other = existing.external orelse continue;

        if (!std.mem.eql(u8, self.native_modules.at(@backingInt(other.module)).key(), self.native_modules.at(@backingInt(implementation.module)).key())) continue;
        if (!std.mem.eql(u8, other.exportName(), implementation.exportName())) continue;
        if (existing.input_type != input or existing.output_type != output or existing.output_ownership != signature.output_ownership or !native.sameExternalSeed(other, implementation)) return error.ConflictingInterface;

        return @fromBackingInt(@intCast(index));
    }

    const id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));
    var resolved = signature;
    resolved.input_type = input;
    resolved.output_type = output;

    try self.appendExternal(resolved, implementation);

    return id;
}

pub fn appendExternal(self: *Self, signature: model.Signature, implementation: ir.External) Error!void {
    try self.functions.append(self.allocator, .{
        .file_name = try self.allocator.dupe(u8, signature.file_name),
        .input_type = signature.input_type,
        .output_type = signature.output_type,
        .output_ownership = signature.output_ownership,
        .external = implementation,
        .symbols = .{},
        .expressions = .{},
        .body = .{},
    });
}

fn findSeed(self: *const Self, path: []const u8) ?usize {
    for (self.plan.order) |index| {
        if (std.mem.eql(u8, self.modules[index].path, path)) return index;
    }

    return null;
}

fn sourceDependencySeed(self: *Self, value: *const model.Module, path: []const u8) bool {
    for (value.dependencies) |dependency| {
        if (dependency.target != .source or dependency.kind == .type_only) continue;
        if (dependency.kind == .function and std.mem.eql(u8, dependency.target.source, path)) return true;

        const target = &self.modules[self.findSeed(dependency.target.source) orelse return false];

        for (target.members) |member| {
            if (member.intrinsic != null or !member.valid()) continue;
            if (@backingInt(member.id.?) >= target.functions.count()) return false;
            if (std.mem.eql(u8, target.functions.at(@backingInt(member.id.?)).file_name, path)) return true;
        }
    }

    return false;
}
