const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Native = @import("../interface.zig").Native;
const Artifact = @import("../artifact/model.zig");
const Origins = @import("../nominal_origins.zig");
const FunctionImport = @import("../function_import.zig");

pub fn create(allocator: std.mem.Allocator, entry: Native, fingerprint: [32]u8, error_allocator: std.mem.Allocator, reporter: *zx.Reporter, span: zx.Span) zx.Error!Artifact.Result {
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
    var functions: ir.FunctionStorage = .{};
    const bindings = try owned.alloc(FunctionImport, loaded.members.len);

    for (loaded.members, bindings, 0..) |member, *binding, index| {
        const function = member.function;

        try functions.append(owned, function);

        binding.* = .{ .name = member.name, .id = @fromBackingInt(@intCast(index)), .input_type = function.input_type, .output_type = function.output_type };
    }

    const program = ir.Program{ .file_name = entry.path, .types = loaded.types, .input_type = @fromBackingInt(@intCast(0)), .output_type = @fromBackingInt(@intCast(0)), .symbols = .{}, .expressions = .{}, .body = .{}, .exports = loaded.exports, .native_modules = native_modules, .functions = functions.view(), .type_only = true };

    if (try @import("../../ir/validate.zig").validate(owned, program) != null) return reporter.fail(.module, span, "native declarations produced invalid interface IR");

    var origins = Origins{ .allocator = owned };

    try origins.append(loaded.types, 0, .{ .native = entry.key() });

    const path = try owned.dupe(u8, entry.key());

    return .{ .arena = arena, .value = .{
        .path = path,
        .source_digest = fingerprint,
        .types = loaded.types,
        .nominal_types = origins.items.view(),
        .exports = loaded.exports,
        .function_imports = bindings,
        .functions = ir.SignatureTable.fromFunctions(functions.view()),
        .native_modules = native_modules,
        .dependencies = &.{},
        .type_imports = &.{},
        .function = null,
        .stores = .{},
    } };
}
