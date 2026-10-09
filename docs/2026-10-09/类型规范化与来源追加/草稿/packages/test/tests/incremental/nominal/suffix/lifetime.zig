const std = @import("std");
const h = @import("check.zig");
const f = h.f;

pub fn run(origin: f.Origins.Origin) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    const input = try f.create(setup.allocator(), origin == .native);

    var items = f.Origins{ .allocator = owner.allocator() };

    {
        var words = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer words.deinit();

        const memory = words.allocator();

        const label = try memory.dupe(u8, switch (origin) {
            .source, .native => |value| value,
            .external => |value| value.module,
        });

        const member = try memory.dupe(u8, if (origin == .external) origin.external.member else "");

        const borrowed: f.Origins.Origin = switch (origin) {
            .source => .{ .source = label },
            .native => .{ .native = label },
            .external => .{ .external = .{ .module = label, .member = member } },
        };

        try items.append(input.types, 0, borrowed);

        @memset(label, '?');
        @memset(member, '?');
    }

    try h.result(items, input, 0, origin, false);
}
