const std = @import("std");
const view = @import("view.zig");
const owned = @import("owned.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidAst};

pub fn append(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, true, false);
}

/// All slice payloads must outlive the target; the column descriptors themselves are copied.
pub fn appendBorrowed(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, false, false);
}

/// Text bytes must outlive the target; nested non-text slices receive owned storage.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: anytype, source: anytype) Error!void {
    return appendRows(allocator, target, source, true, true);
}

pub fn check(target: anytype, source: anytype) Error!Counts(@TypeOf(target)) {
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
    var valid = true;

    inline for (names, 0..) |name, index| {
        const Column = @FieldType(Payloads, name);

        column_count += comptime present(View, Column, name);
        valid = valid and validateColumn(Column, source, name, counts[index]);
    }

    if (comptime column_count != fields.len) @compileError("AST import has unknown columns");
    if (!valid) return error.InvalidAst;

    return counts;
}

fn Counts(comptime Target: type) type {
    const Payloads = @FieldType(std.meta.Child(Target), "payloads");

    return [@typeInfo(Payloads).@"struct".field_names.len]usize;
}

fn appendRows(allocator: std.mem.Allocator, target: anytype, source: anytype, comptime copy_payloads: bool, comptime borrow_text: bool) Error!void {
    @setEvalBranchQuota(100_000);

    const View = std.meta.Child(@TypeOf(source));
    const Payloads = @TypeOf(target.payloads);
    const names = @typeInfo(Payloads).@"struct".field_names;
    const Tag = std.meta.Child(@TypeOf(target.tags.items));
    const fields = comptime copiedFields(View, copy_payloads, borrow_text);
    const counts = try check(target, source);

    try reserveCounts(allocator, target, &counts, source.tags.len);

    var storage: if (fields.len == 0) void else View = if (fields.len == 0) {} else source.*;
    const prepared = if (fields.len == 0) source else &storage;
    var copied: [fields.len]bool = @splat(false);

    defer inline for (fields, 0..) |name, index| {
        if (copied[index]) allocator.free(@field(prepared, name));
    };

    if (comptime fields.len != 0) {
        const failure: ?Error = copying: {
            inline for (fields, 0..) |name, index| {
                if (@field(source, name).len != 0) {
                    @field(prepared, name) = if (comptime borrow_text)
                        owned.copyBorrowingText(allocator, @field(source, name)) catch |err| break :copying err
                    else
                        owned.copy(allocator, @field(source, name)) catch |err| break :copying err;

                    copied[index] = true;
                }
            }

            break :copying null;
        };

        if (failure) |err| {
            inline for (fields, 0..) |name, index| {
                if (copied[index]) for (@field(prepared, name)) |value| {
                    if (comptime borrow_text) owned.releaseBorrowingText(allocator, value) else owned.release(allocator, value);
                };
            }

            return err;
        }
    }

    const tags = @as([*]const Tag, @ptrCast(prepared.tags.ptr))[0..prepared.tags.len];

    commitHeaders(target, tags, prepared.offsets);

    inline for (names, 0..) |name, index| {
        if (counts[index] != 0) commit(&@field(target.payloads, name), prepared, name, counts[index]);
    }
}

fn commitHeaders(target: anytype, tags: []const std.meta.Child(@TypeOf(target.tags.items)), offsets: anytype) void {
    for (tags, offsets) |tag, offset| {
        const base = switch (tag) {
            inline else => |selected| @field(target.payloads, @tagName(selected)).count(),
        };

        target.tags.appendAssumeCapacity(tag);
        target.offsets.appendAssumeCapacity(@intCast(base + offset));
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

inline fn validateColumn(comptime Column: type, source: anytype, comptime prefix: []const u8, count: usize) bool {
    const View = std.meta.Child(@TypeOf(source));

    if (@hasField(Column, "fields")) {
        const Fields = @FieldType(Column, "fields");
        var valid = true;

        inline for (@typeInfo(Fields).@"struct".field_names) |name| {
            valid = valid and validateColumn(@FieldType(Fields, name), source, prefix ++ "_" ++ name, count);
        }

        return valid;
    }

    const Value = std.meta.Child(@FieldType(@FieldType(Column, "values"), "items"));

    if (Value == void) return true;

    if (@hasField(View, prefix)) {
        comptime view.compatible(Value, std.meta.Child(@FieldType(View, prefix)));

        return @field(source, prefix).len == count;
    }

    return count == 0;
}

inline fn commit(column: anytype, source: anytype, comptime prefix: []const u8, count: usize) void {
    const Column = std.meta.Child(@TypeOf(column));
    const View = std.meta.Child(@TypeOf(source));

    if (@hasField(Column, "fields")) {
        inline for (@typeInfo(@TypeOf(column.fields)).@"struct".field_names) |name| {
            commit(&@field(column.fields, name), source, prefix ++ "_" ++ name, count);
        }
    } else {
        const Value = std.meta.Child(@TypeOf(column.values.items));

        if (Value == void) {
            commitVoid(column, count);
        } else if (@hasField(View, prefix)) {
            const values = @field(source, prefix);
            const converted = @as([*]const Value, @ptrCast(values.ptr))[0..values.len];

            commitValues(column, converted);
        }
    }
}

fn commitVoid(column: anytype, count: usize) void {
    for (0..count) |_| column.append({});
}

fn commitValues(column: anytype, values: []const std.meta.Child(@TypeOf(column.values.items))) void {
    column.values.appendSliceAssumeCapacity(values);
}

fn copiedFields(comptime View: type, comptime copy_payloads: bool, comptime borrow_text: bool) []const []const u8 {
    if (!copy_payloads) return &.{};

    var result: []const []const u8 = &.{};

    for (@typeInfo(View).@"struct".field_names) |name| {
        const Value = std.meta.Child(@FieldType(View, name));

        if (owned.containsSlice(Value) and !(borrow_text and Value == []const u8)) result = result ++ &[_][]const u8{name};
    }

    return result;
}

fn reserveCounts(allocator: std.mem.Allocator, target: anytype, counts: *const Counts(@TypeOf(target)), additional: usize) Error!void {
    try target.tags.ensureUnusedCapacity(allocator, additional);
    try target.offsets.ensureUnusedCapacity(allocator, additional);

    inline for (@typeInfo(@TypeOf(target.payloads)).@"struct".field_names, 0..) |name, index| {
        if (counts[index] != 0) try @field(target.payloads, name).reserve(allocator, counts[index]);
    }
}
