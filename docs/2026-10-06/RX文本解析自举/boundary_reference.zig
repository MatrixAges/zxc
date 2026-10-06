const std = @import("std");
const zx = @import("zx");
const template = @import("template");
const generated = @import("generated");
const Value = struct { value: ?u64, offset: u64 = 0, message: []const u8 = "" };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const start = try std.fmt.parseInt(usize, args[2], 10);
    var reporter = zx.Reporter{};

    const end: ?usize = template.interpolationEnd(source, start, &reporter, 0) catch |err| switch (err) {
        error.InvalidSource => null,
        else => return err,
    };

    const expected: Value = if (reporter.diagnostic) |issue| .{ .value = null, .offset = issue.span.start, .message = issue.message } else .{ .value = end.? };
    const result = try generated.execute(init.arena, &.{ .source = source, .start = start });
    const actual: Value = .{ .value = if (result.message.len == 0) result.end else null, .offset = result.offset, .message = result.message };
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .expected = expected, .actual = actual }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
