const std = @import("std");
const model = @import("../../library/root.zig");
const modules = @import("modules.zig");
const Names = @import("genz").zx.modules.Names;
const Cache = @import("cache.zig");

pub const Result = struct { files: []const modules.File, entries: []const modules.StoreInitializer };

pub fn create(allocator: std.mem.Allocator, library: *const model.Result, names: Names, cache: ?*Cache) modules.Error!Result {
    const files = try allocator.alloc(modules.File, library.store_initializers.len);
    const entries = try allocator.alloc(modules.StoreInitializer, library.store_initializers.len);

    for (library.store_initializers, files, entries) |initial, *file, *entry| {
        const function = library.program.functions.at(@backingInt(initial.function));
        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(initial.identity, &digest, .{});

        const module_name = try std.fmt.allocPrint(allocator, "zxc_store_initial_{s}", .{std.fmt.bytesToHex(digest, .lower)});
        var program = library.program;
        program.file_name = module_name;
        program.type_only = false;
        program.input_type = function.input_type;
        program.output_type = function.output_type;
        program.output_ownership = function.output_ownership;
        program.symbols = function.symbols;
        program.expressions = function.expressions;
        program.body = function.body;
        program.contracts = function.contracts;
        program.stores = .{};
        program.exports = &.{};
        file.* = .{ .name = module_name, .source = try modules.emit(allocator, program, names, .entry, cache), .imports = &.{} };

        entry.* = .{
            .identity = try allocator.dupe(u8, initial.identity),
            .schema_version = initial.schema_version,
            .module_name = module_name,
            .type_name = names.types[@backingInt(function.output_type)],
        };
    }

    return .{ .files = files, .entries = entries };
}
