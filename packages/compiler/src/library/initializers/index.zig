const std = @import("std");
const generated = @import("parser_options").generated_parser;
const Self = @This();
const Entry = if (generated) @import("generated_library_initializer_register") else void;
const Input = if (generated) @typeInfo(@TypeOf(Entry.executeState)).@"fn".param_types[1].? else void;
const State = if (generated) @FieldType(Input, "index") else std.StringHashMapUnmanaged(u32);

state: State = if (generated) .{
    .keys = .{ .items = &.{}, .storage = .plain },
    .values = .{ .items = &.{}, .storage = .plain },
    .buckets = .{ .items = &.{}, .storage = .plain },
} else .empty,
pub fn register(self: *Self, allocator: std.mem.Allocator, identity: []const u8, row: usize) std.mem.Allocator.Error!?u32 {
    const id = std.math.cast(u32, row) orelse return error.OutOfMemory;

    if (!generated) {
        const entry = try self.state.getOrPut(allocator, identity);

        if (entry.found_existing) return entry.value_ptr.*;

        entry.value_ptr.* = id;

        return null;
    }

    const result = Entry.executeState(allocator, .{
        .index = self.state,
        .identity = .{ .items = identity, .storage = .plain },
        .row = id,
    }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    self.state = result.index;

    return result.previous;
}
