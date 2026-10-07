const std = @import("std");
const model = @import("../../library/root.zig");
const validation = @import("../../library/validate.zig");
const modules = @import("modules.zig");
const names = @import("names.zig");
const references = @import("references.zig");
const Cache = @import("cache.zig");
pub const Error = modules.Error || validation.Error || error{InvalidModule};
pub const PublicModule = struct { name: []const u8, file: modules.File };

pub const Bundle = struct {
    arena: std.heap.ArenaAllocator,
    public_modules: []const PublicModule,
    types: []const u8,
    modules: []const modules.File,
    type_names: []const []const u8,
    native_modules: []const @import("zx").ir.NativeModule,
    store_initializers: []const modules.StoreInitializer = &.{},
    pub fn deinit(self: *Bundle) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn createCached(allocator: std.mem.Allocator, library: *const model.Result, cache: ?*Cache) Error!Bundle {
    try validation.validate(allocator, library);

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const program = try @import("genz").zx.prepare(owned, library.program);
    const identities = try names.create(owned, program, library.nominal_types);
    const needed = try owned.alloc(bool, program.functions.count());
    const public_modules = try owned.alloc(PublicModule, library.exports.len);

    @memset(needed, false);

    for (library.exports, public_modules, 0..) |exported, *public_module, index| {
        const view = try @import("genz").zx.prepare(owned, try library.module(index));
        const reachable = try references.reachable(owned, view);

        for (needed, reachable) |*required, used| required.* = required.* or used;

        owned.free(reachable);

        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(exported.name, &digest, .{});

        public_module.* = .{
            .name = try owned.dupe(u8, exported.name),
            .file = .{
                .name = try std.fmt.allocPrint(owned, "public_{s}", .{std.fmt.bytesToHex(digest, .lower)}),
                .source = try modules.emitPrepared(owned, view, identities, .entry, cache),
                .imports = try references.imports(owned, view.expressions, view.contracts, identities.functions),
            },
        };
    }

    const type_source = try modules.emitPrepared(owned, program, identities, .types, cache);
    const functions = try modules.functionFilesPrepared(owned, program, identities, needed, cache);
    const initializers = try @import("library_initializers.zig").create(owned, library, identities, cache);
    const files = try std.mem.concat(owned, modules.File, &.{ functions, initializers.files });
    const type_names = try modules.typeNames(owned, program, identities);
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
