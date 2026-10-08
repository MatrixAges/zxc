const std = @import("std");
const ir = @import("zx").ir;
const Analysis = @import("../../analysis/analyze.zig");
const Record = @import("../module_record.zig");
const FunctionImport = @import("../function_import.zig");
const Types = @import("types.zig");
const Nodes = @import("nodes.zig");
const model = @import("model.zig");
const Error = model.Error;
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
types: Types,
function_mapping: []?ir.FunctionId,
native_mapping: []?ir.NativeModuleId,
functions: std.ArrayList(model.Signature) = .empty,
native_modules: ir.NativeModuleStorage = .{},
pub fn init(allocator: std.mem.Allocator, temporary: std.mem.Allocator, analysis: *const Analysis.Result) Error!Self {
    const program = analysis.value.ir;
    const functions = try temporary.alloc(?ir.FunctionId, program.functions.count());
    const native_modules = try temporary.alloc(?ir.NativeModuleId, program.native_modules.count());

    @memset(functions, null);
    @memset(native_modules, null);

    return .{ .allocator = allocator, .program = program, .types = try Types.init(allocator, temporary, program.types, analysis.nominal_types), .function_mapping = functions, .native_mapping = native_modules };
}

pub fn extract(self: *Self, record: Record) Error!model.Module {
    var roots = try @import("roots.zig").collect(self.types.temporary, self.program, record);

    defer roots.deinit();

    for (roots.needed, 0..) |included, index| {
        if (included) _ = try self.types.include(@fromBackingInt(@intCast(index)));
    }

    for (0..self.program.native_modules.count()) |index| {
        const module = self.program.native_modules.at(index);

        for (0..module.types.count()) |binding_index| {
            const binding = module.types.at(binding_index);

            if (self.program.typeOf(binding.type_id) != .native_reference or self.types.mapping[@backingInt(binding.type_id)] == null) continue;
            try self.nativeModule(@fromBackingInt(@intCast(index)));

            break;
        }
    }

    const type_imports = try self.exports(record.type_imports);

    for (record.imports) |dependency| {
        if (dependency.target != .native) continue;

        var found = false;

        for (0..self.program.native_modules.count()) |index| {
            const module = self.program.native_modules.at(index);

            if (!std.mem.eql(u8, module.key(), dependency.identity orelse dependency.specifier)) continue;
            try self.nativeModule(@fromBackingInt(@intCast(index)));

            found = true;
        }

        if (!found) return error.InvalidModule;
    }

    const function_imports = try self.allocator.dupe(FunctionImport, record.function_imports);

    for (function_imports) |*binding| {
        const index = @backingInt(binding.id);

        if (index >= self.program.functions.count()) return error.InvalidModule;

        const function = self.program.functions.at(index);

        if (binding.input_type != function.input_type or binding.output_type != function.output_type) return error.InvalidModule;

        binding.id = try self.importFunction(binding.id);
        binding.name = try self.allocator.dupe(u8, binding.name);
        binding.namespace = if (binding.namespace) |name| try self.allocator.dupe(u8, name) else null;
        binding.input_type = try self.types.include(binding.input_type);
        binding.output_type = try self.types.include(binding.output_type);
    }

    const exported = try self.exports(record.exports);
    const function = try self.copyFunction(record);
    var nodes = self.nodeCopier();
    const stores = try nodes.stores(if (record.body == .entry) self.program.stores else if (record.body == .function) self.program.functions.at(@backingInt(record.body.function)).stores else .{});
    const dependencies = try self.allocator.dupe(Record.Import, record.imports);

    for (dependencies) |*dependency| {
        dependency.specifier = try self.allocator.dupe(u8, dependency.specifier);
        dependency.identity = if (dependency.identity) |key| try self.allocator.dupe(u8, key) else null;
        dependency.names = try nodes.strings(dependency.names);

        dependency.target = switch (dependency.target) {
            .compiled => return error.InvalidModule,
            .source => |path| .{ .source = try self.allocator.dupe(u8, path) },
            .native, .external => dependency.target,
        };
    }

    return .{
        .path = try self.allocator.dupe(u8, record.path),
        .source_digest = record.source_digest,
        .dependencies = dependencies,
        .types = self.types.items.view(),
        .nominal_types = self.types.nominal_origins.items.view(),
        .exports = exported,
        .type_imports = type_imports,
        .function_imports = function_imports,
        .functions = self.functions.items,
        .native_modules = self.native_modules.view(),
        .function = function,
        .stores = stores,
    };
}

