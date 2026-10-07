const std = @import("std");
const ir = @import("zx").ir;

pub fn valid(types: ir.TypeTable, modules: []const ir.NativeModule) bool {
    return @import("../ir/native_modules.zig").validate(.{
        .file_name = "shared",
        .types = types,
        .native_modules = modules,
        .input_type = @fromBackingInt(0),
        .output_type = @fromBackingInt(0),
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .type_only = true,
    });
}

pub fn copy(allocator: std.mem.Allocator, modules: []const ir.NativeModule) std.mem.Allocator.Error![]ir.NativeModule {
    const result = try allocator.dupe(ir.NativeModule, modules);

    for (result) |*module| {
        module.specifier = try allocator.dupe(u8, module.specifier);
        module.identity = if (module.identity) |identity| try allocator.dupe(u8, identity) else null;
        module.import_name = try allocator.dupe(u8, module.import_name);
        const namespace = try allocator.alloc([]const u8, module.type_namespace.len);

        for (module.type_namespace, namespace) |name, *owned| owned.* = try allocator.dupe(u8, name);

        module.type_namespace = namespace;

        const bindings = try allocator.dupe(ir.Export, module.types);

        for (bindings) |*binding| binding.name = try allocator.dupe(u8, binding.name);

        module.types = bindings;
    }

    return result;
}
