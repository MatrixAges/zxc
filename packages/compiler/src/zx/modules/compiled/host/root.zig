const std = @import("std");
const model = @import("../../compiled.zig");
const load_model = @import("../load.zig");
const Destination = load_model.Destination;
const generated = @import("generated_compiled_library");
const Input = @import("input.zig");

pub fn validate(allocator: std.mem.Allocator, graph: model.Graph) (std.mem.Allocator.Error || error{InvalidLibrary})!void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var input: Input = undefined;

    try input.init(arena.allocator(), &graph, "", "", null, false);

    const result = generated.execute(&arena, &input.input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return error.InvalidLibrary,
    };

    if (result.status != 0) return error.InvalidLibrary;
}

pub fn loadOptions(allocator: std.mem.Allocator, options: load_model.Options) !model.Loaded {
    var types = try @import("../../../analysis/type_table.zig").storage(allocator, options.types);
    var origins = try @import("origins.zig").copy(allocator, options.nominal_types);

    return loadPrepared(allocator, options.library, .{
        .types = &types,
        .origins = &origins,
        .functions = options.functions,
        .native_modules = options.native_modules,
    }, true);
}

pub fn load(allocator: std.mem.Allocator, library: model.Library, destination: Destination) !model.Loaded {
    return loadPrepared(allocator, library, destination, false);
}

fn loadPrepared(allocator: std.mem.Allocator, library: model.Library, destination: Destination, seed: bool) !model.Loaded {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const graph = model.Graph{ .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types, .store_initializers = library.store_initializers };
    var input: Input = undefined;

    try input.init(arena.allocator(), &graph, library.instance, library.artifact, destination, seed);

    const result = generated.execute(&arena, &input.input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    switch (result.status) {
        0 => {},
        1 => return error.InvalidLibrary,
        2 => return error.InvalidModule,
        3 => return error.MissingNominalOrigin,
        4 => return error.ConflictingNominalType,
        5 => return error.ConflictingInterface,
        6 => return error.OutOfMemory,
        7 => return error.InvalidNominalTypes,
        else => unreachable,
    }

    return @import("publish.zig").apply(allocator, result, destination);
}
