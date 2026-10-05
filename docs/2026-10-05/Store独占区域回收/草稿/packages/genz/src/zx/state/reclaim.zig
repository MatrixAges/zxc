const std = @import("std");
const Object = @import("../state.zig").Object;

pub fn write(writer: *std.Io.Writer, objects: []const Object, enabled: bool) std.Io.Writer.Error!void {
    try writer.writeAll("\npub fn releaseRetired(self: *Self) void {\n");

    if (!enabled) {
        try writer.writeAll("    _ = self;\n}\n");

        return;
    }

    try writer.writeAll("    if (self.release_disabled) return;\n\n    var link = &self.retained;\n\n    while (link.*) |region| {\n        if (");

    var separator: []const u8 = "";

    for (objects, 0..) |object, index| {
        if (!object.writable) continue;
        try writer.print("{s}self.owner_{d} == region", .{ separator, index });

        separator = " or ";
    }

    try writer.writeAll(
        \\) {
        \\            link = &region.next;
        \\
        \\            continue;
        \\        }
        \\
        \\        link.* = region.next;
        \\        region.arena.deinit();
        \\        self.arena.child_allocator.destroy(region);
        \\    }
        \\}
        \\
    );
}
