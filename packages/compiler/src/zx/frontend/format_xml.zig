const std = @import("std");
const zx = @import("zx");
const dsl = @import("dsl");
const lint = @import("lint");
const lex = @import("lexer").lex;
const indexed = @import("parser_options").generated_parser;
const Parsed = if (indexed) @import("xml_view.zig").Result else dsl.XmlResult;
const Node = if (indexed) @import("xml_view.zig").Node else lint.rx.NodeView;

pub const Result = union(enum) { source: []u8, diagnostic: zx.Diagnostic };

pub fn formatText(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!Result {
    var parsed: ?Parsed = try parse(allocator, source);

    defer release(&parsed);

    if (parsed.?.value == .diagnostic) {
        const issue = parsed.?.value.diagnostic;
        const diagnostic = zx.Diagnostic{ .code = .syntax, .span = .{ .start = issue.location.offset, .end = issue.location.offset }, .message = issue.message };

        return .{ .diagnostic = try diagnostic.clone(allocator) };
    }

    return .{ .source = try formatWith(allocator, source, root(&parsed.?), &parsed) };
}

pub fn format(allocator: std.mem.Allocator, source: []const u8, node: dsl.ast.Node) std.mem.Allocator.Error![]u8 {
    var parsed: ?Parsed = null;

    return formatWith(allocator, source, lint.rx.NodeView{ .node = node }, &parsed);
}

fn parse(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!Parsed {
    if (comptime indexed) return @import("xml_view.zig").parse(allocator, source);

    return @import("attribute.zig").parseXml(allocator, source);
}

fn root(parsed: *const Parsed) Node {
    if (comptime indexed) return parsed.value.document.root();

    return .{ .node = parsed.value.node };
}

fn release(parsed: *?Parsed) void {
    if (parsed.*) |*value| value.deinit();

    parsed.* = null;
}

fn reparse(parsed: *?Parsed, allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!void {
    release(parsed);

    parsed.* = try parse(allocator, source);

    std.debug.assert(parsed.*.?.value != .diagnostic);
}

fn formatWith(allocator: std.mem.Allocator, source: []const u8, node: anytype, parsed: *?Parsed) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();
    defer release(parsed);

    const temporary = arena.allocator();
    var edits: std.ArrayList(lint.spacing.Edit) = .empty;
    const newline: []const u8 = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n";

    try attributes(temporary, node, 0, &edits, newline);

    if (edits.items.len == 0) return finish(allocator, temporary, source, node, parsed);

    const values = try lint.spacing.format(temporary, source, edits.items);

    try reparse(parsed, allocator, values);

    return finish(allocator, temporary, values, root(&parsed.*.?), parsed);
}

fn finish(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: []const u8, node: anytype, parsed: *?Parsed) std.mem.Allocator.Error![]u8 {
    const structured = try lint.rx.structureView(temporary, source, node);

    if (std.mem.eql(u8, source, structured)) return lint.rx.formatView(allocator, source, node);
    try reparse(parsed, allocator, structured);

    return lint.rx.formatView(allocator, structured, root(&parsed.*.?));
}

fn attributes(allocator: std.mem.Allocator, node: anytype, level: usize, edits: *std.ArrayList(lint.spacing.Edit), newline: []const u8) std.mem.Allocator.Error!void {
    for (0..node.attributeCount()) |index| {
        const attribute = node.attribute(index);

        if (!attribute.expression) continue;

        const raw = attribute.raw.?;

        if (!lint.attribute_required(raw, level + 1, attribute.name.len + 2)) continue;

        var reporter: zx.Reporter = .{};

        const tokens = lex(allocator, raw, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            continue;
        };

        if (tokens.tokens.len <= 2 and std.mem.indexOfScalar(u8, raw, '\n') == null) continue;

        var projection = try lint.layout.Projection.init(allocator, raw, tokens.tokens, tokens.comments);
        const type_attribute = std.mem.eql(u8, node.name(), "Args") or (std.mem.eql(u8, node.name(), "Field") and std.mem.eql(u8, attribute.name, "type"));

        if (!type_attribute and std.mem.indexOfScalar(u8, raw, '[') != null) {
            var parsed = try @import("parse_expression.zig").parse(allocator, raw, "");

            defer parsed.deinit();

            if (parsed.value == .parsed) @import("layout.zig").expression(&projection, parsed.value.parsed.expression);
        }

        const structured = try lint.layout.formatAttribute(allocator, raw, projection.tokens, level + 1, attribute.name.len + 2, newline);
        const text = std.mem.trimStart(u8, structured, " ");

        if (std.mem.eql(u8, raw, text)) continue;

        try edits.append(allocator, .{
            .span = .{ .start = attribute.value_offset, .end = attribute.value_offset + raw.len },
            .replacement = text,
        });
    }

    var children = node.children();

    while (children.next()) |child| try attributes(allocator, child, level + 1, edits, newline);
}
