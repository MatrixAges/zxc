const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_artifact_remap");
const Nodes = @import("../nodes.zig");
const Error = @import("../model.zig").Error;
const Input = std.meta.Child(generated.Input);
const Mapping = std.meta.Child(@FieldType(Input, "type_mapping"));
const Output = @typeInfo(@TypeOf(generated.executeValue(undefined, undefined))).error_union.payload;

pub fn columns(nodes: *const Nodes, types: []const u32, functions: []const u32) Error!Output {
    if (types.len == 0 and functions.len == 0) return .{ .types = &.{}, .functions = &.{} };

    const type_mapping: Mapping = switch (nodes.types) {
        .collect => unreachable,
        .mapped => |ids| .{ .kind = .Dense, .dense = @ptrCast(ids), .sparse = &.{}, .planned = &.{}, .first = 0, .prefix = 0, .count = 0 },
        .planned => |ids| .{ .kind = .Planned, .dense = &.{}, .sparse = &.{}, .planned = ids, .first = 0, .prefix = 0, .count = 0 },
    };

    const function_mapping: Mapping = switch (nodes.functions) {
        .indexed => |ids| .{ .kind = .Sparse, .dense = &.{}, .sparse = @ptrCast(ids), .planned = &.{}, .first = 0, .prefix = 0, .count = 0 },
        .planned => |ids| .{ .kind = .Planned, .dense = &.{}, .sparse = &.{}, .planned = ids, .first = 0, .prefix = 0, .count = 0 },
        .range => |range| .{ .kind = .Range, .dense = &.{}, .sparse = &.{}, .planned = &.{}, .first = range.first, .prefix = range.prefix, .count = range.count },
    };

    const input: Input = .{
        .types = types,
        .type_mapping = &type_mapping,
        .functions = functions,
        .function_mapping = &function_mapping,
    };

    return zx.columns.invoke(generated.executeValue, nodes.allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };
}
