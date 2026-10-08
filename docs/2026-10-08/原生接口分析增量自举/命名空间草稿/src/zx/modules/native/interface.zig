const std = @import("std");
const zx = @import("zx");
const Types = @import("../../analysis/types.zig");
const generated = @import("generated_native_interface");
const model = @import("../../analysis/semantic/resolving/host/model.zig");
const Source = @import("../../analysis/semantic/resolving/host/source.zig");
const Snapshot = @import("../../analysis/semantic/resolving/host/snapshot.zig");
const layout = @import("../../analysis/semantic/resolving/host/layout.zig");

pub const Signature = struct { input: zx.ir.TypeId, output: zx.ir.TypeId, native: zx.ir.NativeType };

pub fn analyze(types: *Types, view: anytype, namespace: []const []const u8) zx.Error![]const Signature {
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
        .namespace = layout.borrow(@FieldType(Input, "namespace"), namespace),
        .context = layout.borrow(@FieldType(Input, "context"), &context),
        .functions = layout.borrow(@FieldType(Input, "functions"), view.storage.functions),
        .parameters = layout.borrow(@FieldType(Input, "parameters"), view.storage.parameters),
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

    const signatures = try types.allocator.alloc(Signature, result.signatures.len);

    for (result.signatures, signatures) |value, *signature| {
        const names = try types.allocator.alloc(?[]const u8, value.names.len);

        for (value.names, names) |name, *owned| owned.* = if (name) |text| try types.allocator.dupe(u8, text) else null;

        signature.* = .{ .input = @fromBackingInt(value.input), .output = @fromBackingInt(value.output), .native = .{ .names = names } };
    }

    return signatures;
}
