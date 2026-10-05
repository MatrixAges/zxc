const std = @import("std");
const zx = @import("zx");
const dsl = @import("dsl");
const expression = @import("parse_expression.zig");

pub fn parseXml(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!dsl.XmlResult {
    return dsl.parseXmlWith(allocator, source, boundary);
}

fn boundary(source: []const u8, start: usize) dsl.ExpressionBoundary {
    var reporter: zx.Reporter = .{};

    const end = @import("template.zig").interpolationEnd(source, start, &reporter, 0) catch {
        const issue = reporter.diagnostic.?;

        return .{ .failure = .{ .offset = issue.span.start, .message = issue.message } };
    };

    return .{ .end = end };
}

pub fn string(allocator: std.mem.Allocator, value: []const u8, file_name: []const u8) std.mem.Allocator.Error!expression.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const temporary = arena.allocator();
    const node = try temporary.create(zx.ast.Expression);

    node.* = .{ .span = .{ .start = 0, .end = value.len }, .depth = 1, .value = .{ .string = try std.json.Stringify.valueAlloc(temporary, value, .{}) } };

    return .{ .arena = arena, .value = .{ .parsed = .{
        .source = try temporary.dupe(u8, value),
        .file_name = try temporary.dupe(u8, file_name),
        .lexed = .{ .tokens = &.{}, .comments = &.{} },
        .expression = node,
    } } };
}
