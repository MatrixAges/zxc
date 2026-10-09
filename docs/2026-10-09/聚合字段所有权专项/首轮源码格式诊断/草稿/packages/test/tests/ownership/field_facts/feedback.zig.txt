const std = @import("std");

pub fn source(allocator: std.mem.Allocator, fields: usize, projection: []const u8) ![]u8 {
    var text: std.Io.Writer.Allocating = .init(allocator);

    errdefer text.deinit();

    const writer = &text.writer;

    try writer.writeAll("export type Input = u64[]\n\nexport type Output = u64[]\n\nexport default function (in: Input): Output {\n    const fresh: u64[] = []\n\n    const result = loop({index: 0, source: in, untouched: fresh");
    for (0..fields) |index| try writer.print(", v{d}: fresh", .{index});
    try writer.writeAll("}, {\n        while: state => state.index < state.source.length,\n        next: state => {\n");
    try writer.writeAll("            state = {\n                index: state.index + 1,\n                source: state.source,\n                untouched: state.untouched");

    for (0..fields) |index| {
        try writer.print(",\n                v{d}: ", .{index});
        if (index + 1 == fields) try writer.writeAll("state.source") else try writer.print("state.v{d}", .{index + 1});
    }

    try writer.print("\n            }}\n        }}\n    }})\n\n    return result.{s}\n}}\n", .{projection});

    return try text.toOwnedSlice();
}
