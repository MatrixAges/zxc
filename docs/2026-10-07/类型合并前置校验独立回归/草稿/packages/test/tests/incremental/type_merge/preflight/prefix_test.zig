const std = @import("std");
const f = @import("fixture.zig");

test "complete prefix preserves identity across all nine type tags" {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    var table = try f.Table.init(owner.allocator());
    const ids = try f.fill(&table, .base);
    const types = table.items.view();

    try f.valid(owner.allocator(), types);
    try std.testing.expect(types.first[@backingInt(ids.pair)] > 0);
    try std.testing.expect(types.first[@backingInt(ids.record)] > 0);
    try std.testing.expect(types.first[@backingInt(ids.errors)] > 0);
    try std.testing.expect(types.first[@backingInt(ids.mode)] > 0);

    var tags: [@typeInfo(f.ir.TypeValue).@"union".field_names.len]bool = @splat(false);

    for (types.kinds) |kind| tags[kind] = true;
    for (tags) |present| try std.testing.expect(present);

    const mapping = try table.appendFrom(temporary.allocator(), types, table.origins.items.view(), types.count());

    try std.testing.expectEqual(types.count(), mapping.len);
    try f.identity(mapping);
}

test "scalar prefix identity extends through the complete legal suffix" {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    var source = try f.Table.init(owner.allocator());
    var target = try f.Table.init(owner.allocator());
    _ = try f.fill(&source, .base);

    const mapping = try target.appendFrom(temporary.allocator(), source.items.view(), source.origins.items.view(), target.items.count());

    try f.identity(mapping);
    try f.columnsEqual(source.items.view(), target.items.view());
    try f.columnsEqual(source.origins.items.view(), target.origins.items.view());
}

fn rejected(variation: f.Variation) !void {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    const memory = owner.allocator();
    var source = try f.Table.init(memory);
    var target = try f.Table.init(memory);
    _ = try f.fill(&source, .base);
    _ = try f.fill(&target, variation);

    try f.valid(memory, source.items.view());
    try f.valid(memory, target.items.view());
    try std.testing.expectEqual(source.items.count(), target.items.count());

    var previous: f.ir.TypeStorage = .{};
    var origins: f.Origins.Storage = .{};

    try previous.appendDelta(memory, target.items.view());
    try origins.appendTable(memory, target.origins.items.view());
    try std.testing.expectError(error.InvalidModule, target.appendFrom(temporary.allocator(), source.items.view(), source.origins.items.view(), source.items.count()));
    try f.columnsEqual(previous.view(), target.items.view());
    try f.columnsEqual(origins.view(), target.origins.items.view());
}

test "prefix rejects optional child mismatch" {
    try rejected(.optional_child);
}

test "prefix rejects list child mismatch" {
    try rejected(.list_child);
}

test "prefix distinguishes optional from list with the same child" {
    try rejected(.optional_kind);
}

test "prefix rejects task result mismatch" {
    try rejected(.task_result);
}

test "prefix rejects task error reference mismatch" {
    try rejected(.task_errors);
}

test "prefix rejects native reference label mismatch" {
    try rejected(.native_label);
}

test "prefix rejects enumeration label mismatch" {
    try rejected(.enum_label);
}

test "prefix rejects later enumeration member mismatch" {
    try rejected(.enum_member);
}

test "prefix rejects enumeration member count mismatch" {
    try rejected(.enum_count);
}

test "prefix distinguishes enumeration from native reference with the same label" {
    try rejected(.enum_kind);
}

test "prefix rejects later error member mismatch" {
    try rejected(.error_member);
}

test "prefix distinguishes empty from nonempty error set" {
    try rejected(.error_count);
}

test "prefix distinguishes error set from enumeration with the same members" {
    try rejected(.error_kind);
}

test "prefix rejects later tuple child mismatch" {
    try rejected(.tuple_child);
}

test "prefix rejects tuple child count mismatch" {
    try rejected(.tuple_count);
}

test "prefix rejects later object field name mismatch" {
    try rejected(.object_name);
}

test "prefix rejects later object field type mismatch" {
    try rejected(.object_type);
}

test "prefix rejects object field count mismatch" {
    try rejected(.object_count);
}
