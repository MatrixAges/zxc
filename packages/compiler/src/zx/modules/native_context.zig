const std = @import("std");
const ir = @import("zx").ir;

pub fn valid(types: ir.TypeTable, modules: ir.NativeModuleTable) bool {
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

pub fn copy(allocator: std.mem.Allocator, modules: ir.NativeModuleTable) std.mem.Allocator.Error!ir.NativeModuleTable {
    var result = try storage(allocator, modules);

    return result.finish(allocator);
}

pub fn storage(allocator: std.mem.Allocator, modules: ir.NativeModuleTable) std.mem.Allocator.Error!ir.NativeModuleStorage {
    var result: ir.NativeModuleStorage = .{};

    errdefer result.deinit(allocator);

    for (0..modules.count()) |index| {
        var module = modules.at(index);

        module.specifier = try allocator.dupe(u8, module.specifier);
        module.identity = if (module.identity) |identity| try allocator.dupe(u8, identity) else null;
        module.import_name = try allocator.dupe(u8, module.import_name);
        const namespace = try allocator.alloc([]const u8, module.type_namespace.len);

        for (module.type_namespace, namespace) |name, *owned| owned.* = try allocator.dupe(u8, name);

        module.type_namespace = namespace;

        const names = try allocator.alloc([]const u8, module.types.count());
        const ids = try allocator.dupe(u32, module.types.type_ids);

        for (module.types.names, names) |name, *owned| owned.* = try allocator.dupe(u8, name);

        module.types = .{ .names = names, .type_ids = ids };

        try result.append(allocator, module);
    }

    return result;
}
