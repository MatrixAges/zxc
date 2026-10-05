const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const Case = struct { source: []const u8, marker: []const u8, code: []const u8 = "name", reverse_marker: ?[]const u8 = null };

fn check(case: Case) !void {
    for ([_]bool{ false, true }) |reverse| try checkOrder(case, reverse);
}

fn checkOrder(case: Case, reverse: bool) !void {
    const main_source = "<!--入口中文与额外偏移-->\n<Module>\n  <Call service='./child.rx' in={1} out='ctx.value'/>\n  <Return value={ctx.value}/>\n</Module>";
    var main = try rx.parseXml(std.testing.allocator, main_source);

    defer main.deinit();

    var child = try rx.parseXml(std.testing.allocator, case.source);

    defer child.deinit();

    try std.testing.expect(main.value == .node and child.value == .node);

    var sources = [_]rx.ModuleSource{
        .{ .path = "root/main.rx", .node = main.value.node },
        .{ .path = "root/child.rx", .node = child.value.node },
    };

    if (reverse) std.mem.swap(rx.ModuleSource, &sources[0], &sources[1]);

    var result = try analysis.project.infer(std.testing.allocator, .{
        .entry = "root/main.rx",
        .modules = &sources,
        .sources = &.{.{ .path = "root/number.zx", .source = @embedFile("fixtures/number.zx") }},
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;
    const reverse_entry = reverse and case.reverse_marker != null;
    const expected_source = if (reverse_entry) main_source else case.source;
    const marker = if (reverse_entry) case.reverse_marker.? else case.marker;
    const offset = std.mem.indexOf(u8, expected_source, marker).?;
    var line: usize = 1;
    var column: usize = 1;
    var index: usize = 0;

    while (index < offset) : (index += 1) {
        if (expected_source[index] == '\r' or expected_source[index] == '\n') {
            if (expected_source[index] == '\r' and index + 1 < offset and expected_source[index + 1] == '\n') index += 1;

            line += 1;
            column = 1;
        } else column += 1;
    }

    try std.testing.expectEqualStrings(case.code, issue.code);
    try std.testing.expectEqualStrings(if (reverse_entry) "root/main.rx" else "root/child.rx", issue.path);
    try std.testing.expectEqual(offset, issue.location.offset);
    try std.testing.expectEqual(line, issue.location.line);
    try std.testing.expectEqual(column, issue.location.column);
}

test "RX project child unknown name position" {
    try check(.{ .source = "<Module><Return value={missing}/></Module>", .marker = "missing" });
}

test "RX project child UTF8 CRLF entity position" {
    try check(.{ .source = "<!--中文-->\r\n<Module>\r\n  <Return value={missing}/>\r\n</Module>", .marker = "&#109;" });
}

test "RX project child normalized attribute line position" {
    try check(.{ .source = "<Module><Return value={  missing}/></Module>", .marker = "missing" });
}

test "RX project child encoded expression end position" {
    try check(.{ .source = "<Module><Return value={1 +}/></Module>", .marker = "'/>", .code = "syntax" });
}

test "RX project child invalid result binding position" {
    try check(.{ .source = "<Module>\n<Call fn='number' in={1} out='ctx..bad'/><Return value={true}/></Module>", .marker = "ctx..bad" });
}

test "RX project child missing target position" {
    try check(.{ .source = "<Module>\n<Call service='./missing.rx' in={$in}/></Module>", .marker = "./missing.rx", .code = "context" });
}

test "RX project child circular target position" {
    try check(.{ .source = "<Module>\n<Call service='./main.rx' in={$in}/></Module>", .marker = "./main.rx", .code = "context", .reverse_marker = "./child.rx" });
}

test "RX project child self reference position" {
    try check(.{ .source = "<Module>\n<Call service='./child.rx' in={$in}/></Module>", .marker = "./child.rx", .code = "context" });
}
