const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../../lower.zig");
const ownership = @import("../ownership.zig");

pub fn build(self: *Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) Lower.Error![]const u8 {
    const generated = @import("generated_ownership_helper_name");
    const Input = std.meta.Child(generated.Input);
    const Eligibility = std.meta.Child(@FieldType(Input, "source"));
    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    const source: Eligibility = .{
        .first = self.plan.slot_first,
        .transfers = self.plan.transfers,
        .node = @backingInt(id),
        .slot = slot,
    };

    const input: Input = .{
        .hash = @ptrCast(&hash),
        .names = self.type_names,
        .index = @backingInt(type_id),
        .key = &self.state_plan.keys[@backingInt(type_id)],
        .source = &source,
        .count = ownership.count(self, type_id),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid ownership helper name"),
    };

    return self.allocator.dupe(u8, output);
}
