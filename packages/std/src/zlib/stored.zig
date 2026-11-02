const std = @import("std");
const flate = std.compress.flate;

pub fn write(output: *std.Io.Writer, input: []const u8, container: flate.Container) !void {
    try output.writeAll(container.header());

    var offset: usize = 0;

    while (true) {
        const length: u16 = @intCast(@min(input.len - offset, std.math.maxInt(u16)));
        const final = input.len - offset == length;

        try output.writeByte(@intFromBool(final));
        try output.writeInt(u16, length, .little);
        try output.writeInt(u16, ~length, .little);
        try output.writeAll(input[offset..][0..length]);

        offset += length;

        if (final) break;
    }

    var hasher = flate.Container.Hasher.init(container);

    hasher.update(input);

    try hasher.writeFooter(output);
}
