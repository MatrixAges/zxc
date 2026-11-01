const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../compiled.zig");
const Origins = @import("../nominal_origins.zig");

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
    if (comptime !@import("parser_options").generated_parser) return @import("seed_load.zig").load(allocator, .{
        .library = options.library,
        .types = options.types,
        .nominal_types = options.nominal_types,
        .functions = options.functions,
        .native_modules = options.native_modules,
    });

    return @import("host/root.zig").loadOptions(allocator, options);
}

pub fn loadInto(allocator: std.mem.Allocator, library: model.Library, destination: Destination) !model.Loaded {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_load.zig").loadInto(allocator, library, .{
        .types = destination.types,
        .origins = destination.origins,
        .functions = destination.functions,
        .native_modules = destination.native_modules,
    });

    return @import("host/root.zig").load(allocator, library, destination);
}
