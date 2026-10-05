const std = @import("std");
const plugins = @import("runtime").plugins;
const abi = plugins.abi;

const Sink = struct {
    bytes: std.ArrayList(u8) = .empty,
    calls: usize = 0,
    reject: bool = false,
    fn write(context: *anyopaque, bytes: [*]const u8, length: usize) callconv(.c) u32 {
        const self: *Sink = @ptrCast(@alignCast(context));

        self.calls += 1;

        if (self.reject) return 1;

        self.bytes.appendSlice(std.testing.allocator, bytes[0..length]) catch return 1;

        return 0;
    }
};

fn Identity(comptime T: type) type {
    return struct {
        var calls: usize = 0;

        fn run(allocator: std.mem.Allocator, input: T) !T {
            _ = allocator;
            calls += 1;

            return input;
        }
    };
}

fn check(comptime T: type, input: []const u8, expected: []const u8) !void {
    const handler = Identity(T);
    const method = plugins.method("identity", T, T, handler.run);
    var sink: Sink = .{};

    defer sink.bytes.deinit(std.testing.allocator);

    const before = handler.calls;
    const status = method.invoke(input.ptr, input.len, &sink, Sink.write);

    try std.testing.expectEqual(@intFromEnum(abi.Status.success), status);
    try std.testing.expectEqual(before + 1, handler.calls);
    try std.testing.expectEqual(@as(usize, 1), sink.calls);
    try std.testing.expectEqualStrings(expected, sink.bytes.items);
}

fn reject(comptime T: type, input: []const u8) !void {
    const handler = Identity(T);
    const method = plugins.method("identity", T, T, handler.run);
    var sink: Sink = .{};

    defer sink.bytes.deinit(std.testing.allocator);

    const before = handler.calls;
    const status = method.invoke(input.ptr, input.len, &sink, Sink.write);

    try std.testing.expectEqual(@intFromEnum(abi.Status.invalid_input), status);
    try std.testing.expectEqual(before, handler.calls);
    try std.testing.expectEqual(@as(usize, 0), sink.calls);
}

test "plugin wire preserves scalar integer optional enum and void values" {
    try check(u64, "18446744073709551615", "18446744073709551615");
    try check(i64, "-9223372036854775808", "-9223372036854775808");
    try check(u64, "9007199254740993", "9007199254740993");
    try check(bool, "true", "true");
    try check(?u64, "null", "null");
    try check(?u64, "42", "42");
    try check(void, "null", "null");
    try check(enum { first, second }, "\"second\"", "\"second\"");
}

test "plugin wire rejects scalar coercion integer overflow and numeric enum tags" {
    for ([_][]const u8{ "\"7\"", "true", "null", "7.5", "7e0", "-1", "18446744073709551616" }) |input| try reject(u64, input);
    for ([_][]const u8{ "1", "\"true\"", "null" }) |input| try reject(bool, input);
    for ([_][]const u8{ "0", "\"0\"", "\"unknown\"", "null" }) |input| try reject(enum { first, second }, input);
    try reject(void, "0");
    try reject(?u64, "false");
}

test "plugin wire enforces object names tuple arity and nested element types" {
    const Object = struct { a: u32, b: bool };
    const Tuple = struct { u64, bool, ?u32 };

    try check(Object, "{\"b\":true,\"a\":7}", "{\"a\":7,\"b\":true}");
    try check(Tuple, "[9007199254740993,false,null]", "[9007199254740993,false,null]");
    try check([]const []const i64, "[[-1,0],[],[42]]", "[[-1,0],[],[42]]");
    try check([]const u8, "\"文件🌱\\u0000\"", "\"文件🌱\\u0000\"");
    for ([_][]const u8{ "{\"a\":7}", "{\"a\":7,\"c\":true}", "{\"a\":7,\"b\":true,\"c\":0}", "{\"a\":7,\"a\":8,\"b\":true}", "[7,true]" }) |input| try reject(Object, input);
    for ([_][]const u8{ "[]", "[1,true]", "[1,true,null,0]", "[1,0,null]", "{\"0\":1,\"1\":true,\"2\":null}" }) |input| try reject(Tuple, input);
    try reject([]const []const i64, "[[1],[true]]");
}

test "plugin wire preserves finite float bits including negative zero" {
    inline for (.{ f32, f64 }) |Float| {
        const Bits = @Int(.unsigned, @bitSizeOf(Float));
        const values = [_]Float{ 0, -0.0, 1, -1, std.math.floatMin(Float), std.math.floatTrueMin(Float), std.math.floatMax(Float) };
        const method = plugins.method("identity", Float, Float, Identity(Float).run);

        for (values) |value| {
            const input = try std.json.Stringify.valueAlloc(std.testing.allocator, value, .{});

            defer std.testing.allocator.free(input);

            var sink: Sink = .{};

            defer sink.bytes.deinit(std.testing.allocator);

            try std.testing.expectEqual(@intFromEnum(abi.Status.success), method.invoke(input.ptr, input.len, &sink, Sink.write));

            const output = try std.json.parseFromSlice(Float, std.testing.allocator, sink.bytes.items, .{});

            defer output.deinit();

            try std.testing.expectEqual(@as(Bits, @bitCast(value)), @as(Bits, @bitCast(output.value)));
        }

        for ([_][]const u8{ "1e1000", "-1e1000", "\"NaN\"", "\"Infinity\"", "null" }) |input| try reject(Float, input);
    }
}

test "plugin SDK propagates rejected output callback without reporting success" {
    const method = plugins.method("identity", u32, u32, Identity(u32).run);
    var sink: Sink = .{ .reject = true };

    defer sink.bytes.deinit(std.testing.allocator);

    try std.testing.expectEqual(@intFromEnum(abi.Status.output_failed), method.invoke("7", 1, &sink, Sink.write));
    try std.testing.expectEqual(@as(usize, 1), sink.calls);
}

test "plugin SDK rejects oversized input before reading and propagates handler failure" {
    const Failure = struct {
        fn run(allocator: std.mem.Allocator, input: u32) !u32 {
            _ = allocator;
            _ = input;

            return error.ExpectedHandlerFailure;
        }
    };

    const method = plugins.method("failure", u32, u32, Failure.run);
    var sink: Sink = .{};

    defer sink.bytes.deinit(std.testing.allocator);

    try std.testing.expectEqual(@intFromEnum(abi.Status.invalid_input), method.invoke("", abi.maximum_output + 1, &sink, Sink.write));
    try std.testing.expectEqual(@intFromEnum(abi.Status.call_failed), method.invoke("7", 1, &sink, Sink.write));
    try std.testing.expectEqual(@as(usize, 0), sink.calls);
}
