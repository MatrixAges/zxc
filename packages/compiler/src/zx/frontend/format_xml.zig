const std = @import("std");
const zx = @import("zx");
const dsl = @import("dsl");
const lint = @import("lint");
const lex = @import("lexer").lex;
const xml = @import("attribute.zig");

pub fn format(allocator: std.mem.Allocator, source: []const u8, node: dsl.ast.Node) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var edits: std.ArrayList(lint.spacing.Edit) = .empty;
    const newline: []const u8 = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n";

    try attributes(temporary, node, 0, &edits, newline);

    var values = source;
    var parsed: ?dsl.XmlResult = null;

    defer if (parsed) |*value| value.deinit();

    if (edits.items.len != 0) {
        values = try lint.spacing.format(temporary, source, edits.items);
        parsed = try xml.parseXml(temporary, values);

        std.debug.assert(parsed.?.value == .node);
    }

    const current = if (parsed) |value| value.value.node else node;
    const structured = try lint.rx.structure(temporary, values, current);

    if (std.mem.eql(u8, values, structured)) return lint.rx.format(allocator, values, current);

    var aligned = try xml.parseXml(temporary, structured);

    defer aligned.deinit();
    std.debug.assert(aligned.value == .node);

    return lint.rx.format(allocator, structured, aligned.value.node);
}

fn attributes(allocator: std.mem.Allocator, node: dsl.ast.Node, level: usize, edits: *std.ArrayList(lint.spacing.Edit), newline: []const u8) std.mem.Allocator.Error!void {
    for (node.attributes) |attribute| {
        if (attribute.kind != .expression) continue;

        const raw = attribute.raw_value.?;

        if (!lint.attribute_required(raw, level + 1, attribute.name.len + 2)) continue;

        var reporter: zx.Reporter = .{};

        const tokens = lex(allocator, raw, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            continue;
        };

        if (tokens.tokens.len <= 2 and std.mem.indexOfScalar(u8, raw, '\n') == null) continue;

        const projection = try lint.layout.Projection.init(allocator, raw, tokens.tokens, tokens.comments);
        const structured = try lint.layout.formatAttribute(allocator, raw, projection.tokens, level + 1, attribute.name.len + 2, newline);
        const text = std.mem.trimStart(u8, structured, " ");

        if (std.mem.eql(u8, raw, text)) continue;

        try edits.append(allocator, .{
            .span = .{ .start = attribute.value_location.offset, .end = attribute.value_location.offset + raw.len },
            .replacement = text,
        });
    }

    for (node.children) |child| try attributes(allocator, child, level + 1, edits, newline);
}