fn copyFunction(self: *Self, record: Record) Error!?ir.Function {
    const value: ir.Function = switch (record.body) {
        .types => return null,
        .entry => blk: {
            if (self.program.type_only or !std.mem.eql(u8, record.path, self.program.file_name)) return error.InvalidModule;

            break :blk .{ .stores = self.program.stores, .store_mode = self.program.store_mode, .file_name = self.program.file_name, .input_type = self.program.input_type, .output_type = self.program.output_type, .output_ownership = self.program.output_ownership, .symbols = self.program.symbols, .expressions = self.program.expressions, .body = self.program.body, .contracts = self.program.contracts };
        },
        .function => |id| blk: {
            if (@backingInt(id) >= self.program.functions.count()) return error.InvalidModule;

            const value = self.program.functions.at(@backingInt(id));

            if (value.external != null or !std.mem.eql(u8, record.path, value.file_name)) return error.InvalidModule;

            break :blk value;
        },
    };

    var nodes = self.nodeCopier();

    return try nodes.function(value);
}

fn importFunction(self: *Self, id: ir.FunctionId) Error!ir.FunctionId {
    const index = @backingInt(id);

    if (index >= self.program.functions.count()) return error.InvalidModule;
    if (self.function_mapping[index]) |mapped| return mapped;

    const value = self.program.functions.at(index);

    if (value.external) |external| try self.nativeModule(external.module);

    var nodes = self.nodeCopier();
    const mapped: ir.FunctionId = @fromBackingInt(@intCast(self.functions.items.len));

    try self.functions.append(self.allocator, .{
        .file_name = try self.allocator.dupe(u8, value.file_name),
        .input_type = try self.types.include(value.input_type),
        .output_type = try self.types.include(value.output_type),
        .output_ownership = value.output_ownership,
        .external = if (value.external) |external| try nodes.external(external) else null,
    });

    self.function_mapping[index] = mapped;

    return mapped;
}

fn nativeModule(self: *Self, id: ir.NativeModuleId) Error!void {
    const index = @backingInt(id);

    if (index >= self.program.native_modules.count()) return error.InvalidModule;
    if (self.native_mapping[index] != null) return;

    const value = self.program.native_modules.at(index);
    var nodes = self.nodeCopier();
    const mapped: ir.NativeModuleId = @fromBackingInt(@intCast(self.native_modules.count()));
    const names = try self.allocator.alloc([]const u8, value.types.count());
    const ids = try self.allocator.alloc(u32, value.types.count());

    for (value.types.names, value.types.type_ids, names, ids) |name, type_id, *mapped_name, *mapped_id| {
        mapped_name.* = try self.allocator.dupe(u8, name);
        mapped_id.* = @backingInt(try self.types.include(@fromBackingInt(type_id)));
    }

    try self.native_modules.append(self.allocator, .{
        .specifier = try self.allocator.dupe(u8, value.specifier),
        .identity = if (value.identity) |key| try self.allocator.dupe(u8, key) else null,
        .import_name = try self.allocator.dupe(u8, value.import_name),
        .type_namespace = try nodes.strings(value.type_namespace),
        .types = .{ .names = names, .type_ids = ids },
    });

    self.native_mapping[index] = mapped;
}

fn exports(self: *Self, values: []const ir.Export) Error![]const ir.Export {
    const result = try self.allocator.alloc(ir.Export, values.len);

    for (values, result) |value, *owned| owned.* = .{ .name = try self.allocator.dupe(u8, value.name), .type_id = try self.types.include(value.type_id) };

    return result;
}

fn nodeCopier(self: *Self) Nodes {
    return .{ .allocator = self.allocator, .types = .{ .collect = &self.types }, .functions = self.function_mapping, .native_modules = self.native_mapping };
}
