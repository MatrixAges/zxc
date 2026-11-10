const std = @import("std");
const frontend = @import("frontend");
const modules = @import("modules.zig");
const names = @import("names.zig");
pub const Initializer = @import("store_initializers_seed.zig").Initializer;
pub const Options = struct { analysis: *const frontend.AnalysisResult, initializers: []const Initializer, cache: ?*@import("cache.zig") = null };
pub const Error = modules.Error || error{ InvalidInitializer, DuplicateInitializer, MissingInitializer };

pub fn append(bundle: *modules.Bundle, options: Options) Error!void {
    if (comptime !@import("parser_options").generated_parser) return @import("store_initializers_seed.zig").append(bundle, .{ .analysis = options.analysis, .initializers = options.initializers, .cache = options.cache });
    if (options.analysis.value != .ir or bundle.store_initializers.len != 0) return error.InvalidInitializer;

    const allocator = bundle.arena.allocator();
    const application = options.analysis.value.ir;
    const shared = try names.create(allocator, bundle.arena.child_allocator, application, options.analysis.nominal_types);
    var files: std.ArrayList(modules.File) = .empty;
    var metadata: std.ArrayList(modules.StoreInitializer) = .empty;

    try files.appendSlice(allocator, bundle.modules);

    var initializers: std.ArrayList(Initializer) = .empty;

    try initializers.appendSlice(allocator, options.initializers);

    var scratch = std.heap.ArenaAllocator.init(bundle.arena.child_allocator);

    defer scratch.deinit();

    var identities = try @import("store_initializers/registry.zig").create(scratch.allocator());
    const entry = @import("generated_store_initializer_selection");
    const zx = @import("zx");
    const Input = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;

    const input: Input = .{
        .initializers = zx.columns.storage.view(@FieldType(Input, "initializers"), options.analysis.store_initializers),
        .paths = application.stores.paths,
        .function_count = application.functions.count(),
        .native_modules = application.functions.native_modules,
        .zx_origin = null,
    };

    const selection = entry.executeValue(scratch.allocator(), input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!selection.valid) return error.InvalidInitializer;

    for (selection.indices) |index| {
        const initial = options.analysis.store_initializers[index];
        const function = application.functions.at(@backingInt(initial.function));

        try initializers.append(allocator, .{
            .identity = initial.identity,
            .schema_version = initial.schema_version,
            .program = .{
                .file_name = function.file_name,
                .types = application.types,
                .input_type = function.input_type,
                .output_type = function.output_type,
                .output_ownership = function.output_ownership,
                .symbols = function.symbols,
                .expressions = function.expressions,
                .body = function.body,
                .contracts = function.contracts,
                .stores = function.stores,
                .store_mode = function.store_mode,
            },
        });
    }

    for (initializers.items) |initial| {
        var program = initial.program;
        const validation = @import("store_initializers/validation.zig");

        if (!try validation.validate(bundle.arena.child_allocator, program)) return error.InvalidInitializer;

        const own = try names.create(allocator, bundle.arena.child_allocator, program, options.analysis.nominal_types);

        if (!validation.compatible(own.types, shared.types)) return error.InvalidInitializer;

        const identity = try allocator.dupe(u8, initial.identity);

        try identities.register(identity, program.output_type);

        var digest: [32]u8 = undefined;

        @import("zx").Sha256.hash(identity, &digest, .{});
        const module_name = try std.fmt.allocPrint(allocator, "zxc_store_initial_{s}", .{std.fmt.bytesToHex(digest, .lower)});
        program.file_name = module_name;
        const source = try modules.emit(allocator, program, .{ .types = shared.types, .functions = &.{} }, .entry, options.cache);

        try files.append(allocator, .{ .name = module_name, .source = source, .imports = &.{} });
        try metadata.append(allocator, .{ .identity = identity, .schema_version = initial.schema_version, .module_name = module_name, .type_name = shared.types[@backingInt(program.output_type)] });
    }

    try identities.validate(&application.stores);

    const expanded = try files.toOwnedSlice(allocator);
    const stores = try metadata.toOwnedSlice(allocator);

    bundle.modules = expanded;
    bundle.store_initializers = stores;
}
