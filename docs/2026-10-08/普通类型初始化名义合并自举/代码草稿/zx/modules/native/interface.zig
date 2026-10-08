const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const Members = @import("members.zig");
const Native = @import("../interface.zig").Native;
const generated = @import("generated_native_interface");

pub const Result = struct { exports: []const zx.ir.Export, members: []const Members.Member };

pub fn analyze(types: *Types, entry: Native, module: zx.ir.NativeModuleId) zx.Error!Result {
    var arena = std.heap.ArenaAllocator.init(types.allocator);

    defer arena.deinit();

    const Input = std.meta.Child(generated.Input);
    const Table = std.meta.Child(@FieldType(Input, "base"));
    const base = zx.ir.TypeTable.borrow(Table, types.items.view());
    const OriginTable = @import("../nominal_origins.zig").Table;
    const Bindings = std.meta.Child(@FieldType(Input, "origins"));
    const Origin = std.meta.Child(@FieldType(Input, "origin"));
    const origins = OriginTable.borrow(Bindings, if (types.shared) |shared| shared.origins.items.view() else .{});
    const origin: Origin = .{ .kind = 1, .owner = entry.key(), .member = "" };

    const input: Input = .{
        .shared = types.shared != null,
        .origins = &origins,
        .origin = &origin,
        .namespace = entry.namespace,
        .base = &base,
        .source = entry.source,
    };

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return types.reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(types.allocator, "internal compiler error: generated native analysis failed with {s}", .{@errorName(err)})),
    };

    if (result.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(result.diagnostic.start), .end = @intCast(result.diagnostic.end) },
        try types.allocator.dupe(u8, result.diagnostic.message),
    );

    _ = try @import("../../analysis/semantic/resolving/host/commit.zig").apply(types, .{ .delta = result.delta, .cache = result.cache, .origins = result.origins, .id = @as(u32, 0) });

    const exports = try types.allocator.alloc(zx.ir.Export, result.exports.len);

    for (result.exports, exports) |value, *item| {
        item.* = .{ .name = try types.allocator.dupe(u8, value.name), .type_id = @fromBackingInt(value.type_id) };
    }

    const members = try types.allocator.alloc(Members.Member, result.members.len);

    if (members.len != 0) {
        const owner = try Members.init(types.allocator, entry, module);

        for (result.members, members) |value, *member| {
            const names = try types.allocator.alloc(?[]const u8, value.signature.names.len);

            for (value.signature.names, names) |name, *owned| owned.* = if (name) |text| try types.allocator.dupe(u8, text) else null;

            member.* = try owner.create(value, .{ .names = names });
        }
    }

    return .{ .exports = exports, .members = members };
}
