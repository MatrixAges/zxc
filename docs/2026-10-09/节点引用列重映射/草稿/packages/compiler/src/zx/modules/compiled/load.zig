const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../compiled.zig");
const Types = @import("../link/types.zig");
const Nodes = @import("../artifact/nodes.zig");
const Origins = @import("../nominal_origins.zig");
const identity = @import("identity.zig");

pub const Options = struct {
    library: model.Library,
    types: ir.TypeTable,
    nominal_types: Origins.Table,
    functions: *ir.FunctionStorage,
    native_modules: *ir.NativeModuleStorage,
};

pub const Destination = struct {
    types: *ir.TypeStorage,
    origins: *Origins,
    functions: *ir.FunctionStorage,
    native_modules: *ir.NativeModuleStorage,
};

pub fn load(allocator: std.mem.Allocator, options: Options) !model.Loaded {
    var types = try @import("../../analysis/type_table.zig").storage(allocator, options.types);
    var origins = Origins{ .allocator = allocator };

    try origins.seed(types.view(), options.nominal_types);

    return loadInto(allocator, options.library, .{
        .types = &types,
        .origins = &origins,
        .functions = options.functions,
        .native_modules = options.native_modules,
    });
}

pub fn loadInto(allocator: std.mem.Allocator, library: model.Library, destination: Destination) !model.Loaded {
    const program = library.program;

    if (library.instance.len == 0 or library.artifact.len == 0 or std.mem.indexOfScalar(u8, library.instance, 0) != null or !std.unicode.utf8ValidateSlice(library.instance)) return error.InvalidLibrary;
    try model.validate(allocator, .{ .program = program, .exports = library.exports, .nominal_types = library.nominal_types, .store_initializers = library.store_initializers });

    var types = Types{ .allocator = allocator, .items = destination.types.*, .origins = destination.origins.* };
    destination.types.* = .{};
    destination.origins.items = .{};

    defer {
        destination.types.* = types.items;
        destination.origins.* = types.origins;
    }

    if (types.items.count() == 0) {
        for (std.enums.values(ir.Scalar)) |scalar| try types.items.append(allocator, .{ .scalar = scalar });
    }

    var origins: Origins.Storage = .{};

    for (0..library.nominal_types.count()) |index| {
        var item = library.nominal_types.at(index);

        item.origin = switch (item.origin) {
            .source => |path| .{ .source = try identity.scope(allocator, library.instance, path) },
            .native => |key| .{ .native = try identity.nativeKey(allocator, library, key) },
            .external => |value| .{ .external = .{ .module = try identity.nativeKey(allocator, library, value.module), .member = value.member } },
        };

        try origins.append(allocator, item);
    }

    const type_mapping = try types.appendFrom(allocator, program.types, origins.view(), 0);
    const function_mapping = try allocator.alloc(?ir.FunctionId, program.functions.count());
    const native_mapping = try allocator.alloc(?ir.NativeModuleId, program.native_modules.count());

    for (function_mapping, 0..) |*id, index| id.* = @fromBackingInt(@intCast(destination.functions.count() + index));

    @memset(native_mapping, null);

    var nodes = Nodes{ .allocator = allocator, .types = .{ .mapped = type_mapping }, .functions = .{ .indexed = function_mapping }, .native_modules = .{ .indexed = native_mapping } };

    for (0..program.native_modules.count(), native_mapping) |native_row, *id| {
        const native = program.native_modules.at(native_row);
        var rebound = native;

        if (!std.mem.startsWith(u8, native.specifier, "std:")) {
            rebound.identity = try identity.scope(allocator, library.instance, native.key());
            rebound.import_name = try identity.nativeName(allocator, library.instance, native.import_name);
        }

        id.* = try @import("../link/native.zig").append(allocator, destination.native_modules, rebound, &nodes);
    }

    for (0..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);
        var mapped = try nodes.function(function);
        mapped.file_name = try identity.scope(allocator, library.instance, function.file_name);
        const paths = try allocator.alloc([]const u8, mapped.stores.count());

        for (mapped.stores.paths, paths) |path, *owned| owned.* = try identity.store(allocator, library.instance, path);

        mapped.stores.paths = paths;

        try destination.functions.append(allocator, mapped);
    }

    const exports = try allocator.dupe(model.Export, library.exports);

    for (exports) |*exported| {
        exported.name = try allocator.dupe(u8, exported.name);
        exported.path = try identity.scope(allocator, library.instance, exported.path);
        exported.function = if (exported.function) |id| function_mapping[@backingInt(id)] else null;
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

    return .{ .types = types.items.view(), .nominal_types = types.origins.items.view(), .exports = exports, .store_initializers = initializers };
}
