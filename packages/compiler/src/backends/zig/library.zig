const std = @import("std");
const model = @import("../../library/root.zig");
const validation = @import("../../library/validate.zig");
const modules = @import("modules.zig");
const names = @import("names.zig");
const references = @import("references.zig");
const Cache = @import("cache.zig");
pub const Error = modules.Error || validation.Error || error{InvalidModule};
pub const PublicModule = struct { name: []const u8, file: modules.File, value_entry: bool = false };

pub const Bundle = struct {
    arena: std.heap.ArenaAllocator,
    public_modules: []const PublicModule,
    types: []const u8,
    modules: []const modules.File,
    type_names: []const []const u8,
    native_modules: @import("zx").ir.NativeModuleTable,
    store_initializers: []const modules.StoreInitializer = &.{},
    pub fn deinit(self: *Bundle) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn createCached(allocator: std.mem.Allocator, library: *const model.Result, cache: ?*Cache) Error!Bundle {
    return create(allocator, library, cache, false);
}

pub fn createFilesCached(allocator: std.mem.Allocator, library: *const model.Result, cache: ?*Cache) Error!Bundle {
    return create(allocator, library, cache, true);
}

fn create(allocator: std.mem.Allocator, library: *const model.Result, cache: ?*Cache, file_imports: bool) Error!Bundle {
    if (@import("frontend").checks_internal_ir) try validation.validate(allocator, library);

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const program = try @import("genz").zx.prepare(owned, library.program);
    var identities = try names.create(owned, program, library.nominal_types);

    if (file_imports) {
        const functions = try owned.alloc([]const u8, identities.functions.len);

        for (identities.functions, functions) |name, *path| path.* = try std.fmt.allocPrint(owned, "{s}.zig", .{name});

        identities.functions = functions;
    }

    const needed = try owned.alloc(bool, program.functions.count());
    const public_modules = try owned.alloc(PublicModule, library.exports.len);
    const exported_functions = try owned.alloc(@import("zx").ir.FunctionId, library.exports.len);
    var exported_count: usize = 0;

    for (library.exports) |exported| if (exported.function) |id| {
        exported_functions[exported_count] = id;
        exported_count += 1;
    };

    var memo = try @import("uniqueness_memo.zig").load(allocator, cache);

    defer if (memo) |*value| value.deinit();

    var batch = try modules.Batch.createRemembered(allocator, program, identities, cache, exported_functions[0..exported_count], if (memo) |*value| value else null);

    defer batch.deinit();

    if (memo) |*value| try @import("uniqueness_memo.zig").save(allocator, cache, value);

    var prepared_library = library.*;

    prepared_library.program = program;

    @memset(needed, false);

    for (library.exports, public_modules, 0..) |exported, *public_module, index| {
        const view = if (file_imports)
            try @import("library_entry.zig").create(owned, &prepared_library, index)
        else
            try prepared_library.module(index);

        const reachable = try references.reachable(owned, view);

        for (needed, reachable) |*required, used| required.* = required.* or used;

        owned.free(reachable);

        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(exported.name, &digest, .{});

        var public_batch = batch;
        public_batch.program = view;

        try public_batch.analysis.value.reentry(owned, allocator, view);

        public_module.* = .{
            .name = try owned.dupe(u8, exported.name),
            .value_entry = public_batch.analysis.value.hasValueEntry(view),
            .file = .{
                .name = try std.fmt.allocPrint(owned, "public_{s}", .{std.fmt.bytesToHex(digest, .lower)}),
                .source = try public_batch.emit(owned, .entry),
                .imports = try references.imports(owned, view.expressions, view.contracts, identities.functions),
            },
        };
    }

    const type_source = try batch.emit(owned, .types);
    const functions = try modules.functionFilesAnalyzed(owned, &batch, needed);
    const initializers = try @import("library_initializers.zig").createBacked(owned, allocator, library, identities, cache);
    const files = try std.mem.concat(owned, modules.File, &.{ functions, initializers.files });
    const type_names = try modules.typeNamesAnalyzed(owned, program, identities, batch.analysis.value.value.state);
    const native_modules = try modules.nativeModules(owned, program);

    return .{
        .arena = arena,
        .public_modules = public_modules,
        .types = type_source,
        .modules = files,
        .type_names = type_names,
        .native_modules = native_modules,
        .store_initializers = initializers.entries,
    };
}
