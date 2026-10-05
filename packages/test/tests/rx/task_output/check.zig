const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");
const Expected = struct { code: []const u8, marker: []const u8, last: bool = false, message: ?[]const u8 = null };

const Case = struct {
    name: []const u8,
    source: []const u8,
    input_scalar: compiler.ir.Scalar = .u64,
    output_kind: []const u8 = "scalar",
    output_scalar: ?compiler.ir.Scalar = .u64,
    diagnostic: ?Expected = null,
};

pub fn run(name: []const u8) !void {
    try allocated(std.testing.allocator, name);
}

pub fn allocated(allocator: std.mem.Allocator, name: []const u8) !void {
    const cases = try std.json.parseFromSlice([]const Case, allocator, @embedFile("cases.json"), .{ .ignore_unknown_fields = true });

    defer cases.deinit();

    for (cases.value) |case| {
        if (std.mem.eql(u8, name, case.name)) return verify(allocator, case);
    }

    return error.MissingCase;
}

fn verify(allocator: std.mem.Allocator, case: Case) !void {
    var parsed = try rx.parseXml(allocator, case.source);

    defer parsed.deinit();

    var leaf = try rx.parseXml(allocator, @embedFile("fixtures/leaf.rx"));

    defer leaf.deinit();

    try std.testing.expect(parsed.value == .node and leaf.value == .node);

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{
            .{ .path = "main.rx", .node = parsed.value.node },
            .{ .path = "leaf.rx", .node = leaf.value.node },
        },
        .sources = &.{
            .{ .path = "number.zx", .source = @embedFile("fixtures/number.zx") },
            .{ .path = "task.zx", .source = @embedFile("fixtures/number.zx") },
            .{ .path = "discard.zx", .source = @embedFile("fixtures/discard.zx") },
        },
    });

    defer result.deinit();

    if (case.diagnostic) |expected| {
        if (result.value != .diagnostic) return error.ExpectedDiagnostic;

        const issue = result.value.diagnostic;
        const offset = (if (expected.last) std.mem.lastIndexOf(u8, case.source, expected.marker) else std.mem.indexOf(u8, case.source, expected.marker)) orelse return error.MissingMarker;
        var line: usize = 1;
        var column: usize = 1;

        for (case.source[0..offset]) |byte| {
            if (byte == '\n') {
                line += 1;
                column = 1;
            } else column += 1;
        }

        errdefer std.debug.print("{s}: {s}:{d}:{d}: {s}: {s}\n", .{ case.name, issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        try std.testing.expectEqualStrings(expected.code, issue.code);
        try std.testing.expectEqualStrings("main.rx", issue.path);
        try std.testing.expectEqual(offset, issue.location.offset);
        try std.testing.expectEqual(line, issue.location.line);
        try std.testing.expectEqual(column, issue.location.column);
        if (expected.message) |message| try std.testing.expect(std.mem.indexOf(u8, issue.message, message) != null);

        return;
    }

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}: {s}: {s}\n", .{ case.name, issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;
    const output = contract.types[@backingInt(contract.output_type)];

    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.input_scalar }, contract.types[@backingInt(contract.input_type)]);
    try std.testing.expectEqualStrings(case.output_kind, @tagName(std.meta.activeTag(output)));
    if (case.output_scalar) |scalar| try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = scalar }, output);
    try std.testing.expect(try compiler.validateIr(allocator, contract.program) == null);
}
