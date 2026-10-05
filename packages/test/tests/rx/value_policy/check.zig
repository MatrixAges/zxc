const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const Case = struct { name: []const u8, source: []const u8, marker: []const u8, store_source: ?[]const u8 = null };
const message = "RX values cannot contain calls or callbacks; move logic to ZX and use Call.fn or Call.module";
const number = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n";

pub fn run(name: []const u8) !void {
    try allocated(std.testing.allocator, name);
}

pub fn allocated(allocator: std.mem.Allocator, name: []const u8) !void {
    const cases = try std.json.parseFromSlice([]const Case, allocator, @embedFile("rejections.json"), .{});

    defer cases.deinit();

    for (cases.value) |case| {
        if (!std.mem.eql(u8, name, case.name)) continue;

        var parsed = try rx.parseXml(allocator, case.source);

        defer parsed.deinit();

        try std.testing.expect(parsed.value == .node);

        var state: ?rx.XmlResult = null;

        defer if (state) |*parsed_state| parsed_state.deinit();

        if (case.store_source) |source| {
            state = try rx.parseXml(allocator, source);

            try std.testing.expect(state.?.value == .node);
        }

        var result = try analysis.module.infer(allocator, .{
            .owner = "main.rx",
            .module = parsed.value.node,
            .sources = &.{.{ .path = "number.zx", .source = number }},
            .stores = if (state) |parsed_state| &.{.{ .path = "state.store.rx", .node = parsed_state.value.node }} else &.{},
        });

        defer result.deinit();

        if (result.value != .diagnostic) return error.ExpectedDiagnostic;

        const issue = result.value.diagnostic;
        const text = case.store_source orelse case.source;
        const offset = std.mem.indexOf(u8, text, case.marker) orelse return error.MissingMarker;
        var line: usize = 1;
        var column: usize = 1;
        var index: usize = 0;

        while (index < offset) : (index += 1) {
            if (text[index] == '\r' or text[index] == '\n') {
                if (text[index] == '\r' and index + 1 < offset and text[index + 1] == '\n') index += 1;

                line += 1;
                column = 1;
            } else column += 1;
        }

        try std.testing.expectEqualStrings("unsupported", issue.code);
        try std.testing.expectEqualStrings(message, issue.message);
        try std.testing.expectEqualStrings(if (state != null) "state.store.rx" else "main.rx", issue.path);
        try std.testing.expectEqual(offset, issue.location.offset);
        try std.testing.expectEqual(line, issue.location.line);
        try std.testing.expectEqual(column, issue.location.column);

        return;
    }

    return error.MissingCase;
}
