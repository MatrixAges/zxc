const std = @import("std");
const view = @import("view.zig");
const owned = @import("owned.zig");
const Error = @import("import_rows.zig").Error;

fn Counts(comptime Target: type) type {
    const Payloads = @FieldType(std.meta.Child(Target), "payloads");

    return [@typeInfo(Payloads).@"struct".field_names.len]usize;
}

/// Headers select rows from shared payload columns; unselected payloads are not imported.
pub fn check(target: anytype, source: anytype) Error!Counts(@TypeOf(target)) {
    @setEvalBranchQuota(100_000);

    const Tag = std.meta.Child(@TypeOf(target.tags.items));
    const View = std.meta.Child(@TypeOf(source));
    const names = @typeInfo(@TypeOf(target.payloads)).@"struct".field_names;

    comptime view.compatible(Tag, std.meta.Child(@FieldType(View, "tags")));

    if (source.tags.len != source.offsets.len) return error.InvalidAst;
    if (source.tags.len > std.math.maxInt(u32) - target.tags.items.len) return error.OutOfMemory;

    comptime var columns: usize = 2;

    inline for (names) |name| columns += comptime schema(View, @TypeOf(@field(target.payloads, name)), name);

    if (comptime columns != @typeInfo(View).@"struct".field_names.len) @compileError("AST selection has unknown columns");

    var counts: Counts(@TypeOf(target)) = @splat(0);

    for (source.tags, source.offsets) |item, offset| {
        const tag: Tag = @fromBackingInt(@backingInt(item));

        switch (tag) {
            inline else => |selected| try validate(&@field(target.payloads, @tagName(selected)), source, @tagName(selected), offset),
        }

        counts[@backingInt(tag)] += 1;
    }

    return counts;
}

pub fn append(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, false);
}

/// Text must outlive every imported row; other nested payloads receive owned storage.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, true);
}

fn appendRows(allocator: std.mem.Allocator, target: anytype, source: anytype, comptime borrow_text: bool) Error!void {
    const Tag = std.meta.Child(@TypeOf(target.tags.items));
    const names = @typeInfo(@TypeOf(target.payloads)).@"struct".field_names;
    const counts = try check(target, source);

    try target.tags.ensureUnusedCapacity(allocator, source.tags.len);
    try target.offsets.ensureUnusedCapacity(allocator, source.offsets.len);

    inline for (names, 0..) |name, index| {
        if (counts[index] != 0) try @field(target.payloads, name).reserve(allocator, counts[index]);
    }

    for (source.tags, source.offsets) |item, offset| {
        const tag: Tag = @fromBackingInt(@backingInt(item));

        const base = switch (tag) {
            inline else => |selected| value: {
                const column = &@field(target.payloads, @tagName(selected));
                const index = column.count();

                errdefer rollback(allocator, column, index, borrow_text);

                try commit(allocator, column, source, @tagName(selected), offset, borrow_text);

                break :value index;
            },
        };

        target.tags.appendAssumeCapacity(tag);
        target.offsets.appendAssumeCapacity(@intCast(base));
    }
}

fn rollback(allocator: std.mem.Allocator, column: anytype, count: usize, comptime borrow_text: bool) void {
    const Column = std.meta.Child(@TypeOf(column));

    if (@hasField(Column, "fields")) {
        inline for (@typeInfo(@TypeOf(column.fields)).@"struct".field_names) |name| {
            rollback(allocator, &@field(column.fields, name), count, borrow_text);
        }
    } else {
        for (column.values.items[count..]) |value| {
            if (comptime borrow_text) owned.releaseBorrowingText(allocator, value) else owned.release(allocator, value);
        }

        column.values.items.len = count;
    }
}

fn schema(comptime View: type, comptime Column: type, comptime prefix: []const u8) usize {
    if (@hasField(Column, "fields")) {
        comptime var count: usize = 0;

        inline for (@typeInfo(@FieldType(Column, "fields")).@"struct".field_names) |name| {
            count += schema(View, @FieldType(@FieldType(Column, "fields"), name), prefix ++ "_" ++ name);
        }

        return count;
    }

    if (!@hasField(View, prefix)) return 0;

    view.compatible(std.meta.Child(@FieldType(@FieldType(Column, "values"), "items")), std.meta.Child(@FieldType(View, prefix)));

    return 1;
}

fn validate(column: anytype, source: anytype, comptime prefix: []const u8, offset: u32) Error!void {
    const Column = std.meta.Child(@TypeOf(column));
    const View = std.meta.Child(@TypeOf(source));

    if (@hasField(Column, "fields")) {
        inline for (@typeInfo(@TypeOf(column.fields)).@"struct".field_names) |name| {
            try validate(&@field(column.fields, name), source, prefix ++ "_" ++ name, offset);
        }
    } else if (std.meta.Child(@TypeOf(column.values.items)) != void) {
        if (comptime @hasField(View, prefix)) {
            if (offset >= @field(source, prefix).len) return error.InvalidAst;
        } else return error.InvalidAst;
    }
}

fn commit(allocator: std.mem.Allocator, column: anytype, source: anytype, comptime prefix: []const u8, offset: u32, comptime borrow_text: bool) Error!void {
    const Column = std.meta.Child(@TypeOf(column));
    const View = std.meta.Child(@TypeOf(source));

    if (@hasField(Column, "fields")) {
        inline for (@typeInfo(@TypeOf(column.fields)).@"struct".field_names) |name| {
            try commit(allocator, &@field(column.fields, name), source, prefix ++ "_" ++ name, offset, borrow_text);
        }
    } else {
        const Value = std.meta.Child(@TypeOf(column.values.items));

        if (Value == void) {
            column.append({});
        } else if (comptime @hasField(View, prefix)) {
            const values = @field(source, prefix);
            const converted = @as([*]const Value, @ptrCast(values.ptr))[offset];

            column.append(if (comptime borrow_text) try owned.copyBorrowingText(allocator, converted) else try owned.copy(allocator, converted));
        } else unreachable;
    }
}
