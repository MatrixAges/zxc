const std = @import("std");
const ir = @import("zx").ir;
const Slots = @import("../slots.zig");

pub fn listType(slots: *const Slots, type_id: ir.TypeId, slot: u32) ir.TypeId {
    const generated = @import("generated_uniqueness_list_type");
    const Input = std.meta.Child(generated.Input);
    const Layout = std.meta.Child(@FieldType(Input, "layout"));
    const layout = Layout{ .offsets = slots.offsets, .members = @ptrCast(slots.members), .unwrapped = @ptrCast(slots.unwrapped) };
    var memory = std.heap.FixedBufferAllocator.init(&.{});
    const value = generated.executeIn(memory.allocator(), &.{ .layout = &layout, .kinds = slots.types.kinds, .type_id = @backingInt(type_id), .slot = slot }) catch |err| std.debug.panic("allocation-free slot query failed: {s}", .{@errorName(err)});

    return @fromBackingInt(value);
}

pub fn path(allocator: std.mem.Allocator, slots: *const Slots, type_id: ir.TypeId, slot: u32) std.mem.Allocator.Error![]const u32 {
    const generated = @import("generated_uniqueness_slot_path");
    const Input = std.meta.Child(generated.Input);
    const Layout = std.meta.Child(@FieldType(Input, "layout"));
    const layout = Layout{ .offsets = slots.offsets, .members = @ptrCast(slots.members), .unwrapped = @ptrCast(slots.unwrapped) };

    return generated.executeIn(allocator, &.{ .layout = &layout, .kinds = slots.types.kinds, .type_id = @backingInt(type_id), .slot = slot }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
