const std = @import("std");
const ir = @import("zx").ir;
const data = @import("nominal_data");
const generated = @import("generated_origin_production");
const Storage = @import("storage.zig");
const buffers = @import("../buffers.zig");

pub fn apply(allocator: std.mem.Allocator, items: *data.Storage, types: ir.TypeTable, first: usize, origin: data.Origin) std.mem.Allocator.Error!void {
    const Input = @typeInfo(@TypeOf(generated.executeBuffered)).@"fn".param_types[1].?;
    const Bindings = @FieldType(Input, "bindings");
    const count = items.ids.items.len;
    var storage = Storage.init(items);

    errdefer items.retainPrefix(count);
    defer storage.apply(items);

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

    const result = generated.executeBuffered(allocator, input, buffers.arguments(generated, &storage, "bindings")) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const added = result.ids.len - count;

    if (added == 0) return;
    try items.names.ensureUnusedCapacity(allocator, added);

    const owned = try data.copy(allocator, origin);

    const owner = switch (owned) {
        .source, .native => |value| value,
        .external => |value| value.module,
    };

    const member = if (owned == .external) owned.external.member else "";

    @memset(storage.owners.list.items[count..], owner);
    @memset(storage.members.list.items[count..], member);

    for (result.ids[count..]) |id| {
        items.names.appendAssumeCapacity(types.labels[id]);
    }
}
