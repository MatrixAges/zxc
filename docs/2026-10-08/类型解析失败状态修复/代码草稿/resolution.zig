const std = @import("std");
const zx = @import("zx");
const Types = @import("../types.zig");
const generated = @import("generated_type_resolution");
const model = @import("resolving/host/model.zig");
const Source = @import("resolving/host/source.zig");
const Snapshot = @import("resolving/host/snapshot.zig");
const Origins = @import("../../modules/nominal_origins.zig");

pub fn Request(comptime View: type) type {
    return struct {
        initialize: bool = false,
        name: ?zx.ast.Name = null,
        node: ?View.Ref = null,
    };
}

pub fn execute(types: *Types, view: anytype, request: Request(@TypeOf(view))) zx.Error!zx.ir.TypeId {
    var arena = std.heap.ArenaAllocator.init(types.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    var source: Source = .{};

    try source.init(allocator, view, request.node);

    const snapshot = try Snapshot.init(allocator, types);
    const base = zx.ir.TypeTable.borrow(model.Table, types.items.view());

    const context: model.Context = .{
        .source = &source.value,
        .base = &base,
        .resolved = &snapshot.resolved,
        .aliases = &snapshot.aliases,
        .visiting = snapshot.visiting,
        .native_interface = types.native_interface,
    };

    const name = if (request.name) |value| @import("resolving/host/native.zig").named(value) else model.empty_name;
    const selected: model.Request = .{ .context = &context, .initialize = request.initialize, .named = request.name != null, .name = &name, .reference = &source.reference };
    const origins = Origins.Table.borrow(model.Bindings, if (types.shared) |shared| shared.origins.items.view() else .{});
    const origin: Origins.Origin = if (types.shared) |shared| shared.origin else .{ .source = "" };

    const identity: model.Origin = .{
        .kind = switch (origin) {
            .source => 0,
            .native => 1,
            .external => 2,
        },
        .owner = switch (origin) {
            .source, .native => |text| text,
            .external => |entry| entry.module,
        },
        .member = if (origin == .external) origin.external.member else "",
    };

    const input: model.Input = .{ .request = &selected, .shared = types.shared != null, .origins = &origins, .origin = &identity };

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const id: ?zx.ir.TypeId = if (result.publish) try @import("resolving/host/commit.zig").apply(types, result) else null;

    if (result.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(result.diagnostic.start), .end = @intCast(result.diagnostic.end) },
        try types.allocator.dupe(u8, result.diagnostic.message),
    );

    return id orelse unreachable;
}
