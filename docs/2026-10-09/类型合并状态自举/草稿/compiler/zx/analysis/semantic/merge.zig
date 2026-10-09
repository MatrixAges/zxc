const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const generated = @import("generated_type_merge");
const Storage = @import("merging/storage.zig");
const buffers = @import("buffers.zig");
pub const Error = std.mem.Allocator.Error || error{ InvalidModule, MissingNominalOrigin, ConflictingNominalType };

pub const Request = struct {
    allocator: std.mem.Allocator,
    temporary: std.mem.Allocator,
    source: ir.TypeTable,
    origins: Origins.Table,
    origin_indices: []const u64,
    mapping: []ir.TypeId,
    items: *ir.TypeStorage,
    nominal: *Origins.Storage,
    first: usize,
};

pub fn append(request: Request) Error!void {
    const Input = @typeInfo(@TypeOf(generated.executeBuffered)).@"fn".param_types[1].?;
    const Data = @FieldType(Input, "request");
    const State = @FieldType(Input, "state");
    const Table = @FieldType(Data, "source");
    const Bindings = @FieldType(Data, "origins");
    const mapping: []u32 = @ptrCast(request.mapping);
    var storage: Storage = .{ .mapping = .{ .list = .fromOwnedSlice(mapping), .started = true } };

    defer storage.deinit(request.temporary);
    @memset(mapping, 0);

    const input: Input = .{
        .request = .{
            .source = table(Table, request.source),
            .origins = Origins.Table.borrow(Bindings, request.origins),
            .origin_indices = request.origin_indices,
            .base = table(Table, request.items.view()),
            .base_origins = Origins.Table.borrow(Bindings, request.nominal.view()),
            .first = request.first,
        },
        .state = .{
            .mapping = mapping,
            .delta = table(@FieldType(State, "delta"), .{}),
            .origins = Origins.Table.borrow(@FieldType(State, "origins"), .{}),
            .references = &.{},
            .status = 0,
        },
    };

    const result = generated.executeBuffered(request.temporary, input, buffers.arguments(generated, &storage, "state")) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(result.mapping.ptr == mapping.ptr and result.mapping.len == mapping.len);

    try @import("merging/commit.zig").append(request.allocator, request.items, request.nominal, result.delta, result.origins);

    return switch (result.status) {
        0 => {},
        1 => error.MissingNominalOrigin,
        2 => error.ConflictingNominalType,
        3 => error.InvalidModule,
        else => unreachable,
    };
}

fn table(comptime Target: type, source: ir.TypeTable) Target {
    var result: Target = undefined;

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        @field(result, name) = @field(source, name);
    }

    if (@hasField(Target, "zx_origin")) result.zx_origin = null;

    return result;
}
