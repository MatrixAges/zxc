const std = @import("std");
const zx = @import("zx");
const project = @import("../../modules/project.zig");
const generated = @import("generated_resource_scan");
const literal = @import("../string_literal.zig");
pub const Reference = struct { span: zx.Span, path: []const u8 };
pub const Origin = struct { expanded: zx.Span, reference: zx.Span, path: []const u8, source: []const u8 };
pub const Location = struct { path: []const u8, source: []const u8, offset: usize, reference: ?zx.Span = null };

pub fn references(allocator: std.mem.Allocator, source: []const u8, reporter: *zx.Reporter) zx.Error![]const Reference {
    if (std.mem.indexOf(u8, source, "templateFile") == null) return &.{};

    const lexed = try @import("lexer").lex(allocator, source, reporter);
    const Item = std.meta.Child(std.meta.Child(generated.Input));
    const tokens = try allocator.alloc(*const Item, lexed.tokens.len);
    const values = try allocator.alloc(Item, lexed.tokens.len);

    for (lexed.tokens, tokens, values) |token, *item, *value| {
        value.* = .{ .text = token.text(source), .start = token.span.start, .end = token.span.end, .quoted = token.kind == .string };
        item.* = value;
    }

    const output = generated.executeIn(allocator, tokens) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (output.invalid) return reporter.fail(.module, .{ .start = @intCast(output.start), .end = @intCast(output.end) }, "templateFile requires one static .tpl path");

    const result = try allocator.alloc(Reference, output.references.len);

    for (output.references, result) |reference, *item| item.* = .{
        .span = .{ .start = @intCast(reference.start), .end = @intCast(reference.end) },
        .path = try literal.decode(allocator, reference.literal[1 .. reference.literal.len - 1]),
    };

    return result;
}

pub fn resolve(allocator: std.mem.Allocator, owner: []const u8, reference: Reference, options: project.Options, reporter: *zx.Reporter) zx.Error![]const u8 {
    const path = reference.path;
    const scope = project.package_scope.owner(options.package_scopes, owner);
    const root = if (scope) |index| options.package_scopes[index].root else options.root_dir;

    if (options.package_scopes.len != 0 and scope == null) return reporter.fail(.module, reference.span, "template owner does not belong to a declared package");
    if (!std.mem.endsWith(u8, path, ".tpl") or std.mem.indexOfAny(u8, path, "\\\x00\r\n\t") != null) return reporter.fail(.module, reference.span, "templateFile requires a .tpl resource path");

    const target = if (std.mem.startsWith(u8, path, "@/"))
        try std.fs.path.resolve(allocator, &.{ root, path[2..] })

    else if (std.mem.startsWith(u8, path, "./") or std.mem.startsWith(u8, path, "../"))
        try std.fs.path.resolve(allocator, &.{ std.fs.path.dirname(owner) orelse ".", path })
    else
        return reporter.fail(.module, reference.span, "template paths require ./, ../ or @/");

    if (scope != null and project.package_scope.owner(options.package_scopes, target) != scope) return reporter.fail(.module, reference.span, "template reference crosses a package boundary");

    return target;
}

pub fn expand(allocator: std.mem.Allocator, source: project.Source, options: project.Options, reporter: *zx.Reporter) zx.Error!project.Source {
    return expandReferences(allocator, source, try references(allocator, source.source, reporter), options, reporter);
}

pub fn expandReferences(allocator: std.mem.Allocator, source: project.Source, refs: []const Reference, options: project.Options, reporter: *zx.Reporter) zx.Error!project.Source {
    if (refs.len == 0) return source;

    const owner = try std.fs.path.resolve(allocator, &.{ options.root_dir, source.path });
    var output: std.Io.Writer.Allocating = .init(allocator);
    var offset: usize = 0;
    var origins: std.ArrayList(Origin) = .empty;

    for (refs) |reference| {
        const path = try resolve(allocator, owner, reference, options, reporter);
        var text: ?[]const u8 = null;

        for (source.templates) |resource| {
            const resource_path = try std.fs.path.resolve(allocator, &.{ options.root_dir, resource.path });

            if (!std.mem.eql(u8, resource_path, path)) continue;
            if (text != null) return reporter.fail(.module, reference.span, "template resource paths must be unique after normalization");

            text = resource.source;
        }

        const content = text orelse return reporter.fail(.module, reference.span, "template resource is missing from the source inputs");
        const body = try std.mem.concat(allocator, u8, &.{ "`", content, "`" });
        var boundary: zx.Reporter = .{};

        const end = @import("../template.zig").end(body, 0, &boundary, 0) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            const issue = boundary.diagnostic.?;
            const position = zx.source.locate(content, issue.span.start -| 1);
            const message = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ path, position.line, position.column, issue.message });

            return reporter.fail(issue.code, reference.span, message);
        };

        if (end != body.len) return reporter.fail(.syntax, reference.span, "template resource contains an unescaped closing backtick");

        output.writer.writeAll(source.source[offset..reference.span.start]) catch return error.OutOfMemory;

        const start = output.written().len + 1;

        try origins.append(allocator, .{ .expanded = .{ .start = start, .end = start + content.len }, .reference = reference.span, .path = path, .source = content });

        output.writer.writeAll(body) catch return error.OutOfMemory;

        offset = reference.span.end;
    }

    output.writer.writeAll(source.source[offset..]) catch return error.OutOfMemory;

    return .{ .path = source.path, .source = try output.toOwnedSlice(), .original = source.source, .template_origins = try origins.toOwnedSlice(allocator) };
}

pub fn locate(source: project.Source, offset: usize) Location {
    var expanded_end: usize = 0;
    var original_end: usize = 0;

    for (source.template_origins) |origin| {
        if (offset < origin.expanded.start - 1) break;
        if (offset <= origin.expanded.end) return .{ .path = origin.path, .source = origin.source, .offset = offset -| origin.expanded.start, .reference = origin.reference };

        expanded_end = origin.expanded.end + 1;
        original_end = origin.reference.end;
    }

    return .{ .path = source.path, .source = source.original orelse source.source, .offset = offset - expanded_end + original_end };
}

pub fn diagnostic(allocator: std.mem.Allocator, source: project.Source, issue: zx.Diagnostic) std.mem.Allocator.Error!zx.Diagnostic {
    const origin = locate(source, issue.span.start);
    var result = issue;

    if (origin.reference) |reference| {
        const position = zx.source.locate(origin.source, origin.offset);
        result.message = try std.fmt.allocPrint(allocator, "{s}:{d}:{d}: {s}", .{ origin.path, position.line, position.column, issue.message });
        result.span = reference;
    } else result.span = .{ .start = origin.offset, .end = origin.offset + issue.span.end - issue.span.start };

    return result;
}
