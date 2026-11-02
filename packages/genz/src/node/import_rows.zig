const std = @import("std");
const view = @import("view.zig");
const owned = @import("owned.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

pub fn append(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, true);
}

/// All slice payloads must outlive the target; the column descriptors themselves are copied.
pub fn appendBorrowed(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, false);
}

fn appendRows(allocator: std.mem.Allocator, target: anytype, source: anytype, comptime copy_payloads: bool) Error!void {
    @setEvalBranchQuota(100_000);

    const View = std.meta.Child(@TypeOf(source));
    const Payloads = @TypeOf(target.payloads);
    const names = @typeInfo(Payloads).@"struct".field_names;
    const Tag = std.meta.Child(@TypeOf(target.tags.items));
    const fields = @typeInfo(View).@"struct".field_names;

    comptime view.compatible(Tag, std.meta.Child(@FieldType(View, "tags")));

    if (source.tags.len != source.offsets.len) return error.InvalidAst;
    if (source.tags.len > std.math.maxInt(u32) - target.tags.items.len) return error.OutOfMemory;

    var counts: [names.len]usize = @splat(0);

    for (source.tags) |tag| counts[@backingInt(tag)] += 1;

    for (source.tags, source.offsets) |tag, offset| {
        if (offset >= counts[@backingInt(tag)]) return error.InvalidAst;
    }

    comptime var column_count: usize = 2;

    inline for (names, 0..) |name, index| {
        const Column = @FieldType(Payloads, name);
        column_count += comptime present(View, Column, name);

        try validate(&@field(target.payloads, name), source, name, counts[index]);
    }

    if (comptime column_count != fields.len) @compileError("AST import has unknown columns");
    try target.tags.ensureUnusedCapacity(allocator, source.tags.len);
    try target.offsets.ensureUnusedCapacity(allocator, source.offsets.len);

    inline for (names, 0..) |name, index| {
        if (counts[index] != 0) try @field(target.payloads, name).reserve(allocator, counts[index]);
    }

    var prepared = source.*;
    var copied: [fields.len]bool = @splat(false);

    defer inline for (fields, 0..) |name, index| {
        if (copied[index]) allocator.free(@field(prepared, name));
    };

    errdefer inline for (fields, 0..) |name, index| {
        if (comptime owned.containsSlice(std.meta.Child(@FieldType(View, name)))) {
            if (copied[index]) for (@field(prepared, name)) |value| owned.release(allocator, value);
        }
    };

    inline for (fields, 0..) |name, index| {
        if (comptime copy_payloads and owned.containsSlice(std.meta.Child(@FieldType(View, name)))) {
            @field(prepared, name) = try owned.copy(allocator, @field(source, name));

            copied[index] = true;
        }
    }

    for (prepared.tags, prepared.offsets) |item, offset| {
        const tag: Tag = @fromBackingInt(@backingInt(item));

        const base = switch (tag) {
            inline else => |selected| @field(target.payloads, @tagName(selected)).count(),
        };

        target.tags.appendAssumeCapacity(tag);
        target.offsets.appendAssumeCapacity(@intCast(base + offset));
    }

    inline for (names, 0..) |name, index| {
        if (counts[index] != 0) commit(&@field(target.payloads, name), &prepared, name, counts[index]);
    }
}

fn present(comptime View: type, comptime Column: type, comptime prefix: []const u8) usize {
    if (!@hasField(Column, "fields")) return @intFromBool(@hasField(View, prefix));

    var count: usize = 0;
    const Fields = @FieldType(Column, "fields");

    for (@typeInfo(Fields).@"struct".field_names) |name| {
        count += present(View, @FieldType(Fields, name), prefix ++ "_" ++ name);
    }

    return count;
}

fn validate(column: anytype, source: anytype, comptime prefix: []const u8, count: usize) Error!void {
    const Column = std.meta.Child(@TypeOf(column));
    const View = std.meta.Child(@TypeOf(source));

    if (@hasField(Column, "fields")) {
        inline for (@typeInfo(@TypeOf(column.fields)).@"struct".field_names) |name| {
            try validate(&@field(column.fields, name), source, prefix ++ "_" ++ name, count);
        }
    } else if (std.meta.Child(@TypeOf(column.values.items)) != void) {
        if (@hasField(View, prefix)) {
            comptime view.compatible(std.meta.Child(@TypeOf(column.values.items)), std.meta.Child(@FieldType(View, prefix)));

            if (@field(source, prefix).len != count) return error.InvalidAst;
        } else if (count != 0) return error.InvalidAst;
    }
}

fn commit(column: anytype, source: anytype, comptime prefix: []const u8, count: usize) void {
    const Column = std.meta.Child(@TypeOf(column));
    const View = std.meta.Child(@TypeOf(source));

    if (@hasField(Column, "fields")) {
        inline for (@typeInfo(@TypeOf(column.fields)).@"struct".field_names) |name| {
            commit(&@field(column.fields, name), source, prefix ++ "_" ++ name, count);
        }
    } else {
        const Value = std.meta.Child(@TypeOf(column.values.items));

        if (Value == void) {
            for (0..count) |_| column.append({});
        } else if (@hasField(View, prefix)) {
            const values = @field(source, prefix);
            const converted = @as([*]const Value, @ptrCast(values.ptr))[0..values.len];

            column.values.appendSliceAssumeCapacity(converted);
        }
    }
}
