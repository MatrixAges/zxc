const std = @import("std");
const zx = @import("zx");
const lint = @import("lint");
const Formatted = struct { text: []u8, first_change: ?zx.Span };
const Result = union(enum) { source: Formatted, diagnostic: zx.Diagnostic };

pub fn format(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var layout: Layout = .{
        .allocator = arena.allocator(),
        .source = source,
        .newline = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n",
    };

    if (comptime @import("parser_options").generated_parser) {
        const parsed = @import("generated_native_syntax").executeIn(layout.allocator, source) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
            else => unreachable,
        };

        const issue = parsed.diagnostic;

        if (issue.message.len != 0) return .{ .diagnostic = .{
            .code = std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), issue.code) orelse unreachable,
            .span = .{ .start = @intCast(issue.start), .end = @intCast(issue.end) },
            .message = try allocator.dupe(u8, issue.message),
            .message_allocator = allocator,
        } };

        for (parsed.declarations) |declaration| {
            if (declaration.enumeration) try layout.enumeration(zx.syntax.header.span(declaration.span));
        }
    } else {
        var reporter: zx.Reporter = .{};

        const parsed = @import("../modules/declarations.zig").parse(layout.allocator, source, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return .{ .diagnostic = try reporter.diagnostic.?.clone(allocator) };
        };

        for (parsed.types) |declaration| {
            if (declaration.value.* == .enumeration) try layout.enumeration(declaration.span);
        }
    }

    return .{ .source = .{
        .text = try lint.spacing.format(allocator, source, layout.edits.items),
        .first_change = if (layout.edits.items.len == 0) null else layout.edits.items[0].span,
    } };
}

const Layout = struct {
    allocator: std.mem.Allocator,
    source: []const u8,
    newline: []const u8,
    edits: std.ArrayList(lint.spacing.Edit) = .empty,
    fn enumeration(self: *Layout, span: zx.Span) std.mem.Allocator.Error!void {
        const text = self.source[span.start..span.end];
        var reporter: zx.Reporter = .{};

        const tokens = @import("lexer").lex(self.allocator, text, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            unreachable;
        };

        var projection = try lint.layout.Projection.init(self.allocator, text, tokens.tokens, tokens.comments);

        projection.multilineEnding(text.len);

        const formatted = try lint.layout.formatWithLineEnding(self.allocator, text, projection.tokens, lint.layout.use_default_width, 0, self.newline);

        if (!std.mem.eql(u8, text, formatted)) try self.edits.append(self.allocator, .{ .span = span, .replacement = formatted });
    }
};
