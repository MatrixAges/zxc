const std = @import("std");
const zx = @import("zx");
const dsl = @import("dsl");
const expression = @import("parse_expression.zig");
const adapter = @import("xml_adapter");
pub const references = adapter.references;
pub const IndexedXml = struct { xml: dsl.XmlResult, references: ?*const references.Index = null };

pub fn parseXml(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!dsl.XmlResult {
    return (try parseDocument(allocator, source, false)).xml;
}

pub fn parseIndexedXml(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!IndexedXml {
    return parseDocument(allocator, source, true);
}

fn parseDocument(allocator: std.mem.Allocator, source: []const u8, comptime indexed: bool) std.mem.Allocator.Error!IndexedXml {
    if (!@import("parser_options").generated_parser) return .{ .xml = try dsl.parseXmlWith(allocator, source, boundary) };

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var parsed = try @import("xml_syntax.zig").parse(allocator, source);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        var issue = parsed.value.diagnostic;
        issue.message = try arena.allocator().dupe(u8, issue.message);

        return .{ .xml = .{ .arena = arena, .value = .{ .diagnostic = issue } } };
    }

    const owned_source = try arena.allocator().dupe(u8, source);

    const document = try adapter.convert(
        @import("generated_xml_slots").executeValue,
        @import("generated_xml_decode").executeValue,
        if (indexed) @import("generated_xml_references").executeValue else null,
        arena.allocator(),
        parsed.arena.allocator(),
        owned_source,
        parsed.value.document,
    );

    return .{ .xml = .{ .arena = arena, .value = .{ .node = document.node } }, .references = document.references };
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

    const owned_source = try temporary.dupe(u8, value);
    const owned_name = try temporary.dupe(u8, file_name);

    return .{ .arena = arena, .value = .{ .parsed = .{
        .source = owned_source,
        .file_name = owned_name,
        .lexed = .{ .tokens = &.{}, .comments = &.{} },
        .expression = node,
    } } };
}
