const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
pub const Table = compiler.project.artifact.type_link.Table;
pub const Origins = @FieldType(Table, "origins");
pub const Bindings = Origins.Table;

pub const Variation = enum {
    base,
    optional_child,
    list_child,
    optional_kind,
    task_result,
    task_errors,
    native_label,
    enum_label,
    enum_member,
    enum_count,
    enum_kind,
    error_member,
    error_count,
    error_kind,
    tuple_child,
    tuple_count,
    object_name,
    object_type,
    object_count,
};

pub const Ids = struct {
    pair: ir.TypeId,
    saved: ir.TypeId,
    record: ir.TypeId,
    list: ir.TypeId,
    errors: ir.TypeId,
    other_errors: ir.TypeId,
    mode: ir.TypeId,
    node: ir.TypeId,
    task: ir.TypeId,
};

pub fn add(table: *Table, value: ir.TypeValue) !ir.TypeId {
    const id: ir.TypeId = @fromBackingInt(@intCast(table.items.count()));

    try table.items.append(table.allocator, value);

    if (value.nominalName()) |name| {
        try table.origins.items.append(table.allocator, .{ .type_id = id, .origin = if (value == .native_reference) .{ .native = "zig:fixture" } else .{ .source = "/fixture/types.zx" }, .name = name });
    }

    return id;
}

pub fn fill(table: *Table, variation: Variation) !Ids {
    const number: ir.TypeId = @fromBackingInt(@backingInt(ir.Scalar.u64));
    const boolean: ir.TypeId = @fromBackingInt(@backingInt(ir.Scalar.bool));
    _ = try add(table, .{ .tuple = &.{boolean} });

    const pair = try add(table, .{ .tuple = if (variation == .tuple_count) &.{number} else &.{ number, if (variation == .tuple_child) number else boolean } });
    const saved = try add(table, if (variation == .optional_kind) .{ .list = number } else .{ .optional = if (variation == .optional_child) boolean else number });

    _ = try add(table, .{ .object = .{ .names = &.{"flag"}, .types = &.{@backingInt(boolean)}, .len = 1 } });

    const names: []const []const u8 = if (variation == .object_count) &.{"pair"} else if (variation == .object_name) &.{ "pair", "stored" } else &.{ "pair", "saved" };
    const types: []const u32 = if (variation == .object_count) &.{@backingInt(pair)} else &.{ @backingInt(pair), @backingInt(if (variation == .object_type) number else saved) };
    const record = try add(table, .{ .object = .{ .names = names, .types = types, .len = names.len } });
    const list = try add(table, .{ .list = if (variation == .list_child) number else record });
    const other_errors = try add(table, .{ .error_set = &.{"Alpha"} });
    const errors = try add(table, if (variation == .error_kind) .{ .enumeration = .{ .name = "Errors", .members = &.{ "First", "Second" } } } else .{ .error_set = if (variation == .error_count) &.{} else if (variation == .error_member) &.{ "First", "Third" } else &.{ "First", "Second" } });

    const mode = try add(table, if (variation == .enum_kind) .{ .native_reference = "Mode" } else .{ .enumeration = .{
        .name = if (variation == .enum_label) "OtherMode" else "Mode",
        .members = if (variation == .enum_count) &.{ "First", "Second", "Third" } else if (variation == .enum_member) &.{ "First", "Third" } else &.{ "First", "Second" },
    } });

    const node = try add(table, .{ .native_reference = if (variation == .native_label) "OtherNode" else "Node" });
    const task = try add(table, .{ .task = .{ .result = if (variation == .task_result) pair else record, .errors = if (variation == .task_errors or variation == .error_kind) other_errors else errors } });

    return .{ .pair = pair, .saved = saved, .record = record, .list = list, .errors = errors, .other_errors = other_errors, .mode = mode, .node = node, .task = task };
}

pub fn valid(memory: std.mem.Allocator, table: ir.TypeTable) !void {
    try std.testing.expect(table.validStructure());

    var exports: std.ArrayList(ir.Export) = .empty;

    defer exports.deinit(memory);

    for (0..table.count()) |index| {
        const value = table.at(index);

        if (value == .native_reference) try exports.append(memory, .{ .name = value.native_reference, .type_id = @fromBackingInt(@intCast(index)) });
    }

    const program: ir.Program = .{
        .file_name = "preflight.zx",
        .types = table,
        .symbols = .{},
        .expressions = .{},
        .input_type = @fromBackingInt(@backingInt(ir.Scalar.void)),
        .output_type = @fromBackingInt(@backingInt(ir.Scalar.void)),
        .body = &.{},
        .type_only = true,
        .native_modules = &.{.{ .specifier = "zig:fixture", .import_name = "fixture", .types = exports.items }},
    };

    const issue = try compiler.validateIr(memory, program);

    if (issue) |diagnostic| std.debug.print("fixture diagnostic: {s}\n", .{diagnostic.message});

    try std.testing.expect(issue == null);
}

pub fn identity(mapping: []const ir.TypeId) !void {
    for (mapping, 0..) |actual, index| try std.testing.expectEqual(@as(u32, @intCast(index)), @backingInt(actual));
}

pub fn columnsEqual(left: anytype, right: @TypeOf(left)) !void {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names) |name| {
        const a = @field(left, name);
        const b = @field(right, name);

        try std.testing.expectEqual(a.len, b.len);

        if (@typeInfo(@TypeOf(a)).pointer.child == []const u8) {
            for (a, b) |x, y| try std.testing.expectEqualStrings(x, y);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(a)).pointer.child, a, b);
    }
}
