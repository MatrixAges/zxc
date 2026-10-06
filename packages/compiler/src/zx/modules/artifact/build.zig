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
native_modules: std.ArrayList(ir.NativeModule) = .empty,
pub fn init(allocator: std.mem.Allocator, temporary: std.mem.Allocator, analysis: *const Analysis.Result) Error!Self {
    const program = analysis.value.ir;
    const functions = try temporary.alloc(?ir.FunctionId, program.functions.len);
    const native_modules = try temporary.alloc(?ir.NativeModuleId, program.native_modules.len);

    @memset(functions, null);
    @memset(native_modules, null);

    return .{ .allocator = allocator, .program = program, .types = try Types.init(allocator, temporary, program.types, analysis.nominal_types), .function_mapping = functions, .native_mapping = native_modules };
}

pub fn extract(self: *Self, record: Record) Error!model.Module {
    const needed = try @import("roots.zig").collect(self.types.temporary, self.program, record);

    for (needed, 0..) |included, index| {
        if (included) _ = try self.types.include(@fromBackingInt(@intCast(index)));
    }

    for (self.program.native_modules, 0..) |module, index| {
        for (module.types) |binding| {
            if (self.program.typeOf(binding.type_id) != .native_reference or self.types.mapping[@backingInt(binding.type_id)] == null) continue;
            try self.nativeModule(@fromBackingInt(@intCast(index)));

            break;
        }
    }

    const type_imports = try self.exports(record.type_imports);

    for (record.imports) |dependency| {
        if (dependency.target != .native) continue;

        var found = false;

        for (self.program.native_modules, 0..) |module, index| {
            if (!std.mem.eql(u8, module.key(), dependency.identity orelse dependency.specifier)) continue;
            try self.nativeModule(@fromBackingInt(@intCast(index)));

            found = true;
        }

        if (!found) return error.InvalidModule;
    }

    const function_imports = try self.allocator.dupe(FunctionImport, record.function_imports);

    for (function_imports) |*binding| {
        const index = @backingInt(binding.id);

        if (index >= self.program.functions.len) return error.InvalidModule;

        const function = self.program.functions[index];

        if (binding.input_type != function.input_type or binding.output_type != function.output_type) return error.InvalidModule;

        binding.id = try self.importFunction(binding.id);
        binding.name = try self.allocator.dupe(u8, binding.name);
        binding.namespace = if (binding.namespace) |name| try self.allocator.dupe(u8, name) else null;
        binding.input_type = try self.types.include(binding.input_type);
        binding.output_type = try self.types.include(binding.output_type);

        if (binding.positional_types) |types| {
            const mapped = try self.allocator.alloc(ir.TypeId, types.len);

            for (types, mapped) |id, *item| item.* = try self.types.include(id);

            binding.positional_types = mapped;
        }
    }

    const exported = try self.exports(record.exports);
    const function = try self.copyFunction(record);
    const stores = try self.allocator.dupe(ir.StoreSlot, if (record.body == .entry) self.program.stores else if (record.body == .function) self.program.functions[@backingInt(record.body.function)].stores else &.{});

    for (stores) |*slot| {
        slot.path = try self.allocator.dupe(u8, slot.path);
        slot.handle = try self.allocator.dupe(u8, slot.handle);
        slot.type_id = try self.types.include(slot.type_id);
    }

    const dependencies = try self.allocator.dupe(Record.Import, record.imports);
    var nodes = self.nodeCopier();

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
        .types = self.types.items.items,
        .nominal_types = self.types.nominal_origins.items.items,
        .exports = exported,
        .type_imports = type_imports,
        .function_imports = function_imports,
        .functions = self.functions.items,
        .native_modules = self.native_modules.items,
        .function = function,
        .stores = stores,
    };
}

fn copyFunction(self: *Self, record: Record) Error!?ir.Function {
    const value: ir.Function = switch (record.body) {
        .types => return null,
        .entry => blk: {
            if (self.program.type_only or !std.mem.eql(u8, record.path, self.program.file_name)) return error.InvalidModule;

            break :blk .{ .stores = self.program.stores, .store_mode = self.program.store_mode, .file_name = self.program.file_name, .input_type = self.program.input_type, .output_type = self.program.output_type, .consumes_input = self.program.consumes_input, .output_ownership = self.program.output_ownership, .symbols = self.program.symbols, .expressions = self.program.expressions, .body = self.program.body, .contracts = self.program.contracts };
        },
        .function => |id| blk: {
            if (@backingInt(id) >= self.program.functions.len) return error.InvalidModule;

            const value = self.program.functions[@backingInt(id)];

            if (value.external != null or !std.mem.eql(u8, record.path, value.file_name)) return error.InvalidModule;

            break :blk value;
        },
    };

    var nodes = self.nodeCopier();

    return try nodes.function(value);
}

fn importFunction(self: *Self, id: ir.FunctionId) Error!ir.FunctionId {
    const index = @backingInt(id);

    if (index >= self.program.functions.len) return error.InvalidModule;
    if (self.function_mapping[index]) |mapped| return mapped;

    const value = self.program.functions[index];

    if (value.external) |external| try self.nativeModule(external.module);

    var nodes = self.nodeCopier();
    const mapped: ir.FunctionId = @fromBackingInt(@intCast(self.functions.items.len));

    try self.functions.append(self.allocator, .{
        .file_name = try self.allocator.dupe(u8, value.file_name),
        .input_type = try self.types.include(value.input_type),
        .output_type = try self.types.include(value.output_type),
        .consumes_input = value.consumes_input,
        .output_ownership = value.output_ownership,
        .external = if (value.external) |external| try nodes.external(external) else null,
    });

    self.function_mapping[index] = mapped;

    return mapped;
}

fn nativeModule(self: *Self, id: ir.NativeModuleId) Error!void {
    const index = @backingInt(id);

    if (index >= self.program.native_modules.len) return error.InvalidModule;
    if (self.native_mapping[index] != null) return;

    const value = self.program.native_modules[index];
    var nodes = self.nodeCopier();
    const mapped: ir.NativeModuleId = @fromBackingInt(@intCast(self.native_modules.items.len));

    try self.native_modules.append(self.allocator, .{
        .specifier = try self.allocator.dupe(u8, value.specifier),
        .identity = if (value.identity) |key| try self.allocator.dupe(u8, key) else null,
        .import_name = try self.allocator.dupe(u8, value.import_name),
        .type_namespace = try nodes.strings(value.type_namespace),
        .types = try self.exports(value.types),
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
