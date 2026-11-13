const std = @import("std");
const zx = @import("zx");
const interface = @import("../../interface.zig");
const Native = interface.Native;
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

pub fn native(scoped: []const Native, name: []const u8, check_duplicates: bool) union(enum) { missing, duplicate, found: *const Native } {
    const standard = if (comptime enabled)
        scan(&standard_names, name, check_duplicates, 0, null)

    else
        select(&interface.standard, "specifier", name, check_duplicates);

    if (standard.duplicate) return .duplicate;

    if (standard.first) |index| {
        if (check_duplicates and select(scoped, "specifier", name, false).first != null) return .duplicate;

        return .{ .found = &interface.standard[index] };
    }

    const local = select(scoped, "specifier", name, check_duplicates);

    if (local.duplicate) return .duplicate;

    return if (local.first) |index| .{ .found = &scoped[index] } else .missing;
}
