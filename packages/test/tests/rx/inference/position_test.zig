const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const Case = struct { source: []const u8, marker: []const u8, code: []const u8 = "name", last: bool = false };

fn check(case: Case) !void {
    const allocator = std.testing.allocator;
    var parsed = try rx.parseXml(allocator, case.source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{ .{ .path = "borrow.zx", .source = @embedFile("ownership/fixtures/borrowed.zx") }, .{ .path = "make.zx", .source = @embedFile("ownership/fixtures/make.zx") }, .{ .path = "number.zx", .source = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n" } },
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;
    const offset = (if (case.last) std.mem.lastIndexOf(u8, case.source, case.marker) else std.mem.indexOf(u8, case.source, case.marker)) orelse return error.MissingDiagnosticMarker;
    var line: usize = 1;
    var column: usize = 1;
    var index: usize = 0;

    while (index < offset) : (index += 1) {
        if (case.source[index] == '\r' or case.source[index] == '\n') {
            if (case.source[index] == '\r' and index + 1 < offset and case.source[index + 1] == '\n') index += 1;

            line += 1;
            column = 1;
        } else column += 1;
    }

    try std.testing.expectEqualStrings(case.code, issue.code);
    try std.testing.expectEqualStrings("main.rx", issue.path);
    try std.testing.expectEqual(offset, issue.location.offset);
    try std.testing.expectEqual(line, issue.location.line);
    try std.testing.expectEqual(column, issue.location.column);
}

test "RX inferred diagnostic plain Return" {
    try check(.{ .source = "<Module><Return value={missing}/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic quoted entity string argument" {
    try check(.{ .source = "<Module><Call fn='number' in='&#109;issing'/></Module>", .marker = "&#109;", .code = "type_mismatch" });
}

test "RX inferred diagnostic utf8 prefix" {
    try check(.{ .source = "<!--中文--><Module><Return value={missing}/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic raw expression newline" {
    try check(.{ .source = "<Module><Return value={ \r\n missing}/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic Call input after comment" {
    try check(.{ .source = "<Module><Call fn='number' in={/* 中 */ missing}/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic Call input line" {
    try check(.{ .source = "<Module>\r\n<Call fn='number' in={missing}/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic Return parse end" {
    try check(.{ .source = "<Module><Return value={1 +}/></Module>", .marker = "}/>", .code = "syntax" });
}

test "RX inferred diagnostic Call parse braced end" {
    try check(.{ .source = "<Module><Call fn='number' in={1 +}/></Module>", .marker = "}/>", .code = "syntax" });
}

test "RX inline call diagnostic borrowed input line" {
    try check(.{ .source = "<Module>\n  <Call fn='borrow' in={$in}/>\n  <Return value={$in.pop()}/>\n</Module>", .marker = "$in.pop()", .code = "unsupported" });
}

test "RX inline call diagnostic input after comment" {
    try check(.{ .source = "<Module><Call fn='borrow' in={$in}/><Return value={/* 中 */ $in.pop()}/></Module>", .marker = "$in.pop()", .code = "unsupported" });
}

test "RX inline call diagnostic borrowed output UTF8 CRLF" {
    try check(.{ .source = "<!--中文-->\r\n<Module>\r\n  <Call fn='borrow' in={$in}/>\r\n  <Return value={$ctx.borrow.pop()}/>\r\n</Module>", .marker = "$ctx.borrow.pop()", .code = "unsupported" });
}

test "RX inline call diagnostic points to first forbidden call" {
    try check(.{ .source = "<Module>\n  <Call fn='make' in={$in}/>\n  <Return value={{first: $ctx.make.pop(), second: $ctx.make.pop()}}/>\n</Module>", .marker = "$ctx.make.pop()", .code = "unsupported" });
}
