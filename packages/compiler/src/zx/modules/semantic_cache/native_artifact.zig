const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("../interface.zig").Native;
const Artifact = @import("../artifact/model.zig");
const Origins = @import("../nominal_origins.zig");
const FunctionImport = @import("../function_import.zig");
const generated = @import("parser_options").generated_parser;

pub fn create(allocator: std.mem.Allocator, entry: Native, fingerprint: [32]u8, error_allocator: std.mem.Allocator, reporter: *zx.Reporter, span: zx.Span) zx.Error!Artifact.Result {
    if (comptime generated) return @import("native_artifact/host.zig").create(allocator, entry, fingerprint, error_allocator, reporter, span);

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var local: zx.Reporter = .{};
    var types: ir.TypeStorage = .{};

    const loaded = @import("../native.zig").load(&arena, entry, @fromBackingInt(@intCast(0)), &types, null, &local, span) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        var issue = local.diagnostic.?;
        issue.message = try error_allocator.dupe(u8, issue.message);
        reporter.diagnostic = issue;

        return err;
    };

    const namespace = try owned.alloc([]const u8, entry.namespace.len);

    for (entry.namespace, namespace) |part, *name| name.* = try owned.dupe(u8, part);

    const native_modules = try ir.NativeModuleTable.fromValues(owned, &.{.{ .specifier = try owned.dupe(u8, entry.specifier), .identity = if (entry.identity) |key| try owned.dupe(u8, key) else null, .import_name = try owned.dupe(u8, entry.module), .type_namespace = namespace, .types = try ir.NativeBindings.fromValues(owned, loaded.exports) }});
    var seed_functions: ir.FunctionStorage = .{};
    const bindings = try owned.alloc(FunctionImport, loaded.members.len);

    for (loaded.members, bindings, 0..) |member, *binding, index| {
        const function = member.function;

        try seed_functions.append(owned, function);

        binding.* = .{ .name = member.name, .id = @fromBackingInt(@intCast(index)), .input_type = function.input_type, .output_type = function.output_type };
    }

    const functions = seed: {
        const unit: ir.TypeId = @fromBackingInt(@backingInt(ir.Scalar.void));

        const program = ir.Program{
            .file_name = entry.path,
            .types = loaded.types,
            .input_type = unit,
            .output_type = unit,
            .symbols = .{},
            .expressions = .{},
            .body = .{},
            .exports = loaded.exports,
            .native_modules = native_modules,
            .functions = seed_functions.view(),
            .type_only = true,
        };

        if (try @import("../../ir/validate.zig").validate(owned, program) != null) return reporter.fail(.module, span, "native declarations produced invalid interface IR");

        break :seed ir.SignatureTable.fromFunctions(program.functions);
    };

    var origins = Origins{ .allocator = owned };

    try origins.append(loaded.types, 0, .{ .native = entry.key() });

    const path = try owned.dupe(u8, entry.key());

    return .{ .arena = arena, .value = .{
        .path = path,
        .source_digest = fingerprint,
        .types = loaded.types,
        .nominal_types = origins.items.view(),
        .exports = loaded.exports,
        .constant_exports = &.{},
        .constant_imports = &.{},
        .function_imports = bindings,
        .functions = functions,
        .native_modules = native_modules,
        .dependencies = &.{},
        .type_imports = &.{},
        .function = null,
        .stores = .{},
    } };
}
