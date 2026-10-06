const std = @import("std");
const zx = @import("zx");
const dsl = @import("dsl");
const template = @import("template");
const generated = @import("generated");
const adapter = @import("adapter");
const Diagnostic = struct { message: []const u8 = "", location: dsl.ast.Location = .{ .offset = 0, .line = 1, .column = 1 } };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const expressions = std.mem.eql(u8, args[2], "true");
    var expected = try dsl.parseXmlWith(allocator, source, if (expressions) boundary else null);

    defer expected.deinit();

    const actual = try generated.execute(init.arena, &.{ .source = source, .expressions = expressions });
    const expected_node: ?dsl.ast.Node = if (expected.value == .node) expected.value.node else null;
    const actual_node: ?dsl.ast.Node = if (actual.control.message.len == 0) try adapter.convert(allocator, actual) else null;
    const expected_issue: Diagnostic = if (expected.value == .diagnostic) .{ .message = expected.value.diagnostic.message, .location = expected.value.diagnostic.location } else .{};
    const actual_issue: Diagnostic = if (actual.control.message.len != 0) .{ .message = actual.control.message, .location = adapter.location(actual.control.issue) } else .{};
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .expected = .{ .node = expected_node, .diagnostic = expected_issue }, .actual = .{ .node = actual_node, .diagnostic = actual_issue } }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn boundary(source: []const u8, start: usize) dsl.ExpressionBoundary {
    var reporter = zx.Reporter{};

    const end = template.interpolationEnd(source, start, &reporter, 0) catch {
        return .{ .failure = .{ .offset = reporter.diagnostic.?.span.start, .message = reporter.diagnostic.?.message } };
    };

    return .{ .end = end };
}
