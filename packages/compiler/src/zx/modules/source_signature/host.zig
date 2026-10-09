const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const Origins = @import("../nominal_origins.zig");
const Signature = @import("../source_signature.zig");
const generated = @import("generated_source_signature");
const borrow = @import("../../ir/canonical/borrow.zig");
const Input = std.meta.Child(generated.Input);

pub fn analyze(types: *Types, source: []const u8, syntax: anytype) zx.Error!Signature.Result {
    var arena = std.heap.ArenaAllocator.init(types.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    const type_base = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "type_base")), types.items.view());
    const nominal_base = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "nominal_base")), if (types.shared) |shared| shared.origins.items.view() else .{});
    const origin: Origins.Origin = if (types.shared) |shared| shared.origin else .{ .source = "" };

    const nominal_origin: std.meta.Child(@FieldType(Input, "nominal_origin")) = .{
        .kind = switch (origin) {
            .source => 0,
            .native => 1,
            .external => 2,
        },
        .owner = switch (origin) {
            .source, .native => |name| name,
            .external => |value| value.module,
        },
        .member = if (origin == .external) origin.external.member else "",
    };

    const names = try allocator.alloc([]const u8, types.aliases.len);
    const ids = try allocator.alloc(u32, types.aliases.len);

    for (types.aliases, names, ids) |alias, *name, *id| {
        name.* = alias.name;
        id.* = @backingInt(alias.type_id);
    }

    const aliases: std.meta.Child(@FieldType(Input, "aliases")) = .{ .names = names, .ids = ids };

    const input = Input{
        .bytes = source,
        .syntax = borrow.pointer(@FieldType(Input, "syntax"), syntax),
        .type_base = &type_base,
        .aliases = &aliases,
        .nominal_base = &nominal_base,
        .nominal_origin = &nominal_origin,
        .shared = types.shared != null,
    };

    const output = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return types.reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(types.allocator, "internal compiler error: generated signature analysis failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try types.allocator.dupe(u8, output.diagnostic.message),
    );

    var unshared: Origins.Storage = .{};
    const origins = if (types.shared) |shared| &shared.origins.items else &unshared;

    try @import("../../analysis/semantic/merging/commit.zig").append(types.allocator, &types.items, origins, output.type_delta.*, output.nominal_delta.*);

    const exports = try types.allocator.alloc(zx.ir.Export, output.export_names.len);

    for (output.export_names, output.export_types, exports) |name, type_id, *exported| {
        exported.* = .{ .name = try types.allocator.dupe(u8, name), .type_id = @fromBackingInt(type_id) };
    }

    return .{
        .ports = .{ .input_type = @fromBackingInt(output.input_type), .output_type = @fromBackingInt(output.output_type) },
        .exports = exports,
        .type_only = output.type_only,
        .has_store = output.has_store,
    };
}
