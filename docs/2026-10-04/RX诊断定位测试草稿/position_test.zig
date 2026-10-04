const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");

const Case = struct { source: []const u8, marker: []const u8, code: []const u8 = "name" };

fn check(case: Case) !void {
    const allocator = std.testing.allocator;
    var parsed = try rx.parseXml(allocator, case.source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{.{ .path = "number.zx", .source = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n" }},
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;
    const offset = std.mem.indexOf(u8, case.source, case.marker).?;
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
    try check(.{ .source = "<Module><Return value='missing'/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic entity first character" {
    try check(.{ .source = "<Module><Return value='&#109;issing'/></Module>", .marker = "&#109;" });
}

test "RX inferred diagnostic utf8 prefix" {
    try check(.{ .source = "<!--中文--><Module><Return value='missing'/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic normalized attribute newline" {
    try check(.{ .source = "<Module><Return value='\r\n missing'/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic Call input entity" {
    try check(.{ .source = "<Module><Call fn='number' in='&#109;issing'/></Module>", .marker = "&#109;" });
}

test "RX inferred diagnostic Call input line" {
    try check(.{ .source = "<Module>\r\n<Call fn='number' in='missing'/></Module>", .marker = "missing" });
}

test "RX inferred diagnostic Return parse end" {
    try check(.{ .source = "<Module><Return value='1 +'/></Module>", .marker = "'/>", .code = "syntax" });
}

test "RX inferred diagnostic Call parse entity end" {
    try check(.{ .source = "<Module><Call fn='number' in='1 &#43;'/></Module>", .marker = "'/>", .code = "syntax" });
}
