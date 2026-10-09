const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");

pub const Shared = struct { plain: bool = true, mode: bool = true, node: bool = true, errors: bool = true, pair: bool = true, saved: bool = true, list: bool = true, record: bool = true, task: bool = true };
pub const base_count = std.enums.values(f.ir.Scalar).len + @typeInfo(f.Ids).@"struct".field_names.len;

pub fn two(left_options: f.Options, right_options: f.Options, shared: Shared, count: usize, nominal_count: usize) !void {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const allocator = memory.allocator();
    const left = try f.source(allocator, left_options);
    const right = try f.source(allocator, right_options);
    const left_types = try f.copyColumns(allocator, left.module.types);
    const left_origins = try f.copyColumns(allocator, left.module.nominal_types);
    const right_types = try f.copyColumns(allocator, right.module.types);
    const right_origins = try f.copyColumns(allocator, right.module.nominal_types);
    var result = try f.link.merge(std.testing.allocator, &.{ left.module, right.module });

    defer result.deinit();

    try std.testing.expectEqual(count, result.types.count());
    try std.testing.expectEqual(nominal_count, result.nominal_types.count());
    try std.testing.expectEqual(@as(usize, 2), result.mappings.len);

    const a = try check.module(result, left, 0);
    const b = try check.module(result, right, 1);

    inline for (@typeInfo(f.Ids).@"struct".field_names) |name| try std.testing.expectEqual(@field(shared, name), @field(a, name) == @field(b, name));

    try f.sameColumns(left_types, left.module.types);
    try f.sameColumns(left_origins, left.module.nominal_types);
    try f.sameColumns(right_types, right.module.types);
    try f.sameColumns(right_origins, right.module.nominal_types);
}

pub fn conflict(left_options: f.Options, right_options: f.Options) !void {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const allocator = memory.allocator();
    const left = try f.source(allocator, left_options);
    const right = try f.source(allocator, right_options);
    const left_types = try f.copyColumns(allocator, left.module.types);
    const left_origins = try f.copyColumns(allocator, left.module.nominal_types);
    const right_types = try f.copyColumns(allocator, right.module.types);
    const right_origins = try f.copyColumns(allocator, right.module.nominal_types);

    try std.testing.expectError(error.ConflictingNominalType, f.link.merge(std.testing.allocator, &.{ left.module, right.module }));
    try f.sameColumns(left_types, left.module.types);
    try f.sameColumns(left_origins, left.module.nominal_types);
    try f.sameColumns(right_types, right.module.types);
    try f.sameColumns(right_origins, right.module.nominal_types);
}
