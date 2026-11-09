const std = @import("std");
const node = @import("../node.zig");
const Tag = std.meta.Tag(node.Declaration);
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

/// Imports constant declaration columns directly into an unstored declaration list.
pub fn append(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), source: anytype) Error!void {
    return appendRows(allocator, target, source, false);
}

/// Text must outlive the declaration list and every AST container subsequently built from it.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), source: anytype) Error!void {
    return appendRows(allocator, target, source, true);
}

/// Text must outlive the declaration list and every AST container subsequently built from it.
pub fn appendValuesBorrowingText(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), values: anytype) Error!void {
    if (values.len > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;
    try target.ensureUnusedCapacity(allocator, values.len);
    for (values) |value| try appendValue(allocator, target, value, true);
}

fn appendRows(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), source: anytype, comptime borrow_text: bool) Error!void {
    const count = source.tags.len;

    if (source.offsets.len != count or source.constant_name.len != count or source.constant_type_expr.len != count or source.constant_value.len != count or source.constant_exported.len != count) return error.InvalidAst;
    if (count > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;

    for (source.tags, source.offsets) |tag, offset| {
        if (@backingInt(tag) != @backingInt(Tag.constant) or offset >= count) return error.InvalidAst;
    }

    try target.ensureUnusedCapacity(allocator, count);

    for (source.offsets) |offset| {
        try appendValue(allocator, target, .{
            .name = source.constant_name[offset],
            .type_expr = source.constant_type_expr[offset],
            .value = source.constant_value[offset],
            .exported = source.constant_exported[offset],
        }, borrow_text);
    }
}

fn appendValue(allocator: std.mem.Allocator, target: *std.ArrayList(node.Declaration), value: anytype, comptime borrow_text: bool) Error!void {
    target.appendAssumeCapacity(.{ .constant = .{
        .name = if (comptime borrow_text) value.name else try allocator.dupe(u8, value.name),
        .type_expr = if (value.type_expr) |id| @fromBackingInt(id) else null,
        .value = @fromBackingInt(value.value),
        .exported = value.exported,
    } });
}
