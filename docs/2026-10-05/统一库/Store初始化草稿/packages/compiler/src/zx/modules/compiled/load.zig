const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../compiled.zig");
const Types = @import("../link/types.zig");
const Nodes = @import("../artifact/nodes.zig");
const Origins = @import("../nominal_origins.zig");
const identity = @import("identity.zig");

pub const Options = struct {
    library: model.Library,
    types: []const ir.Type,
    nominal_types: []const Origins.Item,
    functions: *std.ArrayList(ir.Function),
    native_modules: *std.ArrayList(ir.NativeModule),
};

pub fn load(allocator: std.mem.Allocator, options: Options) !model.Loaded {
    const library = options.library;
    const program = library.program;

    if (library.instance.len == 0 or library.artifact.len == 0 or std.mem.indexOfScalar(u8, library.instance, 0) != null or !std.unicode.utf8ValidateSlice(library.instance)) return error.InvalidLibrary;
    try model.validate(allocator, .{ .program = program, .exports = library.exports, .nominal_types = library.nominal_types, .store_initializers = library.store_initializers });

    var types = if (options.types.len == 0) try Types.init(allocator) else Types{ .allocator = allocator, .origins = .{ .allocator = allocator } };

    if (options.types.len != 0) {
        try types.items.appendSlice(allocator, options.types);
        try types.origins.seed(options.types, options.nominal_types);
    }

    const origins = try allocator.dupe(Origins.Item, library.nominal_types);

    for (origins) |*item| item.origin = switch (item.origin) {
        .source => |path| .{ .source = try identity.scope(allocator, library.instance, path) },
        .native => |key| .{ .native = try identity.nativeKey(allocator, library, key) },
        .external => |value| .{ .external = .{ .module = try identity.nativeKey(allocator, library, value.module), .member = value.member } },
    };

    const type_mapping = try types.appendFrom(allocator, program.types, origins, 0);
    const function_mapping = try allocator.alloc(?ir.FunctionId, program.functions.len);
    const native_mapping = try allocator.alloc(?ir.NativeModuleId, program.native_modules.len);

    for (function_mapping, 0..) |*id, index| id.* = @enumFromInt(options.functions.items.len + index);

    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = type_mapping }, .functions = function_mapping, .native_modules = native_mapping };

    for (program.native_modules, native_mapping) |native, *id| {
        var rebound = native;

        if (!std.mem.startsWith(u8, native.specifier, "std:")) {
            rebound.identity = try identity.scope(allocator, library.instance, native.key());
            rebound.import_name = try identity.nativeName(allocator, library.instance, native.import_name);
        }

        id.* = try @import("../link/native.zig").append(allocator, options.native_modules, rebound, &nodes);
    }

    for (program.functions) |function| {
        var mapped = try nodes.function(function);
        mapped.file_name = try identity.scope(allocator, library.instance, function.file_name);
        const stores = try allocator.dupe(ir.StoreSlot, mapped.stores);

        for (stores) |*slot| slot.path = try identity.store(allocator, library.instance, slot.path);

        mapped.stores = stores;

        try options.functions.append(allocator, mapped);
    }

    const exports = try allocator.dupe(model.Export, library.exports);

    for (exports) |*exported| {
        exported.name = try allocator.dupe(u8, exported.name);
        exported.path = try identity.scope(allocator, library.instance, exported.path);
        exported.function = if (exported.function) |id| function_mapping[@intFromEnum(id)] else null;
        const public_types = try allocator.dupe(ir.Export, exported.types);

        for (public_types) |*item| {
            item.name = try allocator.dupe(u8, item.name);
            item.type_id = try nodes.types.include(item.type_id);
        }

        exported.types = public_types;
    }

    const initializers = try allocator.dupe(model.StoreInitializer, library.store_initializers);

    for (initializers) |*initial| {
        initial.identity = try identity.store(allocator, library.instance, initial.identity);
        initial.function = try nodes.functionId(initial.function);
    }

    return .{ .types = types.items.items, .nominal_types = types.origins.items.items, .exports = exports, .store_initializers = initializers };
}
