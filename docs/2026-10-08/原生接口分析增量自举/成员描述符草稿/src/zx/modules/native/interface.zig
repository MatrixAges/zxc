const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const Members = @import("members.zig");
const Native = @import("../interface.zig").Native;
const generated = @import("generated_native_interface");
const model = @import("../../analysis/semantic/resolving/host/model.zig");
const Source = @import("../../analysis/semantic/resolving/host/source.zig");
const Snapshot = @import("../../analysis/semantic/resolving/host/snapshot.zig");
const layout = @import("../../analysis/semantic/resolving/host/layout.zig");

pub const Result = struct { exports: []const zx.ir.Export, members: []const Members.Member };

pub fn analyze(types: *Types, view: anytype, entry: Native, module: zx.ir.NativeModuleId) zx.Error!Result {
    var arena = std.heap.ArenaAllocator.init(types.allocator);

    defer arena.deinit();

    var source: Source = .{};

    try source.init(arena.allocator(), view.typeView(), null);

    const snapshot = try Snapshot.init(arena.allocator(), types);
    const base = zx.ir.TypeTable.borrow(model.Table, types.items.view());

    const context: model.Context = .{
        .source = &source.value,
        .base = &base,
        .resolved = &snapshot.resolved,
        .aliases = &snapshot.aliases,
        .visiting = snapshot.visiting,
        .native_interface = true,
    };

    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .namespace = layout.borrow(@FieldType(Input, "namespace"), entry.namespace),
        .context = layout.borrow(@FieldType(Input, "context"), &context),
        .functions = layout.borrow(@FieldType(Input, "functions"), view.storage.functions),
        .parameters = layout.borrow(@FieldType(Input, "parameters"), view.storage.parameters),
        .errors = layout.borrow(@FieldType(Input, "errors"), view.storage.errors),
    };

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (result.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(result.diagnostic.start), .end = @intCast(result.diagnostic.end) },
        try types.allocator.dupe(u8, result.diagnostic.message),
    );

    _ = try @import("../../analysis/semantic/resolving/host/commit.zig").apply(types, .{ .delta = result.delta, .cache = result.cache, .id = @as(u32, 0) });

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
