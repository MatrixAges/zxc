const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const generated = @import("generated_type_merge");
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
    checked: bool,
};

pub fn append(request: Request) Error!void {
    const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const DataView = @FieldType(Input, "request");
    const Data = if (@typeInfo(DataView) == .pointer) std.meta.Child(DataView) else DataView;
    const State = @FieldType(Input, "state");
    const Table = @FieldType(Data, "source");
    const Delta = @FieldType(State, "delta");
    const BindingsView = @FieldType(Data, "origins");
    const Bindings = if (@typeInfo(BindingsView) == .pointer) std.meta.Child(BindingsView) else BindingsView;
    const mapping: []u32 = @ptrCast(request.mapping);

    @memset(mapping, 0);

    const source = table(Table, request.source);
    const base = table(Table, request.items.view());
    const delta = table(Delta, .{});
    const origins = Origins.Table.borrow(Bindings, request.origins);
    const base_origins = Origins.Table.borrow(Bindings, request.nominal.view());

    const data: Data = .{
        .source = if (@typeInfo(Table) == .pointer) &source else source,
        .origins = if (@typeInfo(BindingsView) == .pointer) &origins else origins,
        .origin_indices = request.origin_indices,
        .base = if (@typeInfo(Table) == .pointer) &base else base,
        .base_origins = if (@typeInfo(BindingsView) == .pointer) &base_origins else base_origins,
        .mapping = @ptrCast(&mapping),
        .first = request.first,
        .checked = request.checked,
    };

    const input: Input = .{
        .request = if (@typeInfo(DataView) == .pointer) &data else data,
        .state = .{
            .delta = if (@typeInfo(Delta) == .pointer) &delta else delta,
            .origins = Origins.Table.borrow(@FieldType(State, "origins"), .{}),
            .references = &.{},
            .status = .Ready,
        },
    };

    const result = generated.executeValue(request.temporary, input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.IndexOutOfBounds => return error.InvalidModule,
        else => unreachable,
    };

    try @import("merging/commit.zig").append(request.allocator, request.items, request.nominal, result.delta, result.origins);

    return switch (result.status) {
        .Ready => {},
        .MissingOrigin => error.MissingNominalOrigin,
        .Conflict => error.ConflictingNominalType,
        .Invalid => error.InvalidModule,
    };
}

fn table(comptime View: type, source: ir.TypeTable) if (@typeInfo(View) == .pointer) std.meta.Child(View) else View {
    const Target = if (@typeInfo(View) == .pointer) std.meta.Child(View) else View;
    var result: Target = undefined;

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        @field(result, name) = @field(source, name);
    }

    if (@hasField(Target, "zx_origin")) result.zx_origin = null;

    return result;
}
