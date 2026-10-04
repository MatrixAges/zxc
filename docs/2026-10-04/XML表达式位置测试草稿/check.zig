const std = @import("std");
const rx = @import("rx");
const compiler = @import("compiler");
const rx_compiler = @import("rx_compiler");

pub const Case = struct { source: []const u8, marker: []const u8, valid: bool = false, eof: bool = false };

pub fn run(allocator: std.mem.Allocator, case: Case) !void {
    var result = block: {
        var xml = try rx.parseXml(allocator, case.source);

        defer xml.deinit();

        try std.testing.expect(xml.value == .node);

        break :block try rx_compiler.expression.compile(allocator, "main.rx", xml.value.node.attributes[0], .{});
    };

    defer result.deinit();

    const start = std.mem.indexOf(u8, case.source, case.marker) orelse return error.MissingMarker;
    const end = if (case.eof) start else start + case.marker.len;

    if (case.valid) {
        try std.testing.expect(result.value == .ir);
        const program = result.value.ir;

        try std.testing.expect(try compiler.validateIr(allocator, program) == null);
        const value = program.body[program.body.len - 1].result.?;
        const span = program.expressions[@intFromEnum(value)].span;

        try std.testing.expectEqual(start, span.start);
        try std.testing.expectEqual(end, span.end);

        return;
    }

    try std.testing.expect(result.value == .diagnostic);
    const diagnostic = result.value.diagnostic;

    try std.testing.expectEqual(@as(@FieldType(compiler.Diagnostic, "code"), if (case.eof) .syntax else .name), diagnostic.issue.code);
    try std.testing.expectEqual(start, diagnostic.issue.span.start);
    try std.testing.expectEqual(end, diagnostic.issue.span.end);
    var line: usize = 1;
    var column: usize = 1;

    for (case.source[0..start], 0..) |byte, index| {
        if (byte == '\r') {
            line += 1;
            column = 1;
        } else if (byte == '\n') {
            if (index == 0 or case.source[index - 1] != '\r') line += 1;
            column = 1;
        } else column += 1;
    }

    try std.testing.expectEqual(start, diagnostic.location.offset);
    try std.testing.expectEqual(line, diagnostic.location.line);
    try std.testing.expectEqual(column, diagnostic.location.column);
}
