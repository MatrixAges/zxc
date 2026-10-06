const std = @import("std");
const zx = @import("zx");
const Types = @import("../types.zig");
const Writer = @import("construction_writer");
const Flags = @import("type_flags_view");

pub fn create(types: *Types, value: zx.ir.TypeValue, fields: ?Types.Fields) zx.Error!zx.ir.TypeId {
    var state: Writer.State = .{};

    if (fields) |columns| state.columns = .{ .names = columns.names, .types = columns.types };

    const writer = Writer{ .allocator = types.allocator, .reporter = types.reporter, .items = &types.items, .value = value, .state = &state };

    defer writer.deinit();

    var flags_state: Flags.State = .{};
    const flags = Flags{ .allocator = types.allocator, .state = &flags_state };

    defer flags.deinit();

    const generated = @import("generated_type_construction");
    const Input = @typeInfo(generated.Input).pointer.child;
    const input: Input = .{ .writer = @ptrCast(&writer), .flags = @ptrCast(&flags) };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const id = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidSource => return error.InvalidSource,
        else => unreachable,
    };

    return @fromBackingInt(@intCast(id));
}
