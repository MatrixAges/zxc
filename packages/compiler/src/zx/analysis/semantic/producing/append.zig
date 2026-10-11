const std = @import("std");
const ir = @import("zx").ir;
const data = @import("nominal_data");
const generated = @import("generated_origin_production");

pub fn apply(allocator: std.mem.Allocator, items: *data.Storage, types: ir.TypeTable, first: usize, origin: data.Origin) std.mem.Allocator.Error!void {
    const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const Bindings = @FieldType(Input, "bindings");
    const count = items.ids.items.len;
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();
    errdefer items.retainPrefix(count);

    const input: Input = .{
        .kinds = types.kinds,
        .first = first,
        .origin = .{
            .kind = switch (origin) {
                .source => 0,
                .native => 1,
                .external => 2,
            },
            .owner = switch (origin) {
                .source, .native => |value| value,
                .external => |value| value.module,
            },
            .member = if (origin == .external) origin.external.member else "",
        },
        .bindings = data.Table.borrow(Bindings, items.view()),
    };

    const result = generated.executeValue(arena.allocator(), input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const added = result.ids.len - count;

    if (added == 0) return;
    try items.ids.appendSlice(allocator, result.ids[count..]);
    try items.kinds.appendSlice(allocator, result.kinds[count..]);
    try items.owners.ensureUnusedCapacity(allocator, added);
    try items.members.ensureUnusedCapacity(allocator, added);
    try items.names.ensureUnusedCapacity(allocator, added);

    const owned = try data.copy(allocator, origin);

    const owner = switch (owned) {
        .source, .native => |value| value,
        .external => |value| value.module,
    };

    const member = if (owned == .external) owned.external.member else "";

    items.owners.appendNTimesAssumeCapacity(owner, added);
    items.members.appendNTimesAssumeCapacity(member, added);

    for (result.ids[count..]) |id| {
        items.names.appendAssumeCapacity(types.labels[id]);
    }
}
