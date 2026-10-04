const std = @import("std");
const manifest = @import("manifest");

const source =
    \\name: sample
    \\version: 1.2.3
    \\exports:
    \\  ./z: 'source folder/模块.zx'
    \\  .: 'quoted "name".rx'
    \\  ./nested/a_b-c: 'hash# spaced file.zx'
    \\private: true
    \\dependencies:
    \\  other: ^1.0.0
;

fn roundTrip(allocator: std.mem.Allocator) !void {
    const input = try allocator.dupe(u8, source);
    defer allocator.free(input);

    var first = try manifest.parse(allocator, input);
    defer first.deinit();

    @memset(input, 'x');
    try std.testing.expect(first.value == .data);
    const data = first.value.data;
    try std.testing.expectEqual(@as(usize, 3), data.exports.len);
    try std.testing.expectEqualStrings("./z", data.exports[0].path);
    try std.testing.expectEqualStrings("source folder/模块.zx", data.exports[0].source);
    try std.testing.expectEqualStrings(".", data.exports[1].path);
    try std.testing.expectEqualStrings("quoted \"name\".rx", data.exports[1].source);
    try std.testing.expectEqualStrings("./nested/a_b-c", data.exports[2].path);
    try std.testing.expectEqualStrings("hash# spaced file.zx", data.exports[2].source);

    var output: std.Io.Writer.Allocating = .init(allocator);
    defer output.deinit();

    manifest.write(&output.writer, data) catch return error.OutOfMemory;

    var second = try manifest.parse(allocator, output.written());
    defer second.deinit();

    try std.testing.expect(second.value == .data);
    try std.testing.expectEqualDeep(data, second.value.data);
    @memset(output.writer.buffer, 0);
    try std.testing.expectEqualStrings("source folder/模块.zx", second.value.data.exports[0].source);
}

fn rejected(allocator: std.mem.Allocator, text: []const u8, message: []const u8) !void {
    var result = try manifest.parse(allocator, text);
    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqualStrings(message, result.value.diagnostic.message);
}

test "exports own input and round trip all manifest fields across allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, roundTrip, .{});
}

test "exports duplicate map releases partial parse allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{ "name: sample\nversion: 1.0.0\nexports:\n  .: a.zx\n  .: b.zx\n", "duplicate YAML mapping key" });
}

test "exports later invalid source releases earlier entries" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{ "name: sample\nversion: 1.0.0\nexports:\n  ./a: a.zx\n  ./b: ../b.zx\n", "export implementation must stay inside the package" });
}

test "exports entry conflict releases complete map" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{ "name: sample\nversion: 1.0.0\nentry: a.zx\nexports:\n  .: a.zx\n", "entry and exports cannot both define the package public interface" });
}

test "exports writer reports bounded output failure" {
    var parsed = try manifest.parse(std.testing.allocator, source);
    defer parsed.deinit();
    try std.testing.expect(parsed.value == .data);

    var buffer: [80]u8 = undefined;
    var writer: std.Io.Writer = .fixed(&buffer);
    try std.testing.expectError(error.WriteFailed, manifest.write(&writer, parsed.value.data));
}

test "legacy entry round trip keeps exports empty" {
    var parsed = try manifest.parse(std.testing.allocator, "name: sample\nversion: 1.0.0\nentry: main.zx\n");
    defer parsed.deinit();
    try std.testing.expect(parsed.value == .data);

    var output: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer output.deinit();
    try manifest.write(&output.writer, parsed.value.data);

    var second = try manifest.parse(std.testing.allocator, output.written());
    defer second.deinit();
    try std.testing.expectEqualDeep(parsed.value, second.value);
    try std.testing.expectEqual(@as(usize, 0), second.value.data.exports.len);
}
