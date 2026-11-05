const std = @import("std");
const generated = @import("generated");
pub const Kind = @FieldType(std.meta.Child(generated.Input), "kind");

pub fn check(kind: Kind, receiver: Kind, callee: Kind, name: []const u8) bool {
    const input: std.meta.Child(generated.Input) = .{ .kind = kind, .receiver = receiver, .callee = callee, .name = name };
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return generated.executeValue(memory.allocator(), &input) catch unreachable;
}
