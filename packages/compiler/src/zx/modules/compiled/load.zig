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
    selected: ?[]const model.PublicReference = null,
};

pub const Destination = struct {
    types: *ir.TypeStorage,
    origins: *Origins,
    functions: *ir.FunctionStorage,
    native_modules: *ir.NativeModuleStorage,
};

pub const CallScratch = struct {
    functions: std.mem.Allocator,
    temporary: std.mem.Allocator,
};

pub fn load(allocator: std.mem.Allocator, options: Options) !model.Loaded {
    if (comptime !@import("parser_options").generated_parser) {
        var result = try @import("seed_load.zig").load(allocator, .{
            .library = options.library,
            .types = options.types,
            .nominal_types = options.nominal_types,
            .functions = options.functions,
            .native_modules = options.native_modules,
        });

        if (options.selected) |selected| result.exports = try selectSeed(allocator, result.exports, selected);

        return result;
    }

    return @import("host/root.zig").loadOptions(allocator, options, null);
}

/// Links the function graph for RX signature checking. Generated loads publish only
/// the shared types and native modules, with remapped functions in the call workspace.
pub fn loadCalls(allocator: std.mem.Allocator, scratch: CallScratch, options: Options) !model.Loaded {
    std.debug.assert(options.selected == null);

    if (comptime !@import("parser_options").generated_parser) return load(allocator, options);

    return @import("host/root.zig").loadOptions(allocator, options, scratch);
}

fn selectSeed(allocator: std.mem.Allocator, exports: []const model.Export, selected: []const model.PublicReference) ![]const model.Export {
    const result = try allocator.alloc(model.Export, selected.len);

    for (selected, result) |selection, *exported| {
        exported.* = for (exports) |candidate| {
            if (std.mem.eql(u8, candidate.name, selection.module)) break candidate;
        } else return error.MissingPublicModule;

        exported.name = try allocator.dupe(u8, selection.name);
    }

    return result;
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
