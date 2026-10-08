const std = @import("std");
const fixture = @import("fixture.zig");
const f = fixture.f;

pub fn run(boundary: fixture.Boundary, scenario: fixture.Scenario) !void {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    const memory = owner.allocator();
    var state = try fixture.create(memory, boundary, scenario);
    var reference = try f.Table.init(memory);

    reference.items.retainPrefix(0);

    try reference.items.appendDelta(memory, state.original.view().prefix(state.first));
    try reference.origins.items.appendTable(memory, fixture.prefixOrigins(state.origins.view(), state.origin_count));

    const before = state.table.items.view();
    const origins = state.table.origins.items.view();

    if (scenario == .conflict) {
        try std.testing.expectError(error.ConflictingNominalType, reference.appendFrom(temporary.allocator(), state.original.view(), state.origins.view(), state.first));
        try std.testing.expectError(error.ConflictingNominalType, state.table.compact(temporary.allocator(), state.first, state.origin_count));
        try std.testing.expectEqual(state.first, state.table.items.count());
        try std.testing.expectEqual(state.origin_count, state.table.origins.items.view().count());
        try fixture.prefixUnchanged(state);
        try fixture.pointersEqual(before, state.table.items.view());
        try fixture.pointersEqual(origins, state.table.origins.items.view());

        return;
    }

    const expected = try reference.appendFrom(temporary.allocator(), state.original.view(), state.origins.view(), state.first);
    const mapping = try state.table.compact(temporary.allocator(), state.first, state.origin_count);

    try std.testing.expectEqualSlices(f.ir.TypeId, expected, mapping);
    try f.columnsEqual(reference.items.view(), state.table.items.view());
    try f.columnsEqual(reference.origins.items.view(), state.table.origins.items.view());
    try fixture.prefixUnchanged(state);
    try fixture.pointersEqual(before, state.table.items.view());
    try fixture.pointersEqual(origins, state.table.origins.items.view());
    for (mapping[0..state.first], 0..) |id, index| try std.testing.expectEqual(@as(u32, @intCast(index)), @backingInt(id));
    try std.testing.expectEqual(mapping[@backingInt(state.ids.pair)], mapping[@backingInt(state.repeated.pair)]);
    try std.testing.expectEqual(mapping[@backingInt(state.ids.record)], mapping[@backingInt(state.repeated.record)]);
    try std.testing.expectEqual(mapping[@backingInt(state.ids.errors)], mapping[@backingInt(state.repeated.errors)]);

    if (scenario == .repeated) {
        try std.testing.expectEqual(mapping[@backingInt(state.ids.mode)], mapping[@backingInt(state.repeated.mode)]);
        try std.testing.expectEqual(mapping[@backingInt(state.ids.node)], mapping[@backingInt(state.repeated.node)]);
        try std.testing.expect(state.table.items.count() < state.original.count());
    } else {
        try std.testing.expect(mapping[@backingInt(state.ids.mode)] != mapping[@backingInt(state.repeated.mode)]);
        try std.testing.expect(mapping[@backingInt(state.ids.node)] != mapping[@backingInt(state.repeated.node)]);
    }

    try std.testing.expect(state.table.items.view().validStructure());
}
