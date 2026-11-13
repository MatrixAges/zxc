const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Artifact = @import("../../../artifact/model.zig");
const Origins = @import("../../../nominal_origins.zig");
const Current = @import("../../restore.zig").Current;
const generated = @import("generated_semantic_restore_types");
const marshal = @import("../../../../analysis/constants/input.zig").marshal;
const Input = std.meta.Child(generated.Input);
const Merge = std.meta.Child(@FieldType(Input, "merge"));
const Table = std.meta.Child(@FieldType(Merge, "source"));
const Nominal = std.meta.Child(@FieldType(Merge, "origins"));
const Constants = std.meta.Child(@typeInfo(@FieldType(Input, "current_constants")).optional.child);
const scalars = std.enums.values(ir.Scalar);

const scalar_ids = blk: {
    var ids: [scalars.len]u32 = undefined;

    for (scalars, &ids) |scalar, *id| id.* = @backingInt(scalar);

    break :blk ids;
};

const scalar_rows: ir.TypeTable = .{
    .kinds = &@as([scalars.len]u8, @splat(@backingInt(std.meta.Tag(ir.Type).scalar))),
    .first = &scalar_ids,
    .second = &@as([scalars.len]u32, @splat(0)),
    .labels = &@as([scalars.len][]const u8, @splat("")),
};

pub fn merge(temporary: std.mem.Allocator, module: *const Artifact.Module, current: *const Current, decoded: bool) Artifact.Error![]const ir.TypeId {
    const mapping = try temporary.alloc(u32, module.types.count());

    @memset(mapping, 0);

    var arena = zx.Arena.init(temporary);

    defer arena.deinit();

    const scratch = arena.allocator();
    const current_types = current.types.view();
    const source = ir.TypeTable.borrow(Table, module.types);
    const destination = ir.TypeTable.borrow(Table, current_types);
    const base = ir.TypeTable.borrow(Table, if (current_types.count() == 0) scalar_rows else current_types);
    const empty = ir.TypeTable.borrow(Table, .{});
    const origins = Origins.Table.borrow(Nominal, module.nominal_types);
    const base_origins = Origins.Table.borrow(Nominal, current.origins.items.view());

    const request: Merge = .{
        .source = &source,
        .origins = &origins,
        .names = module.nominal_types.names,
        .base = &base,
        .base_origins = &base_origins,
        .mapping = @ptrCast(&mapping),
    };

    const input: Input = .{
        .merge = &request,
        .current_types = &destination,
        .empty = &empty,
        .current_constants = try marshal(Constants, scratch, current.constant_imports),
        .cached_constants = try marshal(Constants, scratch, module.constant_imports),
        .cached_exports = if (decoded) null else try marshal(Constants, scratch, module.constant_exports),
        .type_ids = mapping,
        .scalar_count = scalars.len,
        .maximum_count = std.math.maxInt(u32),
        .decoded = decoded,
    };

    const result = zx.columns.invoke(generated.executeValue, scratch, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    const plan = result orelse return error.InvalidModule;

    if (current_types.count() == 0) try current.types.appendDelta(current.allocator, scalar_rows);
    try @import("../../../../analysis/semantic/merging/commit.zig").append(current.allocator, current.types, &current.origins.items, plan.delta.*, plan.origins);

    return @ptrCast(mapping);
}
