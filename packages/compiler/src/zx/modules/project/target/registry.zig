const std = @import("std");
const zx = @import("zx");
const interface = @import("../../interface.zig");
const Native = interface.Native;
const NativeSelection = union(enum) { missing, duplicate, found: *const Native };
pub const Registration = struct { valid: bool, existing: bool = false, id: ?zx.ir.NativeModuleId = null };

const enabled = @import("parser_options").generated_parser;
const batch_size = @import("../../package_scope.zig").lookup_batch_size;

pub const Match = struct { first: ?usize = null, duplicate: bool = false };

pub fn select(rows: anytype, comptime field: []const u8, name: []const u8, check_duplicates: bool) Match {
    var result: Match = .{};

    if (comptime !enabled) {
        for (rows, 0..) |*row, index| {
            if (!zx.bytes.equal(@field(row, field), name)) continue;
            if (result.first != null) return .{ .first = result.first, .duplicate = true };

            result.first = index;

            if (!check_duplicates) break;
        }

        return result;
    }

    var names: [batch_size][]const u8 = undefined;
    var offset: usize = 0;

    while (offset < rows.len) {
        const batch = rows[offset..][0..@min(names.len, rows.len - offset)];

        for (batch, names[0..batch.len]) |*row, *key| key.* = @field(row, field);

        result = scan(names[0..batch.len], name, check_duplicates, offset, result.first);

        if (result.duplicate or (!check_duplicates and result.first != null)) break;

        offset += batch.len;
    }

    return result;
}

fn scan(names: []const []const u8, name: []const u8, check_duplicates: bool, offset: usize, first: ?usize) Match {
    const rule = @import("generated_project_package_select");
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const input: std.meta.Child(rule.Input) = .{
        .specifiers = names,
        .name = name,
        .offset = offset,
        .first = first,
        .check_duplicates = check_duplicates,
    };

    const result = zx.columns.invoke(rule.executeValue, scratch.allocator(), &input) catch unreachable;

    return .{ .first = result.first, .duplicate = result.duplicate };
}

const standard_names = blk: {
    var names: [interface.standard.len][]const u8 = undefined;

    for (interface.standard, &names) |entry, *name| name.* = entry.specifier;

    break :blk names;
};

pub fn native(scoped: []const Native, name: []const u8, check_duplicates: bool) NativeSelection {
    if (comptime !enabled) return seedNative(scoped, name, check_duplicates);

    const generated = @import("generated_project_interface_lookup");
    const Input = std.meta.Child(generated.Input);
    const Selected = std.meta.Child(@typeInfo(@FieldType(Input, "previous")).optional.child);
    var selected: ?Selected = null;
    var names: [batch_size][]const u8 = undefined;
    var offset: usize = 0;
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    while (true) {
        const size = @min(names.len, scoped.len - offset);
        const batch = names[0..size];

        for (scoped[offset..][0..size], batch) |*row, *key| key.* = row.specifier;

        const input: Input = .{
            .standard = &standard_names,
            .scoped = batch,
            .name = name,
            .check_duplicates = check_duplicates,
            .offset = offset,
            .previous = if (selected) |*value| value else null,
        };

        const result = zx.columns.invoke(generated.executeValue, scratch.allocator(), &input) catch unreachable;

        if (result.duplicate) return .duplicate;

        offset += size;

        if (offset == scoped.len or (!check_duplicates and result.selected != null)) {
            const matched = result.selected orelse return .missing;

            return .{ .found = switch (matched.source) {
                .Standard => &interface.standard[@intCast(matched.index)],
                .Scoped => &scoped[@intCast(matched.index)],
            } };
        }

        selected = if (result.selected) |value| .{ .source = value.source, .index = value.index } else null;
    }
}

fn seedNative(scoped: []const Native, name: []const u8, check_duplicates: bool) NativeSelection {
    const standard = select(&interface.standard, "specifier", name, check_duplicates);

    if (standard.duplicate) return .duplicate;

    if (standard.first) |index| {
        if (check_duplicates and select(scoped, "specifier", name, false).first != null) return .duplicate;

        return .{ .found = &interface.standard[index] };
    }

    const local = select(scoped, "specifier", name, check_duplicates);

    if (local.duplicate) return .duplicate;

    return if (local.first) |index| .{ .found = &scoped[index] } else .missing;
}

pub fn registration(modules: zx.ir.NativeModuleTable, identity: []const u8, name: []const u8) Registration {
    if (comptime enabled) {
        const generated = @import("generated_project_interface_register");
        const Input = std.meta.Child(generated.Input);
        const table = zx.columns.columns(std.meta.Child(@FieldType(Input, "modules")), modules);
        const input: Input = .{ .modules = &table, .identity = identity, .name = name };
        var scratch = std.heap.FixedBufferAllocator.init(&.{});
        const result = zx.columns.invoke(generated.executeValue, scratch.allocator(), &input) catch unreachable;

        return .{ .valid = result.valid, .existing = result.existing, .id = if (result.id) |id| @fromBackingInt(id) else null };
    }

    if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return .{ .valid = false };

    for (0..modules.count()) |index| {
        const row = modules.at(index);

        if (zx.bytes.equal(row.key(), identity) and zx.bytes.equal(row.import_name, name)) return .{ .valid = true, .existing = true, .id = @fromBackingInt(@as(u32, @intCast(index))) };
    }

    return .{ .valid = true, .id = if (modules.count() < std.math.maxInt(u32)) @fromBackingInt(@as(u32, @intCast(modules.count()))) else null };
}
