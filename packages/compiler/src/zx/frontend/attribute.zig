const std = @import("std");
const zx = @import("zx");
const dsl = @import("dsl");
const expression = @import("parse_expression.zig");

pub fn parseXml(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!dsl.XmlResult {
    if (!@import("parser_options").generated_parser) return dsl.parseXmlWith(allocator, source, boundary);

    const generated = @import("generated_xml");
    const adapter = @import("xml_adapter");
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const output = generated.execute(&scratch, &.{ .source = source, .expressions = true }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => {
            const message = try std.fmt.allocPrint(arena.allocator(), "internal compiler error: generated XML parser failed with {s}", .{@errorName(err)});

            return .{ .arena = arena, .value = .{ .diagnostic = .{
                .code = .syntax,
                .location = .{ .offset = 0, .line = 1, .column = 1 },
                .element = "",
                .message = message,
            } } };
        },
    };

    if (output.control.message.len != 0) {
        const message = try arena.allocator().dupe(u8, output.control.message);

        return .{ .arena = arena, .value = .{ .diagnostic = .{
            .code = .syntax,
            .location = adapter.location(output.control.issue),
            .element = "",
            .message = message,
        } } };
    }

    const owned_source = try arena.allocator().dupe(u8, source);
    const node = try adapter.convert(arena.allocator(), scratch.allocator(), owned_source, output);

    return .{ .arena = arena, .value = .{ .node = node } };
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
