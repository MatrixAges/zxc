const std = @import("std");
const access = @import("access.zig");
const Writer = access.Writer;
const view = access.view;

pub fn prepareNames(writer: Writer) error{OutOfMemory}!void {
    const data = view(writer);
    const names = try data.allocator.dupe([]const u8, data.value.error_set);

    data.state.columns = .{ .names = names, .types = null };
    data.state.owns_names = true;
}

pub fn copyName(writer: Writer, index: u64) error{OutOfMemory}!void {
    const data = view(writer);
    const name = &data.state.columns.names[@intCast(index)];
    name.* = try data.allocator.dupe(u8, name.*);
}

pub fn sortNames(writer: Writer) error{OutOfMemory}!void {
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    @import("generated_name_sort").execute(&arena, @ptrCast(&view(writer).state.columns)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn append(writer: Writer) error{OutOfMemory}!u64 {
    const data = view(writer);
    const columns = data.state.columns;

    const value = switch (data.value) {
        .object => @as(@TypeOf(data.value), .{ .object = .{ .names = columns.names, .types = columns.types.?, .len = columns.names.len } }),
        .error_set => @as(@TypeOf(data.value), .{ .error_set = columns.names }),
        else => data.value,
    };

    const id = data.items.count();

    try data.items.append(data.allocator, value);

    return id;
}
