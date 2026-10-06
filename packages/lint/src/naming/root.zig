const std = @import("std");
const generated = @import("generated");
pub const NameKind = enum { value, callable, type_decl };

pub fn checkName(name: []const u8, kind: NameKind) bool {
    const Input = @typeInfo(generated.Input).pointer.child;

    const input: Input = .{ .name = name, .kind = switch (kind) {
        .value => .Value,
        .callable => .Callable,
        .type_decl => .TypeDecl,
    } };

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch unreachable;
}
